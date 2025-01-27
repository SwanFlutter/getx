import 'package:flutter/material.dart';

import '../rx_flutter/rx_obx_widget.dart';
import 'get_controllers.dart';
import 'get_state.dart';

/// A builder widget that combines the features of GetBuilder and Obx.
///
/// This widget allows you to use both reactive programming and manual state updates
/// in a single widget, providing flexibility for managing state in your Flutter application.
class MixinBuilder<T extends GetxController> extends StatelessWidget {
  /// A function that builds the widget based on the provided controller.
  @required
  final Widget Function(T) builder;

  /// Whether to use a global instance of the controller.
  final bool global;

  /// An optional identifier for the controller instance.
  final String? id;

  /// Whether to automatically remove the controller when not needed.
  final bool autoRemove;

  /// Callback for initializing the state of the widget.
  final void Function(BindElement<T> state)? initState;

  /// Callback for disposing of the state when the widget is removed from the tree.
  final void Function(BindElement<T> state)? dispose;

  /// Callback for when dependencies change.
  final void Function(BindElement<T> state)? didChangeDependencies;

  /// Callback for when the widget is updated.
  final void Function(Binder<T> oldWidget, BindElement<T> state)? didUpdateWidget;

  /// An optional initial instance of the controller.
  final T? init;

  const MixinBuilder({
    super.key,
    this.init,
    this.global = true,
    required this.builder,
    this.autoRemove = true,
    this.initState,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: init,
      global: global,
      autoRemove: autoRemove,
      initState: initState,
      dispose: dispose,
      id: id,
      didChangeDependencies: didChangeDependencies,
      didUpdateWidget: didUpdateWidget,
      builder: (controller) => Obx(() => builder.call(controller)), // Use Obx for reactive updates
    );
  }
}
