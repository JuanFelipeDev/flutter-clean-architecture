/// Riverpod providers for the session/auth core infra.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_providers.dart';
import '../logging/logging_providers.dart';
import '../network/dio_client.dart';
import '../network/interceptors/logging_interceptor.dart';
import '../storage/storage_providers.dart';
import 'auth_api_service.dart';
import 'session_data.dart';
import 'session_repository.dart';
import 'session_repository_impl.dart';

/// Clean Dio for auth calls — no refresh interceptor (avoids recursion).
final authDioProvider = Provider<Dio>((ref) {
  final flavor = ref.watch(flavorConfigProvider);
  final telemetry = ref.watch(telemetryProvider);
  final env = ref.watch(currentEnvironmentProvider);
  return createDio(flavor, env, [LoggingInterceptor(telemetry: telemetry, verbose: false)]);
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(authDioProvider));
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(
    storage: ref.watch(secureStorageProvider),
    authApi: ref.watch(authApiServiceProvider),
  );
});

/// Cached session for synchronous accessor reads (clientId/username in the
/// auth interceptor). Seeded in [bootstrap] from secure storage.
final cachedSessionProvider = StateProvider<SessionData?>((ref) => null);

/// Google Maps API key used at runtime. Prefers the per-client key resolved
/// from the login response (`user.clients[0].cltInfoApiKey`, AFILIADO's
/// runtime key) and falls back to the compile-time flavor key. Powers Places
/// autocomplete + Geocoding.
final mapsApiKeyProvider = Provider<String>((ref) {
  final session = ref.watch(cachedSessionProvider);
  final flavorKey = ref.watch(flavorConfigProvider).mapsApiKey;
  final sessionKey = session?.mapsApiKey;
  if (sessionKey != null && sessionKey.isNotEmpty) return sessionKey;
  return flavorKey;
});