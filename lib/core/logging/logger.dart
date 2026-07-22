/// Thin debug logger. Avoids `print` in production builds and delegates
/// debug-only intent without pulling a logging framework.
library;

import 'package:flutter/foundation.dart';

import 'telemetry_service.dart';

class Logger {
  Logger(this._telemetry);

  final TelemetryService _telemetry;

  void debug(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[DEBUG] $message');
    }
  }

  void info(String message, {String? category}) {
    _telemetry.addBreadcrumb(
      message: message,
      category: category ?? 'app.info',
    );
  }

  void warning(String message, {String? category}) {
    _telemetry.addBreadcrumb(
      message: message,
      category: category ?? 'app.warning',
      level: BreadcrumbLevel.warning,
    );
  }

  void error(Object error, StackTrace? stackTrace, {String? hint}) {
    debug(error.toString());
    _telemetry.recordError(error, stackTrace, hint: hint);
  }
}
