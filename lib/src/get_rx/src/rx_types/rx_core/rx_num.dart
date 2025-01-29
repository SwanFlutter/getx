part of '../rx_types.dart';

/// Base class for reactive numeric types with enhanced error handling and safety features.
abstract class RxNumBase<T extends num> extends Rx<T> {
  RxNumBase(super.initial);

  /// Safely executes numeric operations with comprehensive error handling.
  T? safeOperation(T? other, T Function(T a, T b) operation) {
    if (other != null) {
      try {
        return operation(value, other);
      } catch (e) {
        Get.log('Error in numeric operation: $e', isError: true);
        return null;
      }
    }
    return null;
  }
}

/// Enhanced reactive double type with additional safety features and validations.
class RxDouble extends RxNumBase<double> {
  RxDouble(super.initial);

  /// Performs addition with improved type safety.
  RxDouble operator +(num other) {
    value = value + other;
    return this;
  }

  /// Performs division with zero check protection.
  double operator /(num other) {
    if (other == 0) {
      Get.log('Division by zero attempted', isError: true);
      throw UnsupportedError('Division by zero');
    }
    return value / other;
  }

  /// Checks if the current value is within the specified range.
  bool isInRange(double min, double max) => value >= min && value <= max;
}

/// Enhanced reactive integer type with bit operations and validation features.
class RxInt extends RxNumBase<int> {
  RxInt(super.initial);

  /// Optimized bitwise operations
  int operator &(int other) => value & other;
  int operator |(int other) => value | other;
  int operator ^(int other) => value ^ other;

  /// Checks if the current value is divisible by the specified divisor.
  bool isDivisibleBy(int divisor) {
    if (divisor == 0) return false;
    return value % divisor == 0;
  }

  /// Constrains the current value within the specified range.
  RxInt clamp(int lower, int upper) {
    value = value.clamp(lower, upper);
    return this;
  }
}

/// Extension providing additional numeric utilities for reactive types.
extension RxNumExtension<T extends num> on Rx<T> {
  /// Safely converts between numeric types with error handling.
  num? safeCast<R extends num>() {
    try {
      if (value is int && R == double) {
        return (value as int).toDouble();
      } else if (value is double && R == int) {
        return (value as double).round();
      }
      return value;
    } catch (e) {
      Get.log('Type conversion error: $e', isError: true);
      return null;
    }
  }

  /// Validates if the current value is within the specified range.
  bool isInRange(T min, T max) => value >= min && value <= max;
}

/// Extension providing null-safe operations for reactive numeric types.
extension RxnNumExtension<T extends num> on Rx<T?> {
  /// Safe arithmetic operations that handle null values gracefully.
  T? safeAdd(T other) => value != null ? (value! + other) as T : null;
  T? safeSubtract(T other) => value != null ? (value! - other) as T : null;
  T? safeMultiply(T other) => value != null ? (value! * other) as T : null;

  /// Performs safe division with null and zero checks.
  double? safeDivide(T other) {
    if (value == null || other == 0) return null;
    return value! / other;
  }

  /// Validation methods for checking numeric properties
  bool? isPositive() => value?.isFinite;
  bool? isNegative() => value?.isNegative;
}

extension RxNumExt<T extends num> on Rx<T> {
  /// Multiplication operator.
  num operator *(num other) => value * other;

  /// Euclidean modulo operator.
  num operator %(num other) => value % other;

  /// Division operator.
  double operator /(num other) => value / other;

  /// Truncating division operator.
  int operator ~/(num other) => value ~/ other;

  /// Negate operator.
  num operator -() => -value;

  /// Returns the remainder of the truncating division of `this` by [other].
  num remainder(num other) => value.remainder(other);

  /// Relational less than operator.
  bool operator <(num other) => value < other;

  /// Relational less than or equal operator.
  bool operator <=(num other) => value <= other;

  /// Relational greater than operator.
  bool operator >(num other) => value > other;

  /// Relational greater than or equal operator.
  bool operator >=(num other) => value >= other;

  /// True if the number is the double Not-a-Number value; otherwise, false.
  bool get isNaN => value.isNaN;

  /// True if the number is negative; otherwise, false.
  bool get isNegative => value.isNegative;

  /// True if the number is positive infinity or negative infinity; otherwise, false.
  bool get isInfinite => value.isInfinite;

  /// True if the number is finite; otherwise, false.
  bool get isFinite => value.isFinite;

  /// Returns the absolute value of this [num].
  num abs() => value.abs();

  /// Returns minus one, zero or plus one depending on the sign and numerical value of the number.
  num get sign => value.sign;

  /// Returns the integer closest to `this`.
  int round() => value.round();

  /// Returns the greatest integer no greater than `this`.
  int floor() => value.floor();

  /// Returns the least integer no smaller than `this`.
  int ceil() => value.ceil();

  /// Returns the integer obtained by discarding any fractional digits from `this`.
  int truncate() => value.truncate();

  /// Returns the double integer value closest to `this`.
  double roundToDouble() => value.roundToDouble();

  /// Returns the greatest double integer value no greater than `this`.
  double floorToDouble() => value.floorToDouble();

  /// Returns the least double integer value no smaller than `this`.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns the double integer value obtained by discarding any fractional digits from `this`.
  double truncateToDouble() => value.truncateToDouble();

  /// Returns this [num] clamped to be in the range [lowerLimit]-[upperLimit].
  num clamp(num lowerLimit, num upperLimit) => value.clamp(lowerLimit, upperLimit);

  /// Truncates this [num] to an integer and returns the result as an [int].
  int toInt() => value.toInt();

  /// Return this [num] as a [double].
  double toDouble() => value.toDouble();

  /// Returns a decimal-point string-representation of `this`.
  String toStringAsFixed(int fractionDigits) => value.toStringAsFixed(fractionDigits);

  /// Returns an exponential string-representation of `this`.
  String toStringAsExponential([int? fractionDigits]) => value.toStringAsExponential(fractionDigits);

  /// Converts `this` to a double and returns a string representation with exactly [precision] significant digits.
  String toStringAsPrecision(int precision) => value.toStringAsPrecision(precision);
}

extension RxnNumExt<T extends num> on Rx<T?> {
  /// Multiplication operator.
  num? operator *(num other) => value != null ? value! * other : null;

  /// Euclidean modulo operator.
  num? operator %(num other) => value != null ? value! % other : null;

  /// Division operator.
  double? operator /(num other) => value != null ? value! / other : null;

  /// Truncating division operator.
  int? operator ~/(num other) => value != null ? value! ~/ other : null;

  /// Negate operator.
  num? operator -() => value != null ? -value! : null;

  /// Returns the remainder of the truncating division of `this` by [other].
  num? remainder(num other) => value?.remainder(other);

  /// Relational less than operator.
  bool? operator <(num other) => value != null ? value! < other : null;

  /// Relational less than or equal operator.
  bool? operator <=(num other) => value != null ? value! <= other : null;

  /// Relational greater than operator.
  bool? operator >(num other) => value != null ? value! > other : null;

  /// Relational greater than or equal operator.
  bool? operator >=(num other) => value != null ? value! >= other : null;

  /// True if the number is the double Not-a-Number value; otherwise, false.
  bool? get isNaN => value?.isNaN;

  /// True if the number is negative; otherwise, false.
  bool? get isNegative => value?.isNegative;

  /// True if the number is positive infinity or negative infinity; otherwise, false.
  bool? get isInfinite => value?.isInfinite;

  /// True if the number is finite; otherwise, false.
  bool? get isFinite => value?.isFinite;

  /// Returns the absolute value of this [num].
  num? abs() => value?.abs();

  /// Returns minus one, zero or plus one depending on the sign and numerical value of the number.
  num? get sign => value?.sign;

  /// Returns the integer closest to `this`.
  int? round() => value?.round();

  /// Returns the greatest integer no greater than `this`.
  int? floor() => value?.floor();

  /// Returns the least integer no smaller than `this`.
  int? ceil() => value?.ceil();

  /// Returns the integer obtained by discarding any fractional digits from `this`.
  int? truncate() => value?.truncate();

  /// Returns the double integer value closest to `this`.
  double? roundToDouble() => value?.roundToDouble();

  /// Returns the greatest double integer value no greater than `this`.
  double? floorToDouble() => value?.floorToDouble();

  /// Returns the least double integer value no smaller than `this`.
  double? ceilToDouble() => value?.ceilToDouble();

  /// Returns the double integer value obtained by discarding any fractional digits from `this`.
  double? truncateToDouble() => value?.truncateToDouble();

  /// Returns this [num] clamped to be in the range [lowerLimit]-[upperLimit].
  num? clamp(num lowerLimit, num upperLimit) => value?.clamp(lowerLimit, upperLimit);

  /// Truncates this [num] to an integer and returns the result as an [int].
  int? toInt() => value?.toInt();

  /// Return this [num] as a [double].
  double? toDouble() => value?.toDouble();

  /// Returns a decimal-point string-representation of `this`.
  String? toStringAsFixed(int fractionDigits) => value?.toStringAsFixed(fractionDigits);

  /// Returns an exponential string-representation of `this`.
  String? toStringAsExponential([int? fractionDigits]) => value?.toStringAsExponential(fractionDigits);

  /// Converts `this` to a double and returns a string representation with exactly [precision] significant digits.
  String? toStringAsPrecision(int precision) => value?.toStringAsPrecision(precision);
}
