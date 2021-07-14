abstract class Option<Result> {
  Option<T> map<T>(T f(Result r));
}

class Unit {
  Unit._();

  static Unit instance = Unit._();
}

class None<Unit> extends Option<Unit> {
  None._();

  @override
  Option<T> map<T>(T Function(Unit r) f) => None._();
}

class Some<Result> extends Option<Result> {
  final Result _value;

  Some(this._value);

  @override
  Option<T> map<T>(T Function(Result r) f) => Some(f(_value));
}
