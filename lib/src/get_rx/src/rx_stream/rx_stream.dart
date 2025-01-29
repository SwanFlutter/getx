library;

import 'dart:async';

import '../rx_typedefs/rx_typedefs.dart';

//part 'get_stream.dart';
part 'mini_stream.dart';

/// Extends MiniStream to provide additional reactive functionalities.
class RxStream<T> extends MiniStream<T> {
  /// Transforms each event of this stream using the given [transformer].
  RxStream<R> map<R>(R Function(T event) transformer) {
    final resultStream = RxStream<R>();
    listen((event) {
      resultStream.add(transformer(event));
    }, onError: (error, stackTrace) {
      resultStream.addError(error, stackTrace);
    }, onDone: () {
      resultStream.close();
    });
    return resultStream;
  }

  /// Filters events of this stream using the given [predicate].
  RxStream<T> where(bool Function(T event) predicate) {
    final resultStream = RxStream<T>();
    listen((event) {
      if (predicate(event)) {
        resultStream.add(event);
      }
    }, onError: (error, stackTrace) {
      resultStream.addError(error, stackTrace);
    }, onDone: () {
      resultStream.close();
    });
    return resultStream;
  }

  /// Combines this stream with another stream using the given [combiner].
  RxStream<R> combineLatest<R, S>(RxStream<S> other, R Function(T, S) combiner) {
    final resultStream = RxStream<R>();
    T? lastValue1;
    S? lastValue2;

    void tryCombine() {
      if (lastValue1 != null && lastValue2 != null) {
        resultStream.add(combiner(lastValue1 as T, lastValue2 as S));
      }
    }

    listen((event) {
      lastValue1 = event;
      tryCombine();
    }, onError: (error, stackTrace) {
      resultStream.addError(error, stackTrace);
    });

    other.listen((event) {
      lastValue2 = event;
      tryCombine();
    }, onError: (error, stackTrace) {
      resultStream.addError(error, stackTrace);
    });

    return resultStream;
  }
}
