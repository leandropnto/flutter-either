library either;

abstract class Either<Failure, Result> {
  T fold<T>({
    required T ifLeft(Failure f),
    required T ifRight(Result r),
  });

  Either<Failure, T> map<T>(T f(Result r));
  Result orElse(Result f());
}

class Left<Failure, Result> extends Either<Failure, Result> {
  final Failure _value;

  Left(this._value);

  @override
  T fold<T>({
    required T Function(Failure f) ifLeft,
    required T Function(Result r) ifRight,
  }) {
    return ifLeft(_value);
  }

  @override
  Either<Failure, T> map<T>(T Function(Result r) f) => Left(_value);

  @override
  Result orElse(Result Function() f) => f();
}

class Right<Failure, Result> extends Either<Failure, Result> {
  final Result _value;

  Right(this._value);

  @override
  T fold<T>({
    required T Function(Failure f) ifLeft,
    required T Function(Result r) ifRight,
  }) {
    return ifRight(_value);
  }

  @override
  Either<Failure, T> map<T>(T Function(Result r) f) => Right(f(_value));

  @override
  Result orElse(Result Function() f) => _value;
}
