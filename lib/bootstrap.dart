/// App bootstrap. Initializes Flutter bindings, telemetry (Sentry, guarded by
/// DSN), global error handlers, and seeds the session state from secure
/// storage before running the app. Mirrors PRESTADOR's `ProviderApp.onCreate`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
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