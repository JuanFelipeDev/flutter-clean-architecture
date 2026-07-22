/// Translates transport-layer errors (Dio `DioException`, HTTP status codes)
/// `GenericResponse.handleHtmlError`.
library;

import 'package:dio/dio.dart';

import '../config/app_constants.dart';
import 'failures.dart';

/// Pure mapper from a [DioException] to a [Failure]. No side effects.
Failure mapDioError(DioException error) {
  final message = error.message ?? error.error?.toString() ?? 'Network error';
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return Failure.timeout(cause: error, stackTrace: error.stackTrace);
    case DioExceptionType.connectionError:
      return Failure.network(
        message,
        code: ApiCodes.noInternet,
        cause: error,
        stackTrace: error.stackTrace,
      );
    case DioExceptionType.badCertificate:
      return Failure.server(
        'Certificate validation failed',
        cause: error,
        stackTrace: error.stackTrace,
      );
    case DioExceptionType.cancel:
      return Failure.offline(
        'Request cancelled',
        cause: error,
        stackTrace: error.stackTrace,
      );
    case DioExceptionType.badResponse:
      return _mapResponse(
        error.response,
        cause: error,
        stackTrace: error.stackTrace,
      );
    case DioExceptionType.unknown:
      return Failure.unknown(error, error.stackTrace);
  }
}

/// Maps an HTTP response into a [Failure] based on status code + parsed body.
Failure mapResponseError(Response<dynamic>? response) => _mapResponse(response);

Failure _mapResponse(
  Response<dynamic>? response, {
  Object? cause,
  StackTrace? stackTrace,
}) {
  if (response == null) {
    return Failure.unknown('Empty response', stackTrace);
  }

  final status = response.statusCode ?? 0;
  final data = response.data;
  final parsed = _ErrorBody.parse(data);

  switch (status) {
    case 401:
      return Failure.auth(
        parsed.detail ?? 'Session expired',
        code: status,
        cause: cause,
        stackTrace: stackTrace,
      );
    case 403:
      return Failure.auth(
        parsed.detail ?? 'Not authorized',
        code: status,
        cause: cause,
        stackTrace: stackTrace,
      );
    case >= 400 && < 500:
      return Failure.server(
        parsed.detail ?? parsed.error ?? 'Request error',
        code: status,
        detail: parsed.detail,
        flagPanel: parsed.flagPanel,
        cause: cause,
        stackTrace: stackTrace,
      );
    case >= 500:
      return Failure.server(
        parsed.detail ?? 'Server error',
        code: status,
        detail: parsed.detail,
        flagPanel: parsed.flagPanel,
        cause: cause,
        stackTrace: stackTrace,
      );
    default:
      return Failure.unknown('HTTP $status', stackTrace);
  }
}

class _ErrorBody {
  const _ErrorBody({this.detail, this.error, this.flagPanel});

  final String? detail;
  final String? error;
  final bool? flagPanel;

  static _ErrorBody parse(dynamic data) {
    if (data is Map) {
      return _ErrorBody(
        detail: data['detail']?.toString(),
        error: data['error']?.toString(),
        flagPanel: data['flag_panel'] is bool
            ? data['flag_panel'] as bool
            : null,
      );
    }
    if (data is String && data.isNotEmpty) {
      return _ErrorBody(detail: data);
    }
    return const _ErrorBody();
  }
}
