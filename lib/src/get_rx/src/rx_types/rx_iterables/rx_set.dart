part of '../rx_types.dart';

/// A reactive set implementation that extends [GetListenable] and implements [SetMixin].
///
/// Provides all standard set operations with reactive capabilities.
/// Any modifications to the set will trigger updates to listening widgets.
///
/// Example:
/// ```dart
/// final tags = RxSet<String>({'flutter', 'dart'});
/// tags.add('getx'); // Triggers reactive update
/// ```
class RxSet<E> extends GetListenable<Set<E>> with SetMixin<E>, RxObjectMixin<Set<E>> {
  /// Creates an empty reactive set or with initial values.
  RxSet([super.initial = const {}]);

  /// Combines this set with another set reactively.
  ///
  /// Example:
  /// ```dart
  /// final result = set1 + set2;
  /// ```
  RxSet<E> operator +(Set<E> val) {
    addAll(val);
    return this;
  }

  /// Updates the set using a callback function.
  ///
  /// Example:
  /// ```dart
  /// set.update((current) {
  ///   current?.add('newItem');
  /// });
  /// ```
  void update(void Function(Iterable<E>? value) fn) {
    fn(value);
    _notifyUpdate();
  }

  /// Set modification methods
  /// -----------------------

  /// Adds an element to the set and triggers update if successful.
  @override
  bool add(E value) {
    final hasAdded = this.value.add(value);
    if (hasAdded) {
      _notifyUpdate();
    }
    return hasAdded;
  }

  /// Checks if an element exists in the set.
  @override
  bool contains(Object? element) => value.contains(element);

  /// Returns an iterator for the set's elements.
  @override
  Iterator<E> get iterator => value.iterator;

  /// Returns the number of elements in the set.
  @override
  int get length => value.length;

  /// Looks up an element in the set.
  @override
  E? lookup(Object? element) => value.lookup(element);

  /// Removes an element from the set and triggers update if successful.
  @override
  bool remove(Object? value) {
    final hasRemoved = this.value.remove(value);
    if (hasRemoved) {
      _notifyUpdate();
    }
    return hasRemoved;
  }

  /// Creates a new non-reactive copy of the set.
  @override
  Set<E> toSet() => value.toSet();

  /// Bulk modification methods
  /// ------------------------

  /// Adds multiple elements to the set.
  @override
  void addAll(Iterable<E> elements) {
    value.addAll(elements);
    _notifyUpdate();
  }

  /// Removes all elements from the set.
  @override
  void clear() {
    value.clear();
    _notifyUpdate();
  }

  /// Removes multiple elements from the set.
  @override
  void removeAll(Iterable<Object?> elements) {
    value.removeAll(elements);
    _notifyUpdate();
  }

  /// Retains only specified elements in the set.
  @override
  void retainAll(Iterable<Object?> elements) {
    value.retainAll(elements);
    _notifyUpdate();
  }

  /// Retains elements that satisfy the test.
  @override
  void retainWhere(bool Function(E) test) {
    value.retainWhere(test);
    _notifyUpdate();
  }

  /// Internal update notification
  void _notifyUpdate() {
    refresh();
  }
}

/// Extension methods for Set<E> to add reactive capabilities.
extension SetExtension<E> on Set<E> {
  /// Converts regular set to reactive set.
  ///
  /// Example:
  /// ```dart
  /// final reactiveSet = {'a', 'b', 'c'}.obs;
  /// ```
  RxSet<E> get obs {
    return RxSet<E>(<E>{})..addAll(this);
  }

  /// Conditionally adds an item to the set.
  ///
  /// Example:
  /// ```dart
  /// set.addIf(user.isAdmin, 'ADMIN_ROLE');
  /// ```
  void addIf(dynamic condition, E item) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) add(item);
  }

  /// Conditionally adds multiple items to the set.
  ///
  /// Example:
  /// ```dart
  /// set.addAllIf(user.isPremium, {'PREMIUM', 'NO_ADS'});
  /// ```
  void addAllIf(dynamic condition, Iterable<E> items) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(items);
  }

  /// Replaces all existing items with a single item.
  ///
  /// Example:
  /// ```dart
  /// set.assign('single_item');
  /// ```
  void assign(E item) {
    clear();
    add(item);
  }

  /// Replaces all existing items with new items.
  ///
  /// Example:
  /// ```dart
  /// set.assignAll({'new', 'items'});
  /// ```
  void assignAll(Iterable<E> items) {
    clear();
    addAll(items);
  }
}
