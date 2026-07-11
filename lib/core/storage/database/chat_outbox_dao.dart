/// DAO for the chat outbox — enqueue pending sends, list them, and mark
/// them sent/failed after a flush attempt.
library;

import 'package:drift/drift.dart';

import 'app_database.dart';
import 'tables.dart';

part 'chat_outbox_dao.g.dart';

@DriftAccessor(tables: [ChatOutboxEntries])
class ChatOutboxDao extends DatabaseAccessor<AppDatabase> with _$ChatOutboxDaoMixin {
  ChatOutboxDao(super.db);

  Future<int> enqueue(ChatOutboxEntriesCompanion entry) => into(chatOutboxEntries).insert(entry);

  Future<List<ChatOutboxEntry>> pending() {
    return (select(chatOutboxEntries)..where((t) => t.status.equals('pending')))
        .get();
  }

  Future<int> markStatus(int id, String status) {
    return (update(chatOutboxEntries)..where((t) => t.id.equals(id)))
        .write(ChatOutboxEntriesCompanion(status: Value(status)));
  }
}