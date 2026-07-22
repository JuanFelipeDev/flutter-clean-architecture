/// Telemetry abstraction. The default [NoopTelemetry] keeps the app running
/// without native setup. A Sentry-backed implementation is intentionally
/// deferred: `sentry_flutter` 8.x is incompatible with the Kotlin 2.3 / AGP 9
/// toolchain shipped with Flutter 3.44 (it declares Kotlin language version
/// 1.6 and compileSdk 34). When a compatible version is released, re-add the
/// dependency and a `SentryTelemetry` impl behind this interface + the DSN
/// guard in [telemetryProvider].
library;

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

/// No-op telemetry used until a Sentry/Firebase project is provisioned.
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
