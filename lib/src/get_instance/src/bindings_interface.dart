// ignore: one_member_abstracts

import '../../../getx.dart';

/// Interface for defining dependencies in the application.
/// This interface provides a standard way to define dependencies
/// across different implementations.
abstract class BindingsInterface<T> {
  /// Main method for defining and initializing dependencies.
  /// The type T allows returning different types.
  T dependencies();
}

/// Base class for managing dependency injection in the application.
/// When using GetMaterialApp, all GetPages have a property called `binding`
/// which receives an instance of Binding.
///
/// Example:
/// ```dart
/// class HomeBinding extends Binding {
///   @override
///   void dependencies() {
///     Get.put(HomeController()); // Main controller
///     Get.put(ApiService());     // API service
///   }
/// }
/// ```
abstract class Binding extends BindingsInterface<void> {
  @override
  void dependencies();
}

/// Simplifies the creation of Bindings using a callback.
/// This class helps define bindings without creating a separate class.
class BindingsBuilder<T> extends Binding {
  /// Callback function that contains the logic for registering dependencies.
  final BindingBuilderCallback builder;

  /// Constructor for BindingsBuilder with the required callback.
  BindingsBuilder(this.builder);

  /// Factory constructor for quickly placing an instance in Get.
  ///
  /// Parameters:
  /// - [builder]: Instance builder function.
  /// - [tag]: Optional tag for identifying the instance.
  /// - [permanent]: Whether the instance should be permanent.
  factory BindingsBuilder.put(
    InstanceBuilderCallback<T> builder, {
    String? tag,
    bool permanent = false,
  }) {
    return BindingsBuilder(
      () => Get.put<T>(
        builder(),
        tag: tag,
        permanent: permanent,
      ),
    );
  }

  @override
  void dependencies() => builder();
}

/// Type definition for binding builder callback functions.
typedef BindingBuilderCallback = void Function();

/// Type definition for instance builder callback functions.
typedef InstanceBuilderCallback<T> = T Function();
