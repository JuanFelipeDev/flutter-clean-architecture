import 'package:affiliate_app/core/error/failures.dart';
import 'package:affiliate_app/core/error/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('guard wraps a value as Success', () {
      final result = Result.guard(() => 42);
      expect(result.isSuccess, isTrue);
      expect(result.getOrNull(), 42);
    });

    test('guard wraps a thrown Failure as Err', () {
      final result = Result<int>.guard(
        () => throw Failure.network('offline', code: 900),
      );
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull(), isA<NetworkFailure>());
      expect(result.failureOrNull()?.code, 900);
    });

    test('guard maps unknown errors to UnknownFailure', () {
      final result = Result<int>.guard(() => throw StateError('boom'));
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull(), isA<UnknownFailure>());
    });

    test('fold routes success and failure', () {
      expect(
        const Success<int>(
          1,
        ).fold(onSuccess: (v) => 'ok:$v', onFailure: (_) => 'err'),
        'ok:1',
      );
      expect(
        Err<int>(
          Failure.timeout(),
        ).fold(onSuccess: (v) => 'ok:$v', onFailure: (_) => 'err'),
        'err',
      );
    });

    test('map transforms success and preserves failure', () {
      final mapped = const Success<int>(2).map((v) => v * 10);
      expect(mapped.getOrNull(), 20);

      final failed = Err<int>(Failure.timeout()).map((v) => v * 10);
      expect(failed.isFailure, isTrue);
    });
  });

  group('Failure', () {
    test('unknown passes through existing failures', () {
      final original = Failure.auth('expired', code: 401);
      final wrapped = Failure.unknown(original);
      expect(wrapped, same(original));
    });

    test('unknown wraps arbitrary errors', () {
      final wrapped = Failure.unknown(const FormatException('bad'));
      expect(wrapped, isA<UnknownFailure>());
    });
  });
}
