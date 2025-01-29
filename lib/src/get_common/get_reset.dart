import 'package:getx/getx.dart';

/// Extension methods for resetting GetX state and configurations
extension GetResetExt on GetInterface {
  /// Resets the GetX instance to its initial state
  ///
  /// This method performs a complete cleanup of GetX state:
  /// - Resets all instances and dependencies
  /// - Clears translation cache
  /// - Optionally clears route bindings
  ///
  /// [clearRouteBindings] - Whether to clear route-related bindings (default: true)
  ///
  /// Example:
  /// ```dart
  /// // Reset everything including route bindings
  /// Get.reset();
  ///
  /// // Reset but keep route bindings
  /// Get.reset(clearRouteBindings: false);
  /// ```
  void reset({
    bool clearRouteBindings = true,
  }) {
    // Reset all registered instances and bindings
    Get.resetInstance(
      clearRouteBindings: clearRouteBindings,
    );

    // Clear all cached translations
    Get.clearTranslations();

    // Get.clearRouteTree();
    // Get.resetRootNavigator();
  }

  /// Resets only the translations without affecting other states
  void resetTranslations() {
    Get.clearTranslations();
  }

  /// Resets only the instances without affecting translations
  void resetInstances({
    bool clearRouteBindings = true,
  }) {
    Get.resetInstance(
      clearRouteBindings: clearRouteBindings,
    );
  }
}
