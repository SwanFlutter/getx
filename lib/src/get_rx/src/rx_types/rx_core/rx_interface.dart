part of '../rx_types.dart';

/// The base interface for all reactive (Rx) classes in Get.
///
/// This interface defines the core functionality that all reactive classes must implement.
/// It extends [ValueListenable] to provide value change notifications and adds reactive
/// specific methods.
///
/// Example usage:
/// ```dart
/// // Creating a reactive variable
/// final count = 0.obs;
///
/// // Listening to changes
/// count.listen((value) => print('Count changed to: $value'));
///
/// // Updating value
/// count.value++;
/// ```
abstract class RxInterface<T> implements ValueListenable<T> {
  /// Closes the reactive variable and releases resources.
  ///
  /// Should be called when the reactive variable is no longer needed to prevent
  /// memory leaks.
  ///
  /// Example:
  /// ```dart
  /// final myRx = 'hello'.obs;
  /// // ... use myRx
  /// myRx.close(); // Clean up when done
  /// ```
  void close();

  /// Listens to value changes and calls [onData] callback when changes occur.
  ///
  /// Parameters:
  /// - [onData]: Called whenever the value changes
  /// - [onError]: Called if an error occurs (optional)
  /// - [onDone]: Called when the stream closes (optional)
  /// - [cancelOnError]: Whether to cancel subscription on error (optional)
  ///
  /// Returns a [StreamSubscription] that can be used to cancel the subscription.
  ///
  /// Example:
  /// ```dart
  /// final name = 'GetX'.obs;
  /// final subscription = name.listen(
  ///   (value) => print('Name changed to: $value'),
  ///   onError: (error) => print('Error: $error'),
  ///   onDone: () => print('Stream closed'),
  /// );
  ///
  /// // Later, cancel the subscription
  /// subscription.cancel();
  /// ```
  StreamSubscription<T> listen(void Function(T event) onData, {Function? onError, void Function()? onDone, bool? cancelOnError});
}

/// Error class for improper usage of GetX reactive widgets.
///
/// This error is thrown when:
/// 1. No observable variables are used within GetX/Obx
/// 2. Observable variables are used outside the proper reactive scope
/// 3. Improper nesting of reactive widgets
///
/// Example of correct usage:
/// ```dart
/// // Correct: Observable within Obx
/// Obx(() => Text('${count.value}'))
///
/// // Correct: Separate Obx for parent and child
/// Obx(() => Container(
///   color: color.value,
///   child: Obx(() => Text('${count.value}')),
/// ))
/// ```
///
/// Example of incorrect usage:
/// ```dart
/// // Wrong: Observable outside reactive scope
/// Text('${count.value}')
///
/// // Wrong: Heavy widget between Obx and observable
/// Obx(() => HeavyWidget(child: Text('${count.value}')))
/// ```
class ObxError {
  const ObxError();
  @override
  String toString() {
    return """
      [Get] Improper use of GetX detected. 
      
      Common issues:
      1. No observable (.obs) variables used within GetX/Obx
      2. Observable used outside proper reactive scope
      3. Heavy widgets between GetX/Obx and observable variables
      
      Best practices:
      - Use GetX/Obx only for widgets that need updates
      - Place observable variables within proper scope
      - Wrap parent and child widgets separately if both need updates
      - Keep reactive widgets as specific as possible
      
      Example of correct usage:
      Obx(() => Text('\${count.value}'))
      
      For more information, visit: https://github.com/jonataslaw/getx#reactive-state-manager
      """;
  }
}
