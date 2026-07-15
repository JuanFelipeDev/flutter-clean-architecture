/// App bootstrap. Initializes Flutter bindings, telemetry (Sentry, guarded by
/// DSN), global error handlers, and seeds the session state from secure
/// storage before running the app. Mirrors PRESTADOR's `ProviderApp.onCreate`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/config_providers.dart';
import 'core/config/flavor_config.dart';
import 'core/error/global_error_handler.dart';
import 'core/logging/logging_providers.dart';
import 'core/session/session_data.dart';
import 'core/session/session_providers.dart';
import 'core/session/session_state_provider.dart';
import 'core/storage/storage_providers.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  final telemetry = container.read(telemetryProvider);
  await telemetry.init();
  installGlobalErrorHandlers(telemetry);

  // Seed the runtime environment override from persisted prefs (AFILIADO
  // `TYPE_ENVIROMENT`), falling back to the compile-time flavor env.
  try {
    final prefs = await container.read(prefsServiceProvider.future);
    final savedEnv = prefs.getString('TYPE_ENVIROMENT');
    if (savedEnv != null && savedEnv.isNotEmpty) {
      container.read(currentEnvironmentProvider.notifier).state =
          Environment.fromName(savedEnv);
    }
  } on Object {
    // Prefs not available yet — fall back to compile-time env (already set).
  }

  // Seed auth state + cached session from persisted storage (AFILIADO
  // `OpenApp` token-vs-login decision).
  final storage = container.read(secureStorageProvider);
  final session = await SessionData.load(storage);
  container.read(isAuthenticatedProvider.notifier).state = session != null;
  container.read(cachedSessionProvider.notifier).state = session;

  // Keep the container alive for the app lifetime.
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AffiliateApp(),
    ),
  );
}