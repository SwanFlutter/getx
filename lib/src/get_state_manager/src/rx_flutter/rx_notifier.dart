import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getx/src/get_instance/src/lifecycle.dart';
import 'package:getx/src/get_utils/src/equality/equality.dart';

import '../../../get_rx/src/rx_types/rx_types.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

// Extension to check if an object is empty
extension _Empty on Object {
  bool _isEmpty() {
    final val = this;
    var result = false;

    // Check for different types of emptiness
    if (val is Iterable) {
      result = val.isEmpty;
    } else if (val is String) {
      result = val.trim().isEmpty;
    } else if (val is Map) {
      result = val.isEmpty;
    }
    return result;
  }
}

// Mixin to manage state and status
mixin StateMixin<T> on ListNotifier {
  void reportRead() {
    // Implement the logic for reportRead here
  }
  T? _value; // Holds the current value
  GetStatus<T>? _status; // Holds the current status

  // Initializes the status based on the current value
  void _fillInitialStatus() {
    _status = (_value == null || (_value != null && _value!._isEmpty())) ? GetStatus<T>.loading() : GetStatus<T>.success(_value as T);
  }

  // Getter for status with read reporting
  GetStatus<T> get status {
    reportRead();
    return _status ??= GetStatus.loading();
  }

  // Getter for current state
  T get state => value;

  // Setter for status with refresh
  set status(GetStatus<T> newStatus) {
    if (newStatus == status) return;
    _status = newStatus;

    if (newStatus is SuccessStatus<T>) {
      _value = newStatus.data;
    }
    refresh();
  }

  @protected
  // Getter for value with read reporting
  T get value {
    reportRead();
    return _value as T;
  }

  @protected
  // Setter for value with refresh
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  @protected
  // Change the current status and refresh if necessary
  void change(GetStatus<T> status) {
    if (status != this.status) {
      this.status = status;
    }
  }

  // Set success status with data
  void setSuccess(T data) {
    change(GetStatus<T>.success(data));
  }

  // Set error status with error object
  void setError(Object error) {
    change(GetStatus<T>.error(error));
  }

  // Set loading status
  void setLoading() {
    change(GetStatus<T>.loading());
  }

  // Set empty status
  void setEmpty() {
    change(GetStatus<T>.empty());
  }

  // Execute a future function and update the state accordingly
  void futurize(Future<T> Function() body, {T? initialData, String? errorMessage, bool useEmpty = true}) {
    final compute = body;
    _value ??= initialData; // Initialize value if null
    status = GetStatus<T>.loading(); // Set loading status

    compute().then((newValue) {
      if ((newValue == null || newValue._isEmpty()) && useEmpty) {
        status = GetStatus<T>.empty(); // Set empty status if applicable
      } else {
        status = GetStatus<T>.success(newValue); // Set success status with new data
      }
      refresh(); // Refresh the state
    }, onError: (err) {
      status = GetStatus.error(err is Exception ? err : Exception(errorMessage ?? err.toString())); // Handle errors
      refresh(); // Refresh the state on error
    });
  }
}

// Type definition for a futurize callback function
typedef FuturizeCallback<T> = Future<T> Function(VoidCallback fn);

// Type definition for a callback function with no parameters
typedef VoidCallback = void Function();

// Class that allows listening to changes in a value and provides a stream interface
class GetListenable<T> extends ListNotifierSingle implements RxInterface<T> {
  void reportRead() {
    // Implement the logic for reportRead here
  }
  GetListenable(T val) : _value = val;

  StreamController<T>? _controller;

  StreamController<T> get subject {
    if (_controller == null) {
      _controller = StreamController<T>.broadcast(onCancel: addListener(_streamListener));
      _controller?.add(_value); // Emit initial value
    }
    return _controller!;
  }

  void _streamListener() {
    _controller?.add(_value); // Emit current value when notified
  }

  @override
  @mustCallSuper
  void close() {
    removeListener(_streamListener);
    _controller?.close(); // Close the stream controller on dispose
    dispose();
  }

  Stream<T> get stream => subject.stream; // Expose stream

  T _value; // Holds the current value

  @override
  T get value {
    reportRead();
    return _value;
  }

  void _notify() => refresh(); // Notify listeners of changes

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    _notify();
  }

  T? call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError ?? false,
      );

  @override
  String toString() => value.toString();
}

// Class representing a value that can be listened to and has state management capabilities.
class Value<T> extends ListNotifier with StateMixin<T> implements ValueListenable<T?> {
  Value(T val) {
    _value = val;
    _fillInitialStatus();
  }

  @override
  T get value {
    reportRead();
    return _value as T;
  }

  @override
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  T? call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  void update(T Function(T? value) fn) {
    value = fn(value);
    // refresh(); Uncomment if necessary to force refresh after update.
  }

  @override
  String toString() => value.toString();

  dynamic toJson() => (value as dynamic)?.toJson(); // Convert to JSON format.
}

/// Abstract class representing a notifier with lifecycle management capabilities.
abstract class GetNotifier<T> extends Value<T> with GetLifeCycleMixin {
  GetNotifier(super.initial);
}

// Extension method for StateMixin to build UI based on notifier state.
extension StateExt<T> on StateMixin<T> {
  Widget obx(
    BuildContext context,
    NotifierBuilder<T> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
    WidgetBuilder? onCustom,
  }) {
    return Obx(() {
      if (status.isLoading) {
        return onLoading ?? const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        return onError != null ? onError(status.errorMessage) : Center(child: Text('An error occurred: ${status.errorMessage}'));
      } else if (status.isEmpty) {
        return onEmpty ?? const SizedBox.shrink();
      } else if (status.isSuccess) {
        return widget(value);
      } else if (status.isCustom) {
        return onCustom?.call(context) ?? const SizedBox.shrink();
      }

      return widget(value);
    });
  }
}

// Type definition for a builder function that returns a widget based on state.
typedef NotifierBuilder<T> = Widget Function(T state);

// Abstract class representing different statuses of a notifier.
abstract class GetStatus<T> with Equality {
  const GetStatus();

  factory GetStatus.loading() => LoadingStatus<T>();

  factory GetStatus.error(Object message) => ErrorStatus<T, Object>(message);

  factory GetStatus.empty() => EmptyStatus<T>();

  factory GetStatus.success(T data) => SuccessStatus<T>(data);

  factory GetStatus.custom() => CustomStatus<T>();
}

// Class representing a custom status.
class CustomStatus<T> extends GetStatus<T> {
  @override
  List get props => [];
}

// Class representing a loading status.
class LoadingStatus<T> extends GetStatus<T> {
  @override
  List get props => [];
}

// Class representing a success status containing data.
class SuccessStatus<T> extends GetStatus<T> {
  final T data;

  const SuccessStatus(this.data);

  @override
  List get props => [data];
}

// Class representing an error status containing an error message.
class ErrorStatus<T, S> extends GetStatus<T> {
  final S? error;

  const ErrorStatus([this.error]);

  @override
  List get props => [error];
}

// Class representing an empty status.
class EmptyStatus<T> extends GetStatus<T> {
  @override
  List get props => [];
}

// Extension methods for handling different statuses.
extension StatusDataExt<T> on GetStatus<T> {
  bool get isLoading => this is LoadingStatus;

  bool get isSuccess => this is SuccessStatus;

  bool get isError => this is ErrorStatus;

  bool get isEmpty => this is EmptyStatus;

  bool get isCustom => !isLoading && !isSuccess && !isError && !isEmpty;

  dynamic get error {
    if (this is ErrorStatus) {
      return (this as ErrorStatus).error;
    }
    return null;
  }

  String get errorMessage {
    final isError = this is ErrorStatus;
    if (isError) {
      final err = this as ErrorStatus;
      if (err.error != null) {
        if (err.error is String) {
          return err.error as String;
        }
        return err.error.toString();
      }
    }
    return '';
  }

  T? get data {
    if (this is SuccessStatus<T>) {
      final success = this as SuccessStatus<T>;
      return success.data;
    }
    return null;
  }
}
