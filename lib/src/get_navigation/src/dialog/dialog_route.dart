import 'package:flutter/widgets.dart';

import '../router_report.dart';

/// A custom dialog route that provides enhanced functionality for GetX dialogs
/// Supports custom transitions, barrier customization, and accessibility features
class GetDialogRoute<T> extends PopupRoute<T> {
  GetDialogRoute({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    Duration reverseTransitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    bool useSafeArea = true,
    bool maintainState = true,
    bool fullscreenDialog = false,
    Curve curve = Curves.linear,
    Alignment? alignment,
    super.settings,
  })  : widget = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _reverseTransitionDuration = reverseTransitionDuration,
        _transitionBuilder = transitionBuilder,
        _useSafeArea = useSafeArea,
        _maintainState = maintainState,
        _fullscreenDialog = fullscreenDialog,
        _curve = curve,
        _alignment = alignment {
    // Register route for tracking and management
    RouterReportManager.instance.reportCurrentRoute(this);
  }

  /// The widget builder for the dialog content
  final RoutePageBuilder widget;

  /// Animation curve for the dialog transition
  final Curve _curve;

  /// Alignment of the dialog within the screen
  final Alignment? _alignment;

  /// Whether the dialog should be wrapped in SafeArea
  final bool _useSafeArea;

  /// Whether the dialog should maintain its state when inactive
  final bool _maintainState;

  /// Whether the dialog is a fullscreen dialog
  final bool _fullscreenDialog;

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;
  final String? _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;
  final Color _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  @override
  Duration get reverseTransitionDuration => _reverseTransitionDuration;
  final Duration _reverseTransitionDuration;

  /// Custom transition builder for the dialog
  final RouteTransitionsBuilder? _transitionBuilder;

  @override
  bool get maintainState => _maintainState;

  bool get fullscreenDialog => _fullscreenDialog;

  @override
  void dispose() {
    // Clean up and report route disposal
    RouterReportManager.instance.reportRouteDispose(this);
    super.dispose();
  }

  /// Builds the dialog page with proper semantics
  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget child = widget(context, animation, secondaryAnimation);

    if (_useSafeArea) {
      child = SafeArea(child: child);
    }

    if (_alignment != null) {
      child = Align(alignment: _alignment, child: child);
    }

    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
  }

  /// Builds the transitions for the dialog
  /// Uses custom transition builder if provided, otherwise uses default fade transition
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder != null) {
      return _transitionBuilder(context, animation, secondaryAnimation, child);
    }

    // Default fade transition with custom curve
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: _curve,
      ),
      child: child,
    );
  }
}
