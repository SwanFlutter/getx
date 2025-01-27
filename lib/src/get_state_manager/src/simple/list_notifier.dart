import 'dart:collection';

import 'package:flutter/foundation.dart';

// Callback type for removing listeners
typedef Disposer = void Function();

// Callback type for state updates, ensuring the widget is mounted
typedef GetStateUpdate = void Function();

class ListNotifier extends Listenable with ListNotifierSingleMixin, ListNotifierGroupMixin {}

/// A Notifier with single listeners
class ListNotifierSingle = ListNotifier with ListNotifierSingleMixin;

/// A notifier with a group of listeners identified by an ID
class ListNotifierGroup = ListNotifier with ListNotifierGroupMixin;

/// Mixin that adds listener management to a Listenable
mixin ListNotifierSingleMixin on Listenable {
  // Stores the list of state update listeners
  List<GetStateUpdate>? _updaters = <GetStateUpdate>[];

  @override
  Disposer addListener(GetStateUpdate listener) {
    assert(_debugAssertNotDisposed());
    _updaters!.add(listener);
    return () => _updaters!.remove(listener);
  }

  /// Checks if a specific listener is already registered
  bool containsListener(GetStateUpdate listener) {
    return _updaters?.contains(listener) ?? false;
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _updaters!.remove(listener);
  }

  @protected
  void refresh() {
    assert(_debugAssertNotDisposed());
    _notifyUpdate();
  }

  /// Notifies all registered listeners of an update
  void _notifyUpdate() {
    final list = _updaters?.toList() ?? [];
    for (var element in list) {
      element();
    }
  }

  bool get isDisposed => _updaters == null;

  bool _debugAssertNotDisposed() {
    assert(() {
      if (isDisposed) {
        throw FlutterError('''A $runtimeType was used after being disposed.\n
Once you have called dispose() on a $runtimeType, it can no longer be used.''');
      }
      return true;
    }());
    return true;
  }

  int get listenersLength {
    assert(_debugAssertNotDisposed());
    return _updaters!.length;
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _updaters = null; // Clear the list of updaters on dispose
  }
}

mixin ListNotifierGroupMixin on Listenable {
  // Maps IDs to their corresponding notifier groups
  HashMap<Object?, ListNotifierSingleMixin>? _updatersGroupIds = HashMap<Object?, ListNotifierSingleMixin>();

  /// Notifies the listeners of a specific group identified by ID
  void _notifyGroupUpdate(Object id) {
    if (_updatersGroupIds!.containsKey(id)) {
      _updatersGroupIds![id]!._notifyUpdate();
    }
  }

  @protected
  void notifyGroupChildrens(Object id) {
    assert(_debugAssertNotDisposed());
    Notifier.instance.read(_updatersGroupIds![id]!);
  }

  bool containsId(Object id) {
    return _updatersGroupIds?.containsKey(id) ?? false;
  }

  @protected
  void refreshGroup(Object id) {
    assert(_debugAssertNotDisposed());
    _notifyGroupUpdate(id);
  }

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_updatersGroupIds == null) {
        throw FlutterError('''A $runtimeType was used after being disposed.\n
Once you have called dispose() on a $runtimeType, it can no longer be used.''');
      }
      return true;
    }());
    return true;
  }

  void removeListenerId(Object id, VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    if (_updatersGroupIds!.containsKey(id)) {
      _updatersGroupIds![id]!.removeListener(listener);
    }
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    // Dispose all group notifiers before clearing the map
    _updatersGroupIds?.forEach((key, value) => value.dispose());
    _updatersGroupIds = null; // Clear the map of group notifiers on dispose
  }

  /// Adds a listener to a specific group identified by key
  Disposer addListenerId(Object? key, GetStateUpdate listener) {
    _updatersGroupIds![key] ??= ListNotifierSingle();
    return _updatersGroupIds![key]!.addListener(listener);
  }

  /// Disposes the notifier associated with the specified ID from future updates.
  void disposeId(Object id) {
    _updatersGroupIds?[id]?.dispose();
    _updatersGroupIds!.remove(id);
  }
}

class Notifier {
  Notifier._();

  static Notifier? _instance;

  static Notifier get instance => _instance ??= Notifier._();

  NotifyData? _notifyData;

  /// Adds a listener to the notifier's data disposers.
  void add(VoidCallback listener) {
    _notifyData?.disposers.add(listener);
  }

  /// Registers a listener for updates in the specified notifier.
  void read(ListNotifierSingleMixin updaters) {
    final listener = _notifyData?.updater;

    if (listener != null && !updaters.containsListener(listener)) {
      updaters.addListener(listener);
      add(() => updaters.removeListener(listener));
    }
  }

  /// Appends data to the notifier and executes a builder function.
  T append<T>(NotifyData data, T Function() builder) {
    _notifyData = data;
    final result = builder();

    // Check for exceptions based on disposer's state.
    if (data.disposers.isEmpty && data.throwException) {
      throw const ObxError();
    }

    _notifyData = null; // Clear notify data after use.
    return result;
  }
}

class NotifyData {
  const NotifyData({
    required this.updater,
    required this.disposers,
    this.throwException = true,
  });

  final GetStateUpdate updater; // The update callback function.
  final List<VoidCallback> disposers; // The list of disposables.
  final bool throwException; // Flag to indicate whether to throw exceptions.
}

class ObxError implements Exception {
  // Changed to implement Exception for better error handling.
  const ObxError();

  @override
  String toString() {
    return """
       [Get] The improper use of GetX has been detected. 
       You should only use GetX or Obx for the specific widget that will be updated.
       If you are seeing this error, you probably did not insert any observable variables into GetX/Obx 
       or inserted them outside the scope that GetX considers suitable for an update 
       (example: GetX => HeavyWidget => variableObservable).
       If you need to update a parent widget and a child widget, wrap each one in an Obx/GetX.
       """;
  }
}
