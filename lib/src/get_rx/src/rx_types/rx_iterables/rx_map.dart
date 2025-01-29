// ignore_for_file: unintended_html_in_doc_comment

part of '../rx_types.dart';

/// A reactive map implementation that extends [GetListenable] and implements [MapMixin].
///
/// Provides all standard map operations with reactive capabilities.
/// Any modifications to the map will trigger updates to listening widgets.
///
/// Example:
/// ```dart
/// final settings = RxMap<String, dynamic>({
///   'theme': 'dark',
///   'notifications': true
/// });
/// settings['theme'] = 'light'; // Triggers reactive update
/// ```
class RxMap<K, V> extends GetListenable<Map<K, V>> with MapMixin<K, V>, RxObjectMixin<Map<K, V>> {
  /// Creates an empty reactive map.
  RxMap([super.initial = const {}]);

  /// Creates a reactive map from an existing map.
  ///
  /// Example:
  /// ```dart
  /// final original = {'name': 'GetX', 'type': 'framework'};
  /// final reactive = RxMap.from(original);
  /// ```
  factory RxMap.from(Map<K, V> other) {
    return RxMap(Map.from(other));
  }

  /// Creates a [LinkedHashMap] with the same keys and values.
  ///
  /// Example:
  /// ```dart
  /// final config = RxMap.of({'debug': true, 'api': 'v1'});
  /// ```
  factory RxMap.of(Map<K, V> other) {
    return RxMap(Map.of(other));
  }

  /// Creates an unmodifiable reactive map.
  ///
  /// Useful for read-only map requirements.
  /// ```dart
  /// final constants = RxMap.unmodifiable({
  ///   'pi': 3.14,
  ///   'gravity': 9.81
  /// });
  /// ```
  factory RxMap.unmodifiable(Map<dynamic, dynamic> other) {
    return RxMap(Map.unmodifiable(other));
  }

  /// Creates an identity map with [LinkedHashMap] implementation.
  ///
  /// Useful when key equality is determined by identity rather than value.
  factory RxMap.identity() {
    return RxMap(Map.identity());
  }

  /// Map operations with reactive updates
  /// ----------------------------------

  /// Gets the value for the given [key].
  @override
  V? operator [](Object? key) {
    return value[key as K];
  }

  /// Sets the value for the given [key] and triggers reactive update.
  @override
  void operator []=(K key, V value) {
    this.value[key] = value;
    refresh();
  }

  /// Removes all entries and triggers reactive update.
  @override
  void clear() {
    value.clear();
    refresh();
  }

  /// Returns an [Iterable] of all keys.
  @override
  Iterable<K> get keys => value.keys;

  /// Removes the entry for the given [key] and triggers reactive update.
  ///
  /// Returns the value associated with [key] before it was removed.
  /// Returns null if [key] was not in the map.
  @override
  V? remove(Object? key) {
    final val = value.remove(key);
    refresh();
    return val;
  }

  /// Updates the map with new values while preserving reactivity.
  ///
  /// Example:
  /// ```dart
  /// map.updateMap({'newKey': 'newValue'});
  /// ```
  void updateMap(Map<K, V> newMap) {
    value = newMap;
    refresh();
  }
}

/// Extension methods for Map<K, V> to add reactive capabilities.
extension MapExtension<K, V> on Map<K, V> {
  /// Converts regular map to reactive map.
  ///
  /// Example:
  /// ```dart
  /// final userInfo = {'name': 'John', 'age': 30}.obs;
  /// ```
  RxMap<K, V> get obs => RxMap<K, V>(this);

  /// Conditionally adds entry to the map.
  ///
  /// Example:
  /// ```dart
  /// map.addIf(user.isAdmin, 'role', 'admin');
  /// ```
  void addIf(dynamic condition, K key, V value) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) {
      this[key] = value;
    }
  }

  /// Conditionally adds multiple entries to the map.
  ///
  /// Example:
  /// ```dart
  /// map.addAllIf(
  ///   user.isPremium,
  ///   {'features': 'premium', 'ads': false}
  /// );
  /// ```
  void addAllIf(dynamic condition, Map<K, V> values) {
    if (condition is Condition) condition = condition();
    if (condition is bool && condition) addAll(values);
  }

  /// Replaces all entries with a single key-value pair.
  ///
  /// Example:
  /// ```dart
  /// map.assign('status', 'active'); // Clears map and adds single entry
  /// ```
  void assign(K key, V val) {
    if (this is RxMap) {
      final map = (this as RxMap);
      map.value.clear();
      map[key] = val;
    } else {
      clear();
      this[key] = val;
    }
  }

  /// Replaces all entries with entries from another map.
  ///
  /// Optimized to avoid unnecessary updates for identical maps.
  ///
  /// Example:
  /// ```dart
  /// map.assignAll({'name': 'GetX', 'version': '4.0'});
  /// ```
  void assignAll(Map<K, V> val) {
    if (val is RxMap && this is RxMap) {
      if ((val as RxMap).value == (this as RxMap).value) return;
    }
    if (this is RxMap) {
      final map = (this as RxMap);
      if (map.value == val) return;
      map.updateMap(val);
    } else {
      if (this == val) return;
      clear();
      addAll(val);
    }
  }
}
