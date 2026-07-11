/// App bootstrap. Initializes Flutter bindings, telemetry (Sentry, guarded by
/// DSN), global error handlers, and seeds the session state from secure
/// storage before running the app. Mirrors PRESTADOR's `ProviderApp.onCreate`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/error/global_error_handler.dart';
import 'core/logging/logging_providers.dart';
import 'core/session/session_state_provider.dart';
import 'core/storage/storage_providers.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  final telemetry = container.read(telemetryProvider);
  await telemetry.init();
  installGlobalErrorHandlers(telemetry);

  // Seed auth state from persisted session (AFILIADO `OpenApp`).
  final storage = container.read(secureStorageProvider);
  final hasSession = await storage.hasSession();
  container.read(isAuthenticatedProvider.notifier).state = hasSession;

  // Keep the container alive for the app lifetime.
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AffiliateApp(),
    ),
  );
}