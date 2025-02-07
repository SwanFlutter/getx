import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../router_report.dart';

/// A custom popup route for displaying dialogs with configurable transitions.
class GetDialogRoute<T> extends PopupRoute<T> {
  /// Creates a [GetDialogRoute].
  ///
  /// The [pageBuilder] is required to define the content of the dialog.
  /// The [barrierDismissible] determines whether tapping outside dismisses the dialog (default: true).
  /// The [barrierColor] defines the background overlay color (default: semi-transparent black).
  /// The [transitionDuration] controls how long the transition animation takes (default: 200ms).
  /// The [transitionBuilder] allows for custom transition animations.
  GetDialogRoute({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    super.settings, // Use super parameter
  })  : _pageBuilder = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder {
    RouterReportManager.reportCurrentRoute(this);
  }

  /// The builder function to create the dialog content.
  final RoutePageBuilder _pageBuilder;

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

  /// Custom transition animation builder.
  final RouteTransitionsBuilder? _transitionBuilder;

  @override
  void dispose() {
    RouterReportManager.reportRouteDispose(this);
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: _pageBuilder(context, animation, secondaryAnimation),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (_transitionBuilder == null) {
      // Default fade transition if no custom transition is provided.
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        ),
        child: child,
      );
    }
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }
}
