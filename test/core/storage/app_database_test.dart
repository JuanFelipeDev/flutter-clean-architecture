import 'package:affiliate_app/core/storage/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  test('chat outbox enqueue + pending + markStatus round-trip', () async {
    final id = await db.chatOutboxDao.enqueue(
      ChatOutboxEntriesCompanion.insert(
        assistanceId: 'assist-1',
        content: 'hello',
      ),
    );
    expect(id, greaterThan(0));

    final pending = await db.chatOutboxDao.pending();
    expect(pending, hasLength(1));
    expect(pending.first.content, 'hello');
    expect(pending.first.status, 'pending');

    final updated = await db.chatOutboxDao.markStatus(pending.first.id, 'sent');
    expect(updated, 1);
    expect(await db.chatOutboxDao.pending(), isEmpty);
  });
}
