/// Typed failure hierarchy. One [Failure] per recoverable error category,
/// translated from HTTP/transport errors by [ErrorMapper] and surfaced to the
/// UI as friendly messages. Mirrors PRESTADOR's `ErrorResponse`/`ErrorBody`/
/// `HttpStatusCode` but as a sealed hierarchy.
library;

/// Base of every failure the app can produce.
sealed class Failure {
  const Failure(this.message, {this.code, this.cause, this.stackTrace});

  /// User-presentable message (already localized at the UI boundary).
  final String message;

  /// Backend / synthetic code when available (e.g. 401, [ApiCodes.timeout]).
  final int? code;

  /// Optional underlying error for telemetry.
  final Object? cause;
  final StackTrace? stackTrace;

  /// Discriminator used by UI/mappers without `is`-checks.
  String get kind;

  @override
  String toString() => '$runtimeType($code): $message';

  // -- Factories ----------------------------------------------------------

  static Failure network(
    String message, {
    int? code,
    Object? cause,
    StackTrace? stackTrace,
  }) => NetworkFailure(message, code: code, cause: cause, stackTrace: stackTrace);

  static Failure timeout({
    int code = 9999,
    Object? cause,
    StackTrace? stackTrace,
  }) => TimeoutFailure(
    'The request timed out',
    code: code,
    cause: cause,
    stackTrace: stackTrace,
  );

  static Failure server(
    String message, {
    int? code,
    String? detail,
    bool? flagPanel,
    Object? cause,
    StackTrace? stackTrace,
  }) => ServerFailure(
    message,
    code: code,
    detail: detail,
    flagPanel: flagPanel,
    cause: cause,
    stackTrace: stackTrace,
  );

  static Failure auth(
    String message, {
    int? code,
    Object? cause,
    StackTrace? stackTrace,
  }) => AuthFailure(message, code: code, cause: cause, stackTrace: stackTrace);

  static Failure validation(String message, {String? field}) =>
      ValidationFailure(message, field: field);

  static Failure offline(String message, {Object? cause, StackTrace? stackTrace}) =>
      OfflineFailure(message, cause: cause, stackTrace: stackTrace);

  /// Wraps an arbitrary thrown object; passes through if already a [Failure].
  static Failure unknown(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;
    return UnknownFailure(error.toString(), cause: error, stackTrace: stackTrace);
  }
}

/// No network connectivity (AFILIADO `CONECTED_TO_INTERNET=false` /
/// PRESTADOR `NoInternetException`).
final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.cause, super.stackTrace});
  @override
  String get kind => 'network';
}

/// Request timed out (PRESTADOR `CODE_TIMEOUT = 9999`).
final class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code, super.cause, super.stackTrace});
  @override
  String get kind => 'timeout';
}

/// Server returned an error status (4xx/5xx) with an optional `ErrorBody`.
final class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    super.code,
    this.detail,
    this.flagPanel,
    super.cause,
    super.stackTrace,
  });

  /// `ErrorBody.detail` from the backend (PRESTADOR `ErrorBody`).
  final String? detail;

  /// `flag_panel` — whether the backend wants a modal panel shown.
  final bool? flagPanel;

  @override
  String get kind => 'server';
}

/// Authentication / authorization problem (401/403, session expired).
final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.cause, super.stackTrace});
  @override
  String get kind => 'auth';
}

/// Form / business validation error.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.field, super.code, super.cause})
    : super(stackTrace: null);
  final String? field;
  @override
  String get kind => 'validation';
}

/// Operation was cancelled (e.g. offline grace period elapsed).
final class OfflineFailure extends Failure {
  const OfflineFailure(super.message, {super.code, super.cause, super.stackTrace});
  @override
  String get kind => 'offline';
}

/// Anything not covered above.
final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code, super.cause, super.stackTrace});
  @override
  String get kind => 'unknown';
}