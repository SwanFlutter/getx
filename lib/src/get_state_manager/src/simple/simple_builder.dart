import 'dart:async';

import 'package:flutter/widgets.dart';

import 'list_notifier.dart';

typedef ValueBuilderUpdateCallback<T> = void Function(T snapshot);
typedef ValueBuilderBuilder<T> = Widget Function(T snapshot, ValueBuilderUpdateCallback<T> updater);

/// A widget that manages a local state similar to ObxValue,
/// but uses a callback instead of a reactive value.
///
/// Example:
/// ```
/// ValueBuilder<bool>(
///   initialValue: false,
///   builder: (value, update) => Switch(
///     value: value,
///     onChanged: (flag) {
///       update(flag);
///     },
///   ),
///   onUpdate: (value) => print("Value updated: $value"),
/// ),
/// ```
class ValueBuilder<T> extends StatefulWidget {
  /// The initial value of the state.
  final T initialValue;

  /// A builder function that takes the current value and an update callback.
  final ValueBuilderBuilder<T> builder;

  /// Optional callback that is called when the widget is disposed.
  final void Function()? onDispose;

  /// Optional callback that is called when the value is updated.
  final void Function(T)? onUpdate;

  const ValueBuilder({
    super.key,
    required this.initialValue,
    this.onDispose,
    this.onUpdate,
    required this.builder,
  });

  @override
  ValueBuilderState<T> createState() => ValueBuilderState<T>();
}

class ValueBuilderState<T> extends State<ValueBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue; // Initialize the state with the initial value
  }

  @override
  Widget build(BuildContext context) => widget.builder(value, updater);

  /// Updates the state with a new value and calls the onUpdate callback.
  void updater(T newValue) {
    if (widget.onUpdate != null) {
      widget.onUpdate!(newValue);
    }
    setState(() {
      value = newValue;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDispose?.call(); // Call the dispose callback if provided
    // Dispose of ChangeNotifier or StreamController if applicable
    if (value is ChangeNotifier) {
      (value as ChangeNotifier?)?.dispose();
    } else if (value is StreamController) {
      (value as StreamController?)?.close();
    }
  }
}

/// A stateless element that can observe reactive changes.
class ObxElement = StatelessElement with StatelessObserverComponent;

/// A stateless widget that listens for reactive changes.
abstract class ObxStatelessWidget extends StatelessWidget {
  /// Initializes [key] for subclasses.
  const ObxStatelessWidget({super.key});

  @override
  StatelessElement createElement() => ObxElement(this);
}

/// A mixin for components that can track changes in a reactive variable.
mixin StatelessObserverComponent on StatelessElement {
  List<Disposer>? disposers = <Disposer>[]; // List of disposers for listeners

  /// Schedules a rebuild if there are disposers registered.
  void getUpdate() {
    if (disposers != null) {
      scheduleMicrotask(markNeedsBuild);
    }
  }

  @override
  Widget build() {
    return Notifier.instance.append(NotifyData(disposers: disposers!, updater: getUpdate), super.build);
  }

  @override
  void unmount() {
    super.unmount();
    // Dispose of all registered listeners
    for (final disposer in disposers!) {
      disposer();
    }
    disposers!.clear(); // Clear the list of disposers
    disposers = null;
  }
}
