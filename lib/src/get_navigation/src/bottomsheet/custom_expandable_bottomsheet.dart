import 'package:flutter/material.dart';

import '../router_report.dart';

/// A highly customizable expandable bottom sheet route
/// Can be used with GetX pattern: Getx.CustomExpandableBottomSheet()
///
/// Features:
/// - Full screen expansion capability
/// - Custom animation control
/// - Draggable and resizable
/// - Customizable appearance and behavior
/// - Scaffold messenger and global key support
class CustomExpandableBottomSheetRoute<T> extends PopupRoute<T> {
  CustomExpandableBottomSheetRoute({
    required this.builder,
    this.theme,
    this.barrierLabel,
    this.backgroundColor,
    this.isPersistent,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.isScrollControlled = true,
    this.scaffoldKey,
    this.messengerKey,
    super.settings,
    this.enterBottomSheetDuration = const Duration(milliseconds: 250),
    this.exitBottomSheetDuration = const Duration(milliseconds: 200),
    this.curve,
    this.initialChildSize = 1.0,
    this.minChildSize = 0.5,
    this.maxChildSize = 1.0,
    this.borderRadius = 15.0,
  }) {
    // Register route with the router report manager
    RouterReportManager.instance.reportCurrentRoute(this);
  }

  // Core building blocks
  final WidgetBuilder builder;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final GlobalKey<ScaffoldMessengerState>? messengerKey;

  // Sheet size configuration
  /// Initial size of the bottom sheet (0.0 to 1.0)
  final double initialChildSize;

  /// Minimum allowed size when dragging
  final double minChildSize;

  /// Maximum allowed size when dragging
  final double maxChildSize;

  /// Top corner radius of the sheet
  final double borderRadius;

  // Visual customization
  final ThemeData? theme;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Color? modalBarrierColor;

  // Behavior controls
  final bool? isPersistent;
  final bool isScrollControlled;
  final bool isDismissible;
  final bool enableDrag;

  // Animation settings
  final Duration enterBottomSheetDuration;
  final Duration exitBottomSheetDuration;
  final Curve? curve;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  /// Creates the animation controller with custom duration and curve
  @override
  Animation<double> createAnimation() {
    if (curve != null) {
      return CurvedAnimation(curve: curve!, parent: _animationController!.view);
    }
    return _animationController!.view;
  }

  /// Initializes the animation controller with custom timing
  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator!.overlay!);
    _animationController!.duration = enterBottomSheetDuration;
    _animationController!.reverseDuration = exitBottomSheetDuration;
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final sheetTheme = theme?.bottomSheetTheme ?? Theme.of(context).bottomSheetTheme;

    Widget bottomSheet = ScaffoldMessenger(
      key: messengerKey,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _CustomExpandableBottomSheetContent<T>(
            route: this,
            backgroundColor: backgroundColor ?? sheetTheme.modalBackgroundColor ?? sheetTheme.backgroundColor,
            elevation: elevation ?? sheetTheme.modalElevation ?? sheetTheme.elevation,
            shape: shape,
            clipBehavior: clipBehavior,
            enableDrag: enableDrag,
            isScrollControlled: isScrollControlled,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );

    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }

    return bottomSheet;
  }

  @override
  void dispose() {
    RouterReportManager.instance.reportRouteDispose(this);
    super.dispose();
  }
}

class _CustomExpandableBottomSheetContent<T> extends StatefulWidget {
  const _CustomExpandableBottomSheetContent({
    super.key,
    required this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.enableDrag = true,
    this.isScrollControlled = true,
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
    required this.borderRadius,
  });

  final CustomExpandableBottomSheetRoute<T> route;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDrag;
  final bool isScrollControlled;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final double borderRadius;

  @override
  _CustomExpandableBottomSheetContentState<T> createState() => _CustomExpandableBottomSheetContentState<T>();
}

class _CustomExpandableBottomSheetContentState<T> extends State<_CustomExpandableBottomSheetContent<T>> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.route.animation!,
      builder: (context, child) {
        final animationValue = widget.route.animation!.value;
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(widget.borderRadius * (1 - animationValue)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
              boxShadow: [
                if (widget.elevation != null)
                  BoxShadow(
                    blurRadius: widget.elevation!,
                    color: Colors.black26,
                  ),
              ],
            ),
            child: DraggableScrollableSheet(
              initialChildSize: widget.initialChildSize,
              minChildSize: widget.minChildSize,
              maxChildSize: widget.maxChildSize,
              expand: true,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: widget.route.builder(context),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
