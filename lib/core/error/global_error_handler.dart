/// Global error handler wiring. Captures Flutter framework errors and
/// platform-dispatcher errors, forwarding them to telemetry
/// `Thread.setDefaultUncaughtExceptionHandler` + Flutter `FlutterError.onError`.
library;

import 'package:flutter/foundation.dart';

import '../logging/telemetry_service.dart';

/// Installs framework + platform error handlers that report to [telemetry].
///
/// Call once from [bootstrap], before running the app. Errors are reported and
/// then forwarded to the default presenter so they still surface in debug.
void installGlobalErrorHandlers(TelemetryService telemetry) {
  FlutterError.onError = (FlutterErrorDetails details) {
    telemetry.recordError(
      details.exception,
      details.stack,
      hint: details.context?.toString(),
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    telemetry.recordError(error, stack);
    return true;
  };
}
