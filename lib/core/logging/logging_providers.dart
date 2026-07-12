/// Riverpod providers for logging & telemetry.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logger.dart';
import 'telemetry_service.dart';

/// No-op until a Sentry/Firebase project is provisioned (see
/// [telemetry_service.dart]).
final telemetryProvider = Provider<TelemetryService>((ref) {
  return NoopTelemetry();
});

final loggerProvider = Provider<Logger>((ref) {
  return Logger(ref.watch(telemetryProvider));
});