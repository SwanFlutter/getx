//get_animated_builder.dart
import 'package:flutter/material.dart';

/// A generic animated builder that handles animation setup and disposal.
class GetAnimatedBuilder<T> extends StatefulWidget {
  final Duration duration;
  final Duration delay;
  final Widget child;
  final ValueSetter<AnimationController>? onComplete;
  final ValueSetter<AnimationController>? onStart; // Optional onStart callback
  final Tween<T> tween;
  final T idleValue; // Required idleValue
  final ValueWidgetBuilder<T> builder;
  final Curve curve;

  /// Total duration including initial delay
  Duration get totalDuration => duration + delay;

  const GetAnimatedBuilder({
    super.key,
    this.curve = Curves.linear,
    this.onComplete,
    this.onStart, // Include onStart in the constructor
    required this.duration,
    required this.tween,
    required this.idleValue, // idleValue is now required
    required this.builder,
    required this.child,
    required this.delay,
  });
  @override
  GetAnimatedBuilderState<T> createState() => GetAnimatedBuilderState<T>();
}

/// State class for GetAnimatedBuilder
class GetAnimatedBuilderState<T> extends State<GetAnimatedBuilder<T>> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<T> _animation;
  bool _wasStarted = false;
  late T _idleValue; // Remove the dynamic type
  final bool _willResetOnDispose = false;
  bool get willResetOnDispose => _willResetOnDispose;

  /// Handles animation status changes and callbacks
  void _listener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        widget.onComplete?.call(_controller);
        if (_willResetOnDispose) {
          _controller.reset();
        }
        break;
      // case AnimationStatus.dismissed:
      case AnimationStatus.forward:
        //call on start
        widget.onStart?.call(_controller);
        break;
      // case AnimationStatus.reverse:
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _idleValue = widget.idleValue; // Assign directly
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener(_listener);

    _animation = widget.tween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _wasStarted = true;
          _controller.forward();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant GetAnimatedBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.delay != widget.delay || oldWidget.tween.begin != widget.tween.begin || oldWidget.tween.end != widget.tween.end || oldWidget.curve != widget.curve) {
      // Restart animation if key parameters change, for hot reload.
      _controller.reset();
      _animation = widget.tween.animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      );
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() {
            _wasStarted = true;
            _controller.forward();
          });
        }
      });
    }
    // Note: No need to update _animation directly; it's driven by the controller.
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _wasStarted ? _animation.value : _idleValue;
        return widget.builder(context, value, child);
      },
      child: widget.child,
    );
  }
}
