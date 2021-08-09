library maybe;

import 'dart:async';

class Maybe<T> {
  final FutureOr<T> Function() _value;

  Maybe._(this._value);

  FutureOr<R> fold<R>({
    required R Function() onComplete,
    required R Function(Error) onError,
    required R Function(T) onSuccess,
  }) async {
    try {
      final result = await _value();
      if (result is List) {
        if (result.isEmpty) {
          return onComplete();
        } else {
          return onSuccess(result);
        }
      } else {
        return onSuccess(result);
      }
    } on Error catch (e) {
      return onError(e);
    }
  }

  FutureOr<Maybe<R>> map<R>(R Function(T) builder) async => fold(
        onComplete: () => this as Maybe<R>,
        onError: (error) => this as Maybe<R>,
        onSuccess: (value) => Maybe._(() => builder(value)),
      );

  FutureOr<Maybe<R>> flatMap<R>(Maybe<R> Function(T) builder) async => fold(
        onComplete: () => this as Maybe<R>,
        onError: (error) => this as Maybe<R>,
        onSuccess: (value) => builder(value),
      );

  static FutureOr<Maybe<R>> just<R>(FutureOr<R> Function() value) async =>
      Maybe<R>._(value);
}
