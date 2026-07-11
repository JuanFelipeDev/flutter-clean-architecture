/// Riverpod providers for analytics.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_service.dart';

/// Phase 3 no-op; Phase 4 overrides with `FirebaseAnalyticsService`.
final analyticsProvider = Provider<AnalyticsService>((ref) {
  return NoopAnalytics();
});