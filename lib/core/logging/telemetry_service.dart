/// Telemetry abstraction over Sentry + Crashlytics. Real [SentryTelemetry]
/// initializes Sentry only when a DSN is configured; otherwise
/// [NoopTelemetry] keeps the app running without native setup. Phase 4 adds
/// Crashlytics wiring behind the same interface.
library;

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

enum BreadcrumbLevel { info, warning, error }

/// What the rest of the app sees. Stable surface decoupled from the SDK.
abstract class TelemetryService {
  Future<void> init();
  void recordError(Object error, StackTrace? stackTrace, {String? hint});
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
    BreadcrumbLevel level = BreadcrumbLevel.info,
  });
}

/// Sentry-backed telemetry. Falls back to no-op when the DSN is empty so the
/// app runs before Firebase/Sentry projects are provisioned.
class SentryTelemetry implements TelemetryService {
  SentryTelemetry({required this.dsn, this.environment = 'dev'});

  final String dsn;
  final String environment;
  bool _enabled = false;

  @override
  Future<void> init() async {
    if (dsn.isEmpty) return;
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
        options.environment = environment;
        options.tracesSampleRate = kDebugMode ? 1.0 : 0.1;
      },
    );
    _enabled = true;
  }

  @override
  void recordError(Object error, StackTrace? stackTrace, {String? hint}) {
    if (!_enabled) return;
    Sentry.captureException(error, stackTrace: stackTrace, withScope: (scope) {
      if (hint != null) scope.setTag('hint', hint);
    });
  }

  @override
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
    BreadcrumbLevel level = BreadcrumbLevel.info,
  }) {
    if (!_enabled) return;
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        data: data,
        level: _mapLevel(level),
      ),
    );
  }

  SentryLevel _mapLevel(BreadcrumbLevel level) {
    switch (level) {
      case BreadcrumbLevel.info:
        return SentryLevel.info;
      case BreadcrumbLevel.warning:
        return SentryLevel.warning;
      case BreadcrumbLevel.error:
        return SentryLevel.error;
    }
  }
}

/// No-op telemetry used when no DSN is configured.
class NoopTelemetry implements TelemetryService {
  @override
  Future<void> init() async {}
  @override
  void recordError(Object error, StackTrace? stackTrace, {String? hint}) {}
  @override
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
    BreadcrumbLevel level = BreadcrumbLevel.info,
  }) {}
}