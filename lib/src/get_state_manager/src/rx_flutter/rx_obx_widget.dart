import 'package:flutter/widgets.dart';

import '../../../get_rx/src/rx_types/rx_types.dart';
import '../simple/simple_builder.dart';

// Type definition for a callback that returns a Widget
typedef WidgetCallback = Widget Function();

/// The [ObxWidget] serves as the base class for all GetX reactive widgets.
///
/// This class is an abstract representation that extends [ObxStatelessWidget].
/// It provides a foundation for building reactive widgets that respond to changes
/// in Rx variables.
abstract class ObxWidget extends ObxStatelessWidget {
  const ObxWidget({super.key});
}

/// The simplest reactive widget in GetX.
///
/// Use this widget to automatically rebuild whenever the Rx variable it observes changes.
///
/// Example:
/// ```
/// final _name = "GetX".obs;
/// Obx(() => Text(_name.value));
/// ```
class Obx extends ObxWidget {
  final WidgetCallback builder; // Callback to build the widget

  const Obx(this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return builder(); // Call the builder to get the widget
  }
}

/// A reactive widget similar to [Obx], but it manages a local state.
///
/// Use this widget when you want to pass initial data through the constructor.
/// It's particularly useful for managing simple local states like toggles,
/// visibility, themes, button states, etc.
///
/// Example:
/// ```
/// ObxValue((data) => Switch(
///   value: data.value,
///   onChanged: (flag) => data.value = flag,
/// ),
/// false.obs);
/// ```
class ObxValue<T extends RxInterface> extends ObxWidget {
  final Widget Function(T) builder; // Callback that takes Rx data and returns a widget
  final T data; // The Rx variable being observed

  const ObxValue(this.builder, this.data, {super.key});

  @override
  Widget build(BuildContext context) => builder(data); // Build using the provided builder function
}
