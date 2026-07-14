/// Drift [AppDatabase] — the offline-first relational store. Versioned with a
/// migration strategy; opened via `sqlite3_flutter_libs` + `path_provider`.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'chat_outbox_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [AssistCacheEntries, CoordinateEntries, ChatOutboxEntries, NotificationCacheEntries],
  daos: [ChatOutboxDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => await m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

QueryExecutor _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'affiliate_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}