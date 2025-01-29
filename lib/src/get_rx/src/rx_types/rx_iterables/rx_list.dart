part of '../rx_types.dart';

/// A reactive list implementation that extends [GetListenable] and implements [ListMixin].
///
/// Provides all standard list operations with reactive capabilities.
/// Any modifications to the list will trigger updates to listening widgets.
///
/// Example:
/// ```dart
/// final todos = RxList<String>(['Buy milk', 'Walk dog']);
/// todos.add('Write code');  // Triggers reactive update
/// ```
class RxList<E> extends GetListenable<List<E>> with ListMixin<E>, RxObjectMixin<List<E>> {
  /// Creates an empty reactive list.
  RxList([super.initial = const []]);

  /// Creates a fixed-length reactive list of the given [length].
  ///
  /// Example:
  /// ```dart
  /// final scores = RxList.filled(3, 0); // [0, 0, 0]
  /// ```
  factory RxList.filled(int length, E fill, {bool growable = false}) {
    return RxList(List.filled(length, fill, growable: growable));
  }

  /// Creates an empty reactive list with optional [growable] parameter.
  factory RxList.empty({bool growable = false}) {
    return RxList(List.empty(growable: growable));
  }

  /// Creates a reactive list from any [Iterable].
  ///
  /// Example:
  /// ```dart
  /// final numbers = RxList.from([1, 2, 3]);
  /// ```
  factory RxList.from(Iterable elements, {bool growable = true}) {
    return RxList(List.from(elements, growable: growable));
  }

  /// Creates a reactive list from an [Iterable] of the same type.
  factory RxList.of(Iterable<E> elements, {bool growable = true}) {
    return RxList(List.of(elements, growable: growable));
  }

  /// Creates a reactive list with generated values.
  ///
  /// Example:
  /// ```dart
  /// final squares = RxList.generate(3, (i) => i * i); // [0, 1, 4]
  /// ```
  factory RxList.generate(int length, E Function(int index) generator, {bool growable = true}) {
    return RxList(List.generate(length, generator, growable: growable));
  }

  /// Creates an unmodifiable reactive list.
  factory RxList.unmodifiable(Iterable elements) {
    return RxList(List.unmodifiable(elements));
  }

  /// List operations with reactive updates
  /// ----------------------------------

  @override
  Iterator<E> get iterator => value.iterator;

  /// Updates element at [index] and triggers reactive update.
  @override
  void operator []=(int index, E val) {
    value[index] = val;
    refresh();
  }

  /// Concatenates list with [val] and returns reactive list.
  @override
  RxList<E> operator +(Iterable<E> val) {
    addAll(val);
    return this;
  }

  @override
  E operator [](int index) => value[index];

  /// Adds element and triggers reactive update.
  @override
  void add(E element) {
    value.add(element);
    refresh();
  }

  /// Adds multiple elements and triggers reactive update.
  @override
  void addAll(Iterable<E> iterable) {
    value.addAll(iterable);
    refresh();
  }

  /// Removes element and triggers reactive update.
  @override
  bool remove(Object? element) {
    final removed = value.remove(element);
    refresh();
    return removed;
  }

  /// Removes elements matching [test] and triggers reactive update.
  @override
  void removeWhere(bool Function(E element) test) {
    value.removeWhere(test);
    refresh();
  }

  /// Retains elements matching [test] and triggers reactive update.
  @override
  void retainWhere(bool Function(E element) test) {
    value.retainWhere(test);
    refresh();
  }

  @override
  int get length => value.length;

  /// Updates list length and triggers reactive update.
  @override
  set length(int newLength) {
    value.length = newLength;
    refresh();
  }

  /// Inserts all elements at [index] and triggers reactive update.
  @override
  void insertAll(int index, Iterable<E> iterable) {
    value.insertAll(index, iterable);
    refresh();
  }

  @override
  Iterable<E> get reversed => value.reversed;

  /// Filtering and transformation methods
  /// ----------------------------------

  @override
  Iterable<E> where(bool Function(E) test) => value.where(test);

  @override
  Iterable<T> whereType<T>() => value.whereType<T>();

  /// Sorts the list and triggers reactive update.
  @override
  void sort([int Function(E a, E b)? compare]) {
    value.sort(compare);
    refresh();
  }
}

/// Extension methods for List<E> to add reactive capabilities.
extension ListExtension<E> on List<E> {
  /// Converts regular list to reactive list.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 3].obs;
  /// ```
  RxList<E> get obs => RxList<E>(this);

  /// Adds non-null items to the list.
  ///
  /// Example:
  /// ```dart
  /// list.addNonNull(item); // Only adds if item != null
  /// ```
  void addNonNull(E item) {
    if (item != null) add(item);
  }

  /// Conditionally adds item to the list.
  ///
  /// Example:
  /// ```dart
  /// list.addIf(user.isAdmin, 'Admin Panel');
  /// ```
  void addIf(dynamic condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Conditionally adds multiple items to the list.
  ///
  /// Example:
  /// ```dart
  /// list.addAllIf(user.isAdmin, ['Admin', 'Settings']);
  /// ```
  void addAllIf(dynamic condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  /// Replaces all items with single item.
  ///
  /// Example:
  /// ```dart
  /// list.assign('New Item'); // Clears list and adds single item
  /// ```
  void assign(E item) {
    if (this is RxList) {
      (this as RxList).value.clear();
    }
    add(item);
  }

  /// Replaces all items with new items.
  ///
  /// Example:
  /// ```dart
  /// list.assignAll(['New', 'Items']); // Replaces all existing items
  /// ```
  void assignAll(Iterable<E> items) {
    if (this is RxList) {
      (this as RxList).value.clear();
    }
    addAll(items);
  }
}
