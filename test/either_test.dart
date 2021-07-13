import 'package:either/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should fold error', () {
    final error = Left(ArgumentError("Teste de Erro"));

    try {
      error.fold(ifLeft: (f) => throw f, ifRight: (r) => print("OK"));
    } on ArgumentError catch (e) {
      expect(e.message ?? '', 'Teste de Erro');
      return;
    }
    throw Exception("Expected ArgumentError");
  });

  test('should fold success', () {
    final success = Right("Valor com sucesso");

    final result = success.fold(ifLeft: (f) => throw f, ifRight: (r) => r);

    expect(result, "Valor com sucesso");
  });

  test('should map success', () {
    final success = Right("Valor com sucesso");

    final result = success.map((r) => r.toUpperCase());
    final mapped =
        result.fold(ifLeft: (f) => throw Exception(), ifRight: (r) => r);

    expect(mapped, "VALOR COM SUCESSO");
  });

  test('should not change value if is error', () {
    final error = Left("Valor com erro");

    final result = error.map((r) => r.toUpperCase());
    final mapped = result.fold(ifLeft: (f) => f, ifRight: (r) => r);

    expect(mapped, "Valor com erro");
  });

  test('should return original value if is right instance', () {
    final sut = Right("Valor");
    final result = sut.orElse(() => "VALOR COM ERRO");
    expect(result, "Valor");
  });

  test('should return new value if is left instance', () {
    final sut = Left("Valor");
    final result = sut.orElse(() => "VALOR COM ERRO");
    expect(result, "VALOR COM ERRO");
  });

  test('should flat a Right istances', () {
    final sut = Right("1");
    final toNumber = sut.flatMap((r) => Right(int.parse(r)));
    toNumber.fold(
      ifLeft: (f) => throw Exception(),
      ifRight: (r) => expect(r, 1),
    );
  });

  test('should not flat a Left istances', () {
    final sut = Left("1");
    final toNumber = sut.flatMap((r) => Right(int.parse(r)));
    toNumber.fold(
      ifLeft: (f) => expect(f, "1"),
      ifRight: (r) => throw Exception(),
    );
  });
}
