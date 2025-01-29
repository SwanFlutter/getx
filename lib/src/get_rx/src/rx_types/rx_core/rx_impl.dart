// ignore_for_file: unintended_html_in_doc_comment, avoid_shadowing_type_parameters

part of '../rx_types.dart';

/// global object that registers against `GetX` and `Obx`, and allows the
/// reactivity
/// of those `Widgets` and Rx values.

/// Mixin that provides reactivity for `GetX` and `Obx` widgets.
/// It allows these widgets to react to changes in Rx values.
mixin RxObjectMixin<T> on GetListenable<T> {
  final List<void Function()> _disposers = [];

  /// Registers a disposer function to be called when the object is disposed.
  void reportAdd(void Function() cancel) {
    _disposers.add(cancel);
  }
  //late T _value;

  /// Updates the [value] and adds it to the stream.
  /// Useful for custom types to refresh the UI.
  ///
  /// Example:
  /// ```dart
  /// class Person {
  ///   String name, last;
  ///   int age;
  ///   Person({this.name, this.last, this.age});
  ///   @override
  ///   String toString() => '$name $last, $age years old';
  /// }
  ///
  /// final person = Person(name: 'John', last: 'Doe', age: 18).obs;
  /// person.value.name = 'Roi';
  /// person.refresh();
  /// print(person);
  /// ```
  // void refresh() {
  //   subject.add(value);
  // }

  /// Updates the value to `null` and adds it to the stream.
  /// This is important for cases where `null` values are needed, such as
  /// `InputDecoration.errorText` which must be null to not show an error state.
  ///
  /// Example:
  /// ```dart
  /// final inputError = ''.obs..nil();
  /// print('${inputError.runtimeType}: $inputError'); // outputs > RxString: null
  /// ```
  // void nil() {
  //   subject.add(_value = null);
  // }

  /// Allows the Rx object to be called like a function to update its value.
  /// This is practical for assigning the Rx directly to a widget's onChange callback.
  ///
  /// Example:
  /// ```dart
  /// final myText = 'GetX rocks!'.obs;
  ///
  /// // in your Constructor, just to check it works :P
  /// ever(myText, print);
  ///
  /// // in your build(BuildContext) {
  /// TextField(
  ///   onChanged: myText,
  /// ),
  /// ```
  @override
  T call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  bool firstRebuild = true;
  bool sentToStream = false;

  /// Returns the string representation of the current value.
  String get string => value.toString();

  @override
  String toString() => value.toString();

  /// Returns the JSON representation of the current value.
  dynamic toJson() => value;

  /// Equality operator override to compare Rx values and internal values.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object o) {
    // Todo, find a common implementation for the hashCode of different Types.
    if (o is T) return value == o;
    if (o is RxObjectMixin<T>) return value == o.value;
    return false;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => value.hashCode;

  /// Updates the [value] and adds it to the stream, updating the observer
  /// widget only if it's different from the previous value.
  @override
  set value(T val) {
    if (isDisposed) return;
    sentToStream = false;
    if (value == val && !firstRebuild) return;
    firstRebuild = false;
    sentToStream = true;
    super.value = val;
  }

  /// Returns a [StreamSubscription] that primes the stream with the current [value].
  /// This should not be called during the build process.
  StreamSubscription<T> listenAndPump(void Function(T event) onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final subscription = listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );

    subject.add(value);

    return subscription;
  }

  /// Binds an existing `Stream<T>` to this Rx<T> to keep the values in sync.
  /// Automatically closes the subscription when the observer widget is unmounted.
  void bindStream<T>(Stream<T> stream, T Function(T)? onValue) {
    final sub = stream.listen(
      (va) {
        if (onValue != null) onValue(va);
      },
      onError: (error) {
        debugPrint('Stream Error: $error');
      },
      onDone: () {
        debugPrint('Stream is done.');
      },
    );
    reportAdd(() => sub.cancel());
  }

  @override
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
    _disposers.clear();
    super.dispose();
  }
}

/// Base Rx class that manages all the stream logic for any type.
abstract class _RxImpl<T> extends GetListenable<T> with RxObjectMixin<T> {
  _RxImpl(super.initial);

  /// Adds an error to the stream.
  void addError(Object error, [StackTrace? stackTrace]) {
    subject.addError(error, stackTrace);
  }

  /// Maps the stream to a new type using the provided [mapper] function.
  Stream<R> map<R>(R Function(T? data) mapper) => stream.map(mapper);

  /// Updates the [value] using a callback, similar to [refresh].
  /// Provides the current value as the argument.
  ///
  /// Example:
  /// ```dart
  /// class Person {
  ///   String name, last;
  ///   int age;
  ///   Person({this.name, this.last, this.age});
  ///   @override
  ///   String toString() => '$name $last, $age years old';
  /// }
  ///
  /// final person = Person(name: 'John', last: 'Doe', age: 18).obs;
  /// person.update((person) {
  ///   person.name = 'Roi';
  /// });
  /// print(person);
  /// ```
  void update(T Function(T? val) fn) {
    value = fn(value);
    // subject.add(value);
  }

  /// Triggers the listeners even if the value is the same.
  /// Useful for certain Rx data practices where reactivity is needed
  /// regardless of value changes.
  ///
  /// Example:
  /// ```dart
  /// Rx<int> secondsRx = RxInt();
  /// secondsRx.listen((value) => print("$value seconds set"));
  ///
  /// secondsRx.call(2);      // This won't trigger any listener, since the value is the same
  /// secondsRx.trigger(2);   // This will trigger the listener independently from the value.
  /// ```
  void trigger(T v) {
    var firstRebuild = this.firstRebuild;
    value = v;
    // If it's not the first rebuild, the listeners have been called already
    // So we won't call them again.
    if (!firstRebuild && !sentToStream) {
      subject.add(v);
    }
  }
}

class RxBool extends Rx<bool> {
  RxBool(super.initial);
  @override
  String toString() {
    return value ? "true" : "false";
  }
}

class RxnBool extends Rx<bool?> {
  RxnBool([super.initial]);
  @override
  String toString() {
    return "$value";
  }
}

extension RxBoolExt on Rx<bool> {
  bool get isTrue => value;

  bool get isFalse => !isTrue;

  bool operator &(bool other) => other && value;

  bool operator |(bool other) => other || value;

  bool operator ^(bool other) => !other == value;

  /// Toggles the bool [value] between false and true.
  /// A shortcut for `flag.value = !flag.value;`
  void toggle() {
    call(!value);
    // return this;
  }
}

extension RxnBoolExt on Rx<bool?> {
  bool? get isTrue => value;

  bool? get isFalse {
    if (value != null) return !isTrue!;
    return null;
  }

  bool? operator &(bool other) {
    if (value != null) {
      return other && value!;
    }
    return null;
  }

  bool? operator |(bool other) {
    if (value != null) {
      return other || value!;
    }
    return null;
  }

  bool? operator ^(bool other) => !other == value;

  /// Toggles the bool [value] between false and true.
  /// A shortcut for `flag.value = !flag.value;`
  void toggle() {
    if (value != null) {
      call(!value!);
      // return this;
    }
  }
}

/// Foundation class used for custom `Types` outside the common native Dart
/// types.
/// For example, any custom "Model" class, like User().obs will use `Rx` as
/// wrapper.
class Rx<T> extends _RxImpl<T> {
  Rx(super.initial);

  @override
  dynamic toJson() {
    try {
      return (value as dynamic)?.toJson();
    } on Exception catch (_) {
      throw '$T has not method [toJson]';
    }
  }
}

class Rxn<T> extends Rx<T?> {
  Rxn([super.initial]);

  @override
  dynamic toJson() {
    try {
      return (value as dynamic)?.toJson();
    } on Exception catch (_) {
      throw '$T has not method [toJson]';
    }
  }
}

extension StringExtension on String {
  /// Returns a `RxString` with [this] `String` as initial value.
  RxString get obs => RxString(this);
}

extension IntExtension on int {
  /// Returns a `RxInt` with [this] `int` as initial value.
  RxInt get obs => RxInt(this);
}

extension DoubleExtension on double {
  /// Returns a `RxDouble` with [this] `double` as initial value.
  RxDouble get obs => RxDouble(this);
}

extension BoolExtension on bool {
  /// Returns a `RxBool` with [this] `bool` as initial value.
  RxBool get obs => RxBool(this);
}

extension RxT<T extends Object> on T {
  /// Returns a `Rx` instance with [this] `T` as initial value.
  Rx<T> get obs => Rx<T>(this);
}

/// This method will replace the old `.obs` method.
/// It's a breaking change, but it is essential to avoid conflicts with
/// the new dart 3 features. T will be inferred by contextual type inference
/// rather than the extension type.
extension RxTnew on Object {
  /// Returns a `Rx` instance with [this] `T` as initial value.
  Rx<T> obs<T>() => Rx<T>(this as T);
}
