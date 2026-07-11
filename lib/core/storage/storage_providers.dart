/// Riverpod providers for the storage layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_database.dart';
import 'prefs_service.dart';
import 'secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// `shared_preferences` requires async init, so expose it as a [FutureProvider].
final prefsServiceProvider = FutureProvider<PrefsService>((ref) async {
  return PrefsService.create();
});

/// Phase 3 placeholder DB; Phase 4 swaps in the drift `AppDatabase`.
final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return NoopLocalDatabase();
});