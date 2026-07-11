/// Typed result channel for all async operations.
///
/// Replaces PRESTADOR's `arrow.core.Either<ErrorResponse, SuccessResponse<T>>`
/// with an idiomatic Dart sealed type. This is the single error channel used
/// across the app (AFILIADO's mixed `GenericResponse`/exception/toast handling
/// is unified here).
library;

import 'failures.dart';

/// A discriminated result: either [Success] with a value, or [Err] with a
/// typed [Failure]. Use [Result.guard] to wrap code that throws, and
/// [Result.fold]/[Result.getOrNull]/[Result.failureOrNull] to consume.
sealed class Result<T> {
  const Result();

  /// Wraps a synchronous block that may throw.
  factory Result.guard(T Function() run) {
    try {
      return Success(run());
    } on Failure catch (failure) {
      return Err<T>(failure);
    } catch (error, stackTrace) {
      return Err<T>(Failure.unknown(error, stackTrace));
    }
  }

  /// Wraps an async block that may throw.
  static Future<Result<T>> guardAsync<T>(Future<T> Function() run) async {
    try {
      return Success(await run());
    } on Failure catch (failure) {
      return Err<T>(failure);
    } catch (error, stackTrace) {
      return Err<T>(Failure.unknown(error, stackTrace));
    }
  }

  /// `Success(value)` or `Err(failure)`.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    final self = this;
    if (self is Success<T>) return onSuccess(self.value);
    return onFailure((self as Err<T>).failure);
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T? getOrNull() {
    final self = this;
    return self is Success<T> ? self.value : null;
  }

  Failure? failureOrNull() {
    final self = this;
    return self is Err<T> ? self.failure : null;
  }

  /// Transforms the success value, leaving failures untouched.
  Result<R> map<R>(R Function(T value) transform) {
    final self = this;
    if (self is Success<T>) return Result.guard(() => transform(self.value));
    return Err<R>((self as Err<T>).failure);
  }
}

/// Successful result carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;

  @override
  String toString() => 'Success($value)';
}

/// Failed result carrying a typed [Failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;

  @override
  String toString() => 'Err($failure)';
}