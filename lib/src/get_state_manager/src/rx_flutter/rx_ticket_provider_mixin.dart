// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../get_instance/src/lifecycle.dart';
import '../../get_state_manager.dart';

/// A mixin that simplifies the creation of AnimationControllers inside GetxController
/// by providing a single TickerProvider.
///
/// Example:
/// ```
/// class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
///   AnimationController controller;
///
///   @override
///   void onInit() {
///     final duration = const Duration(seconds: 2);
///     controller = AnimationController.unbounded(duration: duration, vsync: this);
///     controller.repeat();
///     controller.addListener(() => print("Animation Controller value: ${controller.value}"));
///   }
///   ...
/// ```
mixin GetSingleTickerProviderStateMixin on GetxController implements TickerProvider {
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$runtimeType is a GetSingleTickerProviderStateMixin but multiple tickers were created.'),
        ErrorDescription('A GetSingleTickerProviderStateMixin can only be used as a TickerProvider once.'),
        ErrorHint(
          'If a State is used for multiple AnimationController objects, or if it is passed to other '
          'objects and those objects might use it more than one time in total, then instead of '
          'mixing in a GetSingleTickerProviderStateMixin, use a regular GetTickerProviderStateMixin.',
        ),
      ]);
    }());
    _ticker = Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);
    return _ticker!;
  }

  void didChangeDependencies(BuildContext context) {
    if (_ticker != null) _ticker!.muted = !TickerMode.of(context);
  }

  @override
  void dispose() {
    assert(() {
      if (_ticker == null || !_ticker!.isActive) return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$this was disposed with an active Ticker.'),
        ErrorDescription(
          '$runtimeType created a Ticker via its GetSingleTickerProviderStateMixin, but at the time '
          'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
          'be disposed before calling super.dispose().',
        ),
        ErrorHint(
          'Tickers used by AnimationControllers '
          'should be disposed by calling dispose() on the AnimationController itself. '
          'Otherwise, the ticker will leak.',
        ),
        _ticker!.describeForError('The offending ticker was'),
      ]);
    }());
    super.dispose();
  }
}

/// A mixin that simplifies the creation of multiple AnimationControllers inside GetxController
/// by providing a TickerProvider for multiple tickers.
///
/// Example:
/// ```
/// class SplashController extends GetxController with GetTickerProviderStateMixin {
///   AnimationController firstController;
///   AnimationController secondController;
///
///   @override
///   void onInit() {
///     final duration = const Duration(seconds: 2);
///     firstController = AnimationController.unbounded(duration: duration, vsync: this);
///     secondController = AnimationController.unbounded(duration: duration, vsync: this);
///     firstController.repeat();
///     firstController.addListener(() => print("Animation Controller value: ${firstController.value}"));
///     secondController.addListener(() => print("Animation Controller value: ${secondController.value}"));
///   }
///   ...
/// ```
mixin GetTickerProviderStateMixin on GetxController implements TickerProvider {
  Set<Ticker>? _tickers;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _tickers ??= <_WidgetTicker>{};
    final result = _WidgetTicker(onTick, this, debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null);
    _tickers!.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
  }

  void didChangeDependencies(BuildContext context) {
    final muted = !TickerMode.of(context);
    if (_tickers != null) {
      for (final ticker in _tickers!) {
        ticker.muted = muted; // Mute tickers based on context
      }
    }
  }

  @override
  @override
  void dispose() {
    assert(() {
      if (_tickers != null) {
        for (final ticker in _tickers!) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                '$runtimeType created a Ticker via its GetTickerProviderStateMixin, but at the time '
                'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
                'be disposed before calling super.dispose().',
              ),
              ErrorHint(
                'Tickers used by AnimationControllers '
                'should be disposed by calling dispose() on the AnimationController itself. '
                'Otherwise, the ticker will leak.',
              ),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    super.dispose();
  }
}

// A private class that extends Ticker to manage its lifecycle.
class _WidgetTicker extends Ticker {
  _WidgetTicker(super.onTick, this._creator, {super.debugLabel});

  final GetTickerProviderStateMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this); // Remove this ticker from the creator's set
    super.dispose(); // Call superclass dispose method
  }
}

@Deprecated('use GetSingleTickerProviderStateMixin')

/// A deprecated mixin that simplifies AnimationController creation inside GetxController.
/// Use [GetSingleTickerProviderStateMixin] instead.
///
/// Example:
/// ```
/// class SplashController extends GetxController with SingleGetTickerProviderMixin {
///   AnimationController _ac;
///
///   @override
///   void onInit() {
///     final dur = const Duration(seconds: 2);
///     _ac = AnimationController.unbounded(duration: dur, vsync: this);
///     _ac.repeat();
///     _ac.addListener(() => print("Animation Controller value: ${_ac.value}"));
///   }
///   ...
/// ```
mixin SingleGetTickerProviderMixin on GetLifeCycleMixin implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick); // Create a single ticker without tracking multiple instances.
}
