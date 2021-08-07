import 'package:either/maybe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should create Maybe<int>', () {
    final sut = Maybe.just<int>(() => 10);
    sut.fold(
      onComplete: () => throw ArgumentError("OnComplete Error"),
      onError: (e) => throw ArgumentError("Error $e"),
      onSuccess: (value) => expect(value, 10),
    );
  });

  test('Should create Maybe with a list', () {
    final sut = Maybe.just(() => [10, 11, 12]);
    sut.fold(
      onComplete: () => throw ArgumentError("OnComplete Error"),
      onError: (e) => throw ArgumentError("Error $e"),
      onSuccess: (value) => expect(value, [10, 11, 12]),
    );
  });

  test('Should run onComplete if list is empty ', () {
    final sut = Maybe.just(() => <int>[]);
    sut.fold(
      onComplete: () => print("onCompleted!"),
      onError: (e) => throw ArgumentError("Error $e"),
      onSuccess: (value) => throw ArgumentError("Should not run onSuccess"),
    );
  });

  test('Should run onError is throws error', () {
    final sut = Maybe.just<int>(() => throw ArgumentError("Error Test"));
    sut.fold(
      onComplete: () => throw ArgumentError("Should Not run onComplete"),
      onError: (e) => print(e),
      onSuccess: (value) => throw ArgumentError("Should not run onSuccess"),
    );
  });
}
