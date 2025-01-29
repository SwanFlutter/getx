part of '../rx_types.dart';

/// Extension methods for reactive String operations.
/// Provides common string manipulation methods with reactive support.
///
/// Example:
/// ```dart
/// final name = RxString('GetX');
/// name.value = name + ' Framework';  // "GetX Framework"
/// if (name.contains('GetX')) {
///   print('Contains GetX');
/// }
/// ```
extension RxStringExt on Rx<String> {
  /// Concatenates this string with [val].
  /// Returns a new string without modifying the original.
  String operator +(String val) => value + val;

  /// String comparison methods
  ///-----------------------

  /// Compares this string to [other] lexicographically.
  int compareTo(String other) => value.compareTo(other);

  /// Pattern matching methods
  ///-----------------------

  /// Checks if the string ends with [other].
  /// ```dart
  /// final text = RxString('Hello.dart');
  /// print(text.endsWith('.dart')); // true
  /// ```
  bool endsWith(String other) => value.endsWith(other);

  /// Checks if the string starts with [pattern] at position [index].
  /// ```dart
  /// final text = RxString('Hello');
  /// print(text.startsWith('He')); // true
  /// ```
  bool startsWith(Pattern pattern, [int index = 0]) => value.startsWith(pattern, index);

  /// Search and position methods
  ///-----------------------

  /// Finds the first occurrence of [pattern] starting from [start].
  /// Returns -1 if not found.
  int indexOf(Pattern pattern, [int start = 0]) => value.indexOf(pattern, start);

  /// Finds the last occurrence of [pattern] starting from [start].
  /// Returns -1 if not found.
  int lastIndexOf(Pattern pattern, [int? start]) => value.lastIndexOf(pattern, start);

  /// String state checks
  ///-----------------------

  /// Whether the string is empty.
  bool get isEmpty => value.isEmpty;

  /// Whether the string is not empty.
  bool get isNotEmpty => !isEmpty;

  /// String manipulation methods
  ///-----------------------

  /// Extracts a substring from [startIndex] to [endIndex].
  /// ```dart
  /// final text = RxString('Hello World');
  /// print(text.substring(0, 5)); // "Hello"
  /// ```
  String substring(int startIndex, [int? endIndex]) => value.substring(startIndex, endIndex);

  /// Whitespace handling methods
  ///-----------------------

  /// Removes leading and trailing whitespace.
  String trim() => value.trim();

  /// Removes leading whitespace.
  String trimLeft() => value.trimLeft();

  /// Removes trailing whitespace.
  String trimRight() => value.trimRight();

  /// Padding methods
  ///-----------------------

  /// Adds padding to the left side of the string.
  /// ```dart
  /// final num = RxString('42');
  /// print(num.padLeft(5, '0')); // "00042"
  /// ```
  String padLeft(int width, [String padding = ' ']) => value.padLeft(width, padding);

  /// Adds padding to the right side of the string.
  String padRight(int width, [String padding = ' ']) => value.padRight(width, padding);

  /// Pattern matching and replacement
  ///-----------------------

  /// Checks if string contains [other] starting from [startIndex].
  bool contains(Pattern other, [int startIndex = 0]) => value.contains(other, startIndex);

  /// Replaces all occurrences of [from] with [replace].
  /// ```dart
  /// final text = RxString('Hello World');
  /// print(text.replaceAll('o', '0')); // "Hell0 W0rld"
  /// ```
  String replaceAll(Pattern from, String replace) => value.replaceAll(from, replace);

  /// Splits string using [pattern] as delimiter.
  List<String> split(Pattern pattern) => value.split(pattern);

  /// String properties
  ///-----------------------

  /// Returns the UTF-16 code units of the string.
  List<int> get codeUnits => value.codeUnits;

  /// Returns the Unicode code points of the string.
  Runes get runes => value.runes;

  /// Case conversion methods
  ///-----------------------

  /// Converts string to lowercase.
  String toLowerCase() => value.toLowerCase();

  /// Converts string to uppercase.
  String toUpperCase() => value.toUpperCase();

  /// Pattern matching methods
  ///-----------------------

  /// Finds all matches of [string] starting from [start].
  Iterable<Match> allMatches(String string, [int start = 0]) => value.allMatches(string, start);

  /// Finds match at the start of the string.
  Match? matchAsPrefix(String string, [int start = 0]) => value.matchAsPrefix(string, start);
}

/// Extension methods for nullable reactive String operations.
/// Similar to [RxStringExt] but handles null values safely.
extension RxnStringExt on Rx<String?> {
  /// Concatenates this string with [val].
  /// Returns a new string without modifying the original.
  String operator +(String val) => (value ?? '') + val;

  /// String comparison methods
  ///-----------------------

  /// Compares this string to [other] lexicographically.
  int? compareTo(String other) => value?.compareTo(other);

  /// Pattern matching methods
  ///-----------------------

  /// Checks if the string ends with [other].
  /// ```dart
  /// final text = RxnString('Hello.dart');
  /// print(text.endsWith('.dart')); // true
  /// ```
  bool? endsWith(String other) => value?.endsWith(other);

  /// Checks if the string starts with a match of [pattern].
  /// ```dart
  /// final text = RxnString('Hello');
  /// print(text.startsWith('He')); // true
  /// ```
  bool? startsWith(Pattern pattern, [int index = 0]) => value?.startsWith(pattern, index);

  /// Search and position methods
  ///-----------------------

  /// Finds the first occurrence of [pattern] in this string
  int? indexOf(Pattern pattern, [int start = 0]) => value?.indexOf(pattern, start);

  /// Finds the last occurrence of [pattern] in this string,
  /// searching backward starting at [start], inclusive:
  int? lastIndexOf(Pattern pattern, [int? start]) => value?.lastIndexOf(pattern, start);

  /// String state checks
  ///-----------------------

  /// Returns true if this string is empty.
  bool? get isEmpty => value?.isEmpty;

  /// Returns true if this string is not empty.
  bool? get isNotEmpty => value?.isNotEmpty;

  /// String manipulation methods
  ///-----------------------

  /// Returns the substring of this string that extends from [startIndex],
  /// inclusive, to [endIndex], exclusive
  String? substring(int startIndex, [int? endIndex]) => value?.substring(startIndex, endIndex);

  /// Whitespace handling methods
  ///-----------------------

  /// Returns the string without any leading and trailing whitespace.
  String? trim() => value?.trim();

  /// Returns the string without any leading whitespace.
  ///
  /// As [trim], but only removes leading whitespace.
  String? trimLeft() => value?.trimLeft();

  /// Returns the string without any trailing whitespace.
  ///
  /// As [trim], but only removes trailing whitespace.
  String? trimRight() => value?.trimRight();

  /// Pads this string on the left if it is shorter than [width].
  ///
  /// Return a new string that prepends [padding] onto this string
  /// one time for each position the length is less than [width].
  String? padLeft(int width, [String padding = ' ']) => value?.padLeft(width, padding);

  /// Pads this string on the right if it is shorter than [width].

  /// Return a new string that appends [padding] after this string
  /// one time for each position the length is less than [width].
  String? padRight(int width, [String padding = ' ']) => value?.padRight(width, padding);

  /// Pattern matching and replacement
  ///-----------------------

  /// Returns true if this string contains a match of [other]:
  bool? contains(Pattern other, [int startIndex = 0]) => value?.contains(other, startIndex);

  /// Replaces all substrings that match [from] with [replace].
  String? replaceAll(Pattern from, String replace) => value?.replaceAll(from, replace);

  /// Splits the string at matches of [pattern] and returns a list
  /// of substrings.
  List<String>? split(Pattern pattern) => value?.split(pattern);

  /// String properties
  ///-----------------------

  /// Returns an unmodifiable list of the UTF-16 code units of this string.
  List<int>? get codeUnits => value?.codeUnits;

  /// Returns an [Iterable] of Unicode code-points of this string.
  ///
  /// If the string contains surrogate pairs, they are combined and returned
  /// as one integer by this iterator. Unmatched surrogate halves are treated
  /// like valid 16-bit code-units.
  Runes? get runes => value?.runes;

  /// Case conversion methods
  ///-----------------------

  /// Converts all characters in this string to lower case.
  /// If the string is already in all lower case, this method returns `this`.
  String? toLowerCase() => value?.toLowerCase();

  /// Converts all characters in this string to upper case.
  /// If the string is already in all upper case, this method returns `this`.
  String? toUpperCase() => value?.toUpperCase();

  /// Pattern matching methods
  ///-----------------------

  /// Finds all matches of [string] starting from [start].
  Iterable<Match>? allMatches(String string, [int start = 0]) => value?.allMatches(string, start);

  /// Finds match at the start of the string.
  Match? matchAsPrefix(String string, [int start = 0]) => value?.matchAsPrefix(string, start);
}

/// Reactive String class with built-in string operations.
///
/// Example:
/// ```dart
/// final name = RxString('GetX');
/// name.value = 'Flutter GetX';
/// print(name.value.length);
/// ```
class RxString extends Rx<String> implements Comparable<String>, Pattern {
  RxString(super.initial);

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) => value.allMatches(string, start);

  @override
  Match? matchAsPrefix(String string, [int start = 0]) => value.matchAsPrefix(string, start);

  @override
  int compareTo(String other) => value.compareTo(other);
}

/// Nullable reactive String class.
///
/// Example:
/// ```dart
/// final nullableName = RxnString();
/// print(nullableName.value); // null
/// nullableName.value = 'GetX';
/// ```
class RxnString extends Rx<String?> implements Comparable<String>, Pattern {
  RxnString([super.initial]);

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) => value!.allMatches(string, start);

  @override
  Match? matchAsPrefix(String string, [int start = 0]) => value!.matchAsPrefix(string, start);

  @override
  int compareTo(String other) => value!.compareTo(other);
}
