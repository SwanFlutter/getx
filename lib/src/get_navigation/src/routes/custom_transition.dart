import 'package:flutter/widgets.dart';

// This abstract class defines the structure for custom transition implementations.
abstract class CustomTransition {
  // Method signature for building a custom transition.
  Widget buildTransition(
    BuildContext context, // The current BuildContext for accessing environmental information.
    Curve curve, // The curve used for the animation.
    Alignment alignment, // The alignment of the widget during the transition.
    Animation<double> animation, // The primary animation for the transition.
    Animation<double> secondaryAnimation, // The secondary animation for additional effects.
    Widget child, // The child widget that will be displayed in the transition.
  );
}
