/// Riverpod providers for the network layer. Assembles the ordered Dio
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_providers.dart';
import '../logging/logging_providers.dart';
import '../localization/localization_providers.dart';
import '../session/session_data.dart';
import '../session/session_providers.dart';
import '../session/session_repository.dart';
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

class _CredentialAccessor implements CredentialAccessor {
  _CredentialAccessor(this._storage, this._session);
  final SecureStorageService _storage;
  final SessionData? _session;

  @override
  Future<String?> accessToken() => _storage.accessToken();

  @override
  String? clientId() => _session?.clientId;

  @override
  String? username() => _session?.username;
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

/// Real refresher: delegates to [SessionRepository.refresh], then reads the
/// new access token from secure storage.
class _TokenRefresherImpl implements TokenRefresher {
  _TokenRefresherImpl(this._repository, this._storage);
  final SessionRepository _repository;
  final SecureStorageService _storage;

  @override
  Future<String> refresh() async {
    final result = await _repository.refresh();
    return result.fold(
      onSuccess: (_) async => (await _storage.accessToken())!,
      onFailure: (failure) => throw failure,
    );
  }
}

/// The app's configured [Dio]. Rebuilds when the locale/base URL/env/session
/// change so interceptors pick up new values.
final dioProvider = Provider<Dio>((ref) {
  final flavor = ref.watch(flavorConfigProvider);
  final env = ref.watch(currentEnvironmentProvider);
  final storage = ref.watch(secureStorageProvider);
  final telemetry = ref.watch(telemetryProvider);
  final languageTag = ref.watch(languageTagProvider);
  final logger = ref.watch(loggerProvider);
  final session = ref.watch(cachedSessionProvider);
  final sessionRepository = ref.watch(sessionRepositoryProvider);

  final uploadSink = StreamController<UploadProgress>.broadcast();
  ref.onDispose(uploadSink.close);

  final interceptors = <Interceptor>[
    UploadProgressInterceptor(uploadSink),
    LanguageInterceptor(_LocaleAccessor(languageTag)),
    HostSelectionInterceptor(
      _BaseUrlAccessor(flavor.urlServerFor(env)),
      skipHosts: const ['googleapis.com', 'google.com'],
    ),
    AuthInterceptor(
      _CredentialAccessor(storage, session),
      skipPaths: const ['api/token/', 'validate-affiliate', 'password-reset'],
    ),
    RefreshTokenInterceptor(_TokenRefresherImpl(sessionRepository, storage)),
    LoggingInterceptor(telemetry: telemetry, verbose: true),
  ];

  logger.debug('Dio built for ${flavor.flavor.name} → ${flavor.urlServer}');
  return createDio(flavor, env, interceptors);
});
