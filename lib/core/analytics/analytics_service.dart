/// this is a Flutter-improvement seam. Phase 4 wires `firebase_analytics`
/// behind [FirebaseAnalyticsService]; until then [NoopAnalytics] is used.
library;

abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});
  Future<void> setUserId(String? id);
  Future<void> setUserProperty(String name, String? value);
  Future<void> logScreenView(String name);
}

class NoopAnalytics implements AnalyticsService {
  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?>? parameters,
  }) async {}
  @override
  Future<void> setUserId(String? id) async {}
  @override
  Future<void> setUserProperty(String name, String? value) async {}
  @override
  Future<void> logScreenView(String name) async {}
}
