library maybe;

class Maybe<T> {
  final T Function() _value;

  Maybe._(this._value);

  R fold<R>({
    required R Function() onComplete,
    required R Function(Error) onError,
    required R Function(T) onSuccess,
  }) {
    try {
      final result = _value();
      if (result is List) {
        if (result.isEmpty) {
          return onComplete();
        } else {
          return onSuccess(_value());
        }
      } else {
        return onSuccess(result);
      }
    } on Error catch (e) {
      return onError(e);
    }
  }

  Maybe<R> map<R>(R Function(T) builder) => fold(
        onComplete: () => this as Maybe<R>,
        onError: (error) => this as Maybe<R>,
        onSuccess: (value) => Maybe._(() => builder(value)),
      );

  Maybe<R> flatMap<R>(Maybe<R> Function(T) builder) => fold(
        onComplete: () => this as Maybe<R>,
        onError: (error) => this as Maybe<R>,
        onSuccess: (value) => builder(value),
      );

  static Maybe<R> just<R>(R Function() value) => Maybe<R>._(value);
}
