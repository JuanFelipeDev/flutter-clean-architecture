/// Riverpod providers for the storage layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'prefs_service.dart';
import 'secure_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// `shared_preferences` requires async init, so expose it as a [FutureProvider].
final prefsServiceProvider = FutureProvider<PrefsService>((ref) async {
  return PrefsService.create();
});

/// Real drift database (Phase 4). Disposed on container teardown.
final localDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});