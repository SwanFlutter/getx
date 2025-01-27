import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../get_core/get_core.dart';
import '../../../get_instance/src/extension_instance.dart';
import '../../../get_instance/src/lifecycle.dart';
import '../simple/list_notifier.dart';

// Type definition for a function that builds a widget with a GetX controller
typedef GetXControllerBuilder<T extends GetLifeCycleMixin> = Widget Function(T controller);

class GetX<T extends GetLifeCycleMixin> extends StatefulWidget {
  final GetXControllerBuilder<T> builder; // Function to build the widget
  final bool global; // Should the controller be used globally?
  final bool autoRemove; // Should the controller be automatically removed?
  final bool assignId; // Should an ID be assigned?

  // Lifecycle callback functions
  final void Function(GetXState<T> state)? initState, dispose, didChangeDependencies;

  // Function to update the widget
  final void Function(GetX oldWidget, GetXState<T> state)? didUpdateWidget;

  final T? init; // Initial controller
  final String? tag; // Tag for the controller

  const GetX({
    super.key,
    required this.builder,
    this.tag,
    this.global = true,
    this.autoRemove = true,
    this.initState,
    this.assignId = false,
    this.dispose,
    this.didChangeDependencies,
    this.didUpdateWidget,
    this.init,
  });

  @override
  StatefulElement createElement() => StatefulElement(this);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<T>('controller', init))
      ..add(DiagnosticsProperty<String>('tag', tag))
      ..add(ObjectFlagProperty<GetXControllerBuilder<T>>.has('builder', builder));
  }

  @override
  GetXState<T> createState() => GetXState<T>();
}

class GetXState<T extends GetLifeCycleMixin> extends State<GetX<T>> {
  T? controller; // The associated controller
  bool? _isCreator = false; // Indicates if this controller was created here

  @override
  void initState() {
    super.initState();

    // Check if the controller is registered with the given tag
    final isRegistered = Get.isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        _isCreator = Get.isPrepared<T>(tag: widget.tag);
        controller = Get.find<T>(tag: widget.tag);
      } else {
        controller = widget.init;
        _isCreator = true;
        Get.put<T>(controller!, tag: widget.tag); // Register new controller
      }
    } else {
      controller = widget.init;
      _isCreator = true;
      controller?.onStart(); // Start lifecycle for local controller
    }

    // Call user-defined initState function
    widget.initState?.call(this);

    if (widget.global && Get.smartManagement == SmartManagement.onlyBuilder) {
      controller?.onStart(); // Start lifecycle if smart management is enabled
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(this); // Call user-defined dependencies change function
  }

  @override
  void didUpdateWidget(GetX oldWidget) {
    super.didUpdateWidget(oldWidget as GetX<T>);
    widget.didUpdateWidget?.call(oldWidget, this); // Update widget if changed
  }

  @override
  void dispose() {
    if (widget.dispose != null) widget.dispose!(this); // Call user-defined dispose function

    if (_isCreator! || widget.assignId) {
      if (widget.autoRemove && Get.isRegistered<T>(tag: widget.tag)) {
        Get.delete<T>(tag: widget.tag); // Remove the controller if needed
      }
    }

    for (final disposer in disposers) {
      disposer(); // Call disposal functions
    }

    disposers.clear(); // Clear the list of disposal functions

    controller = null;
    _isCreator = null;

    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(() {}); // Update the widget state
    }
  }

  final disposers = <Disposer>[]; // List of disposal functions

  @override
  Widget build(BuildContext context) => Notifier.instance.append(NotifyData(disposers: disposers, updater: _update), () => widget.builder(controller!)); // Build the widget with the controller

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('controller', controller));
  }
}
