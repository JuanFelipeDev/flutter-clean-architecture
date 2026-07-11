/// Riverpod providers for logging & telemetry.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_providers.dart';
import 'logger.dart';
import 'telemetry_service.dart';

final telemetryProvider = Provider<TelemetryService>((ref) {
  final flavor = ref.watch(flavorConfigProvider);
  if (flavor.sentryDsn.isEmpty) {
    return NoopTelemetry();
  }
  return SentryTelemetry(dsn: flavor.sentryDsn, environment: flavor.environment.name);
});

final loggerProvider = Provider<Logger>((ref) {
  return Logger(ref.watch(telemetryProvider));
});