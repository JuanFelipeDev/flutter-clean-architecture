/// Flavor & environment configuration injected at compile time via
/// `--dart-define-from-file flavors/<flavor>/config.json`.
///
/// Mirrors AFILIADO's product-flavor `BuildConfig` flags (CLIENT_ID, COUNTRY,
/// login strategy, register fields, per-env server URLs) and PRESTADOR's
/// `BuildConfig.URL_SERVER_*` / `ProviderFlavors` enum, but expressed as a
/// single immutable typed object instead of scattered static getters.
library;

import 'package:flutter/foundation.dart';

/// White-label flavors reproduced from AFILIADO/PRESTADOR.
enum Flavor {
  basenewsoa,
  roble,
  masservicios;

  static Flavor fromName(String? name) {
    return Flavor.values.firstWhere(
      (f) => f.name == name,
      orElse: () => Flavor.basenewsoa,
    );
  }
}

/// Runtime environment selector (AFILIADO's `TYPE_ENVIROMENT`).
enum Environment {
  dev,
  qa,
  prod,
  preprod;

  static Environment fromName(String? name) {
    return Environment.values.firstWhere(
      (e) => e.name == name,
      orElse: () => Environment.dev,
    );
  }
}

/// Login screen shape per flavor (AFILIADO: standard / EO 3-field / Roble
/// NIT+placa+DPI).
enum LoginStrategy {
  standard,
  eo,
  roble;

  static LoginStrategy fromName(String? name) {
    return LoginStrategy.values.firstWhere(
      (s) => s.name == name,
      orElse: () => LoginStrategy.standard,
    );
  }
}

/// Immutable, typed representation of the active build flavor.
///
/// Set once in [bootstrap] from [FlavorConfig.fromEnvironment] and exposed
/// through a Riverpod provider. Pure data — no Flutter widgets here.
@immutable
class FlavorConfig {
  const FlavorConfig({
    required this.flavor,
    required this.environment,
    required this.appName,
    required this.primaryColor,
    required this.accentColor,
    required this.loginStrategy,
    required this.registerFields,
    required this.clientId,
    required this.country,
    required this.urlServerDev,
    required this.urlServerQa,
    required this.urlServerProd,
    required this.urlServerPreprod,
    required this.urlSocket,
    required this.socketPath,
    required this.sentryDsn,
    required this.mapsApiKey,
  });

  final Flavor flavor;
  final Environment environment;
  final String appName;
  final int primaryColor;
  final int accentColor;
  final LoginStrategy loginStrategy;
  final List<String> registerFields;
  final String clientId;
  final String country;
  final String urlServerDev;
  final String urlServerQa;
  final String urlServerProd;
  final String urlServerPreprod;
  final String urlSocket;
  final String socketPath;
  final String sentryDsn;
  final String mapsApiKey;

  /// Base server URL for the active environment (runtime switchable later via
  /// the env picker, AFILIADO's `setTypeEnviroment`).
  String get urlServer {
    switch (environment) {
      case Environment.dev:
        return urlServerDev;
      case Environment.qa:
        return urlServerQa;
      case Environment.prod:
        return urlServerProd;
      case Environment.preprod:
        return urlServerPreprod;
    }
  }

  bool get isProduction => environment == Environment.prod;

  /// Reads the compile-time `--dart-define` values into a typed object.
  factory FlavorConfig.fromEnvironment() {
    return FlavorConfig(
      flavor: Flavor.fromName(const String.fromEnvironment('FLAVOR')),
      environment: Environment.fromName(
        const String.fromEnvironment('ENVIRONMENT'),
      ),
      appName: const String.fromEnvironment('APP_NAME', defaultValue: 'Afiliado'),
      primaryColor: _parseColor(
        const String.fromEnvironment('PRIMARY_COLOR', defaultValue: '0xFF1E88E5'),
      ),
      accentColor: _parseColor(
        const String.fromEnvironment('ACCENT_COLOR', defaultValue: '0xFFFFC107'),
      ),
      loginStrategy: LoginStrategy.fromName(
        const String.fromEnvironment('LOGIN_STRATEGY', defaultValue: 'standard'),
      ),
      registerFields: const String.fromEnvironment(
        'REGISTER_FIELDS',
        defaultValue: 'email,phone,name,lastname',
      ).split(',').where((s) => s.isNotEmpty).toList(),
      clientId: const String.fromEnvironment('CLIENT_ID', defaultValue: ''),
      country: const String.fromEnvironment('COUNTRY', defaultValue: 'CO'),
      urlServerDev: const String.fromEnvironment(
        'URL_SERVER_DEV',
        defaultValue: 'https://dev.sistemaoperaciones.com',
      ),
      urlServerQa: const String.fromEnvironment(
        'URL_SERVER_QA',
        defaultValue: 'https://qa.sistemaoperaciones.com',
      ),
      urlServerProd: const String.fromEnvironment(
        'URL_SERVER_PROD',
        defaultValue: 'https://prod.sistemaoperaciones.com',
      ),
      urlServerPreprod: const String.fromEnvironment(
        'URL_SERVER_PREPROD',
        defaultValue: 'https://preprod.sistemaoperaciones.com',
      ),
      urlSocket: const String.fromEnvironment(
        'URL_SOCKET',
        defaultValue: 'https://dev.sistemaoperaciones.com',
      ),
      socketPath: const String.fromEnvironment(
        'SOCKET_PATH',
        defaultValue: '/soaang-notifier/wss/',
      ),
      sentryDsn: const String.fromEnvironment('SENTRY_DSN', defaultValue: ''),
      mapsApiKey: const String.fromEnvironment('MAPS_API_KEY', defaultValue: ''),
    );
  }

  static int _parseColor(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
    return int.tryParse(value.replaceFirst('#', '0xFF')) ?? 0xFF1E88E5;
  }

  @override
  String toString() =>
      'FlavorConfig(flavor: $flavor, env: $environment, client: $clientId)';
}