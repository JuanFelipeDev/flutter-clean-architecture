/// Riverpod providers for the network layer. Assembles the ordered Dio
/// interceptor chain (PRESTADOR `NetworkModule` parity).
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_providers.dart';
import '../logging/logging_providers.dart';
import '../localization/localization_providers.dart';
import '../storage/secure_storage_service.dart';
import '../storage/storage_providers.dart';
import 'connectivity_service.dart';
import 'dio_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/host_selection_interceptor.dart';
import 'interceptors/language_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/refresh_token_interceptor.dart';
import 'interceptors/upload_progress_interceptor.dart';

final connectivityProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityServiceImpl(Connectivity());
  ref.onDispose(service.dispose);
  return service;
});

// -- Accessor implementations (DI seams wired to storage/config) -----------

class _CredentialAccessor implements CredentialAccessor {
  _CredentialAccessor(this._storage);
  final SecureStorageService _storage;

  @override
  Future<String?> accessToken() => _storage.accessToken();

  @override
  String? clientId() => null; // populated in Phase 4 from the session model.

  @override
  String? username() => null; // populated in Phase 4 from the session model.
}

class _BaseUrlAccessor implements BaseUrlAccessor {
  _BaseUrlAccessor(this._url);
  final String _url;
  @override
  String currentBaseUrl() => _url;
}

class _LocaleAccessor implements LocaleAccessor {
  _LocaleAccessor(this._tag);
  final String _tag;
  @override
  String currentLanguageTag() => _tag;
}

/// Phase 3 stub. Phase 4 wires this to the auth repository's refresh call.
class _StubTokenRefresher implements TokenRefresher {
  @override
  Future<String> refresh() async {
    throw UnimplementedError('Token refresh is wired in Phase 4 (auth).');
  }
}

/// The app's configured [Dio]. Rebuilds when the locale/base URL change so
/// interceptors pick up new values.
final dioProvider = Provider<Dio>((ref) {
  final flavor = ref.watch(flavorConfigProvider);
  final storage = ref.watch(secureStorageProvider);
  final telemetry = ref.watch(telemetryProvider);
  final languageTag = ref.watch(languageTagProvider);
  final logger = ref.watch(loggerProvider);

  final uploadSink = StreamController<UploadProgress>.broadcast();
  ref.onDispose(uploadSink.close);

  final interceptors = <Interceptor>[
    UploadProgressInterceptor(uploadSink),
    LanguageInterceptor(_LocaleAccessor(languageTag)),
    HostSelectionInterceptor(
      _BaseUrlAccessor(flavor.urlServer),
      skipHosts: const ['googleapis.com', 'google.com'],
    ),
    AuthInterceptor(
      _CredentialAccessor(storage),
      skipPaths: const ['api/token/', 'sign_up', 'password-reset'],
    ),
    RefreshTokenInterceptor(_StubTokenRefresher()),
    LoggingInterceptor(telemetry: telemetry, verbose: true),
  ];

  logger.debug('Dio built for ${flavor.flavor.name} → ${flavor.urlServer}');
  return createDio(flavor, interceptors);
});