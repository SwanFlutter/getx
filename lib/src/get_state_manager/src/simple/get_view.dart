// ignore_for_file: unintended_html_in_doc_comment

import 'package:flutter/widgets.dart';
import 'package:getx/getx.dart';

import 'get_widget_cache.dart';

/// GetView is a convenient way to access your Controller
/// without needing to call Get.find<AwesomeController>() yourself.
///
/// Sample usage:
/// ```
/// class AwesomeController extends GetxController {
///   final String title = 'My Awesome View';
/// }
///
/// class AwesomeView extends GetView<AwesomeController> {
///   /// If needed, you can pass the tag for
///   /// Get.find<AwesomeController>(tag: "myTag");
///   @override
///   final String tag = "myTag";
///
///   AwesomeView({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       padding: EdgeInsets.all(20),
///       child: Text(controller.title),
///     );
///   }
/// }
/// ```
abstract class GetView<T> extends StatelessWidget {
  const GetView({super.key});

  final String? tag = null; // Optional tag for controller retrieval

  T get controller => Get.find<T>(tag: tag)!; // Retrieve the controller using the tag

  @override
  Widget build(BuildContext context); // Abstract method to be implemented by subclasses
}

/// GetWidget is a convenient way to access your individual Controller
/// without needing to call Get.find<AwesomeController>() yourself.
/// Get saves your controller in cache, allowing safe use of Get.create().
/// GetWidget is ideal for multiple instances of the same controller. Each
/// GetWidget will have its own controller, and lifecycle events like `onInit`
/// and `onClose` will be called when the controller is created or disposed.
abstract class GetWidget<S extends GetLifeCycleMixin> extends GetWidgetCache {
  const GetWidget({super.key});

  @protected
  final String? tag = null; // Optional tag for controller retrieval

  S get controller => GetWidget._cache[this] as S; // Retrieve cached controller

  static final _cache = Expando<GetLifeCycleMixin>(); // Cache for storing controllers

  @protected
  Widget build(BuildContext context); // Abstract method to be implemented by subclasses

  @override
  WidgetCache createWidgetCache() => _GetCache<S>(); // Create a widget cache instance
}

/// Private class that manages the cache and lifecycle of the controller.
class _GetCache<S extends GetLifeCycleMixin> extends WidgetCache<GetWidget<S>> {
  S? _controller; // The cached controller instance
  bool _isCreator = false; // Flag indicating if this instance created the controller
  InstanceInfo? info; // Information about the instance

  @override
  void onInit() {
    info = Get.getInstanceInfo<S>(tag: widget!.tag); // Retrieve instance info

    _isCreator = info!.isPrepared && info!.isCreate; // Check if this instance created the controller

    if (info!.isRegistered) {
      _controller = Get.find<S>(tag: widget!.tag); // Find existing controller if registered
    }

    GetWidget._cache[widget!] = _controller; // Cache the controller for this widget

    super.onInit(); // Call superclass onInit method
  }

  @override
  void onClose() {
    if (_isCreator) {
      // If this instance created the controller
      Get.asap(() {
        widget!.controller.onDelete(); // Call onDelete method on the controller
        Get.log('"${widget!.controller.runtimeType}" onClose() called');
        Get.log('"${widget!.controller.runtimeType}" deleted from memory');
      });
    }
    info = null; // Clear instance info
    super.onClose(); // Call superclass onClose method
  }

  @override
  Widget build(BuildContext context) {
    return Binder(
      init: () => _controller, // Initialize with cached controller
      child: widget!.build(context), // Build the widget using the provided build method
    );
  }
}
