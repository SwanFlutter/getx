import 'package:flutter/material.dart';

import 'animations.dart';
import 'get_animated_builder.dart';

const _defaultDuration = Duration(seconds: 2);
const _defaultDelay = Duration.zero;

/// Extension methods for adding animations to any Widget
extension AnimationExtension on Widget {
  /// Returns the current animation if this widget is already animated
  GetAnimatedBuilder? get _currentAnimation => (this is GetAnimatedBuilder) ? this as GetAnimatedBuilder : null;

  /// Adds fade-in animation to the widget
  /// [duration] - Animation duration (default: 2 seconds)
  /// [delay] - Delay before animation starts
  /// [isSequential] - Whether to run after previous animation
  GetAnimatedBuilder fadeIn({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    assert(isSequential || this is! FadeOutAnimation, 'Can not use fadeOut + fadeIn when isSequential is false');

    return FadeInAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder fadeOut({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    assert(isSequential || this is! FadeInAnimation, 'Can not use fadeOut() + fadeIn when isSequential is false');

    return FadeOutAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder rotate({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return RotateAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder scale({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return ScaleAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder slide({
    required OffsetBuilder offset,
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SlideAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      offsetBuild: offset,
      child: this,
    );
  }

  GetAnimatedBuilder bounce({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return BounceAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder spin({
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SpinAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder size({
    required double begin,
    required double end,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return SizeAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder blur({
    double begin = 0,
    double end = 15,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return BlurAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder flip({
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return FlipAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  GetAnimatedBuilder wave({
    double begin = 0,
    double end = 1,
    Duration duration = _defaultDuration,
    Duration delay = _defaultDelay,
    ValueSetter<AnimationController>? onComplete,
    bool isSequential = false,
  }) {
    return WaveAnimation(
      duration: duration,
      delay: _getDelay(isSequential, delay),
      begin: begin,
      end: end,
      onComplete: onComplete,
      child: this,
    );
  }

  /// Calculates appropriate delay based on sequential animation flag
  Duration _getDelay(bool isSequential, Duration delay) {
    assert(!(isSequential && delay != Duration.zero), "Error: When isSequential is true, delay must be non-zero");

    return isSequential ? (_currentAnimation?.totalDuration ?? Duration.zero) : delay;
  }
}
