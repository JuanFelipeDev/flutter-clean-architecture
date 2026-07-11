/// Structured HTTP logging + breadcrumb reporting. Replaces PRESTADOR's
/// `SentryBreadcrumbInterceptor` + `HttpLoggingInterceptor`. In debug it logs
/// request/response lines; in all builds it records breadcrumbs to telemetry.
library;

import 'package:dio/dio.dart';

import '../../logging/telemetry_service.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required this.telemetry, this.verbose = false});

  final TelemetryService telemetry;
  final bool verbose;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (verbose) {
      // ignore: avoid_print
      print('→ ${options.method} ${options.uri}');
    }
    telemetry.addBreadcrumb(
      category: 'http.request',
      message: '${options.method} ${options.uri}',
      data: {'method': options.method, 'url': options.uri.toString()},
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (verbose) {
      // ignore: avoid_print
      print('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    telemetry.addBreadcrumb(
      category: 'http.response',
      message: '${response.statusCode} ${response.requestOptions.uri}',
      data: {'status': response.statusCode ?? 0},
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    telemetry.addBreadcrumb(
      category: 'http.error',
      message: '${err.requestOptions.uri} → ${err.type}',
      level: BreadcrumbLevel.error,
    );
    handler.next(err);
  }
}