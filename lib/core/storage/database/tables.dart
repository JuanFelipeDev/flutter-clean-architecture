/// Drift table definitions for the local relational store. Tables mirror the
/// offline-first shape AFILIADO/PRESTADOR need: cached assists, live provider
/// coordinates, a chat-send outbox (Flutter improvement — AFILIADO drops
/// offline sends), and a notifications cache.
library;

import 'package:drift/drift.dart';

/// Cached assistance summaries (AFILIADO active/history lists).
class AssistCacheEntries extends Table {
  TextColumn get id => text()();
  TextColumn get affKey => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get rawJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Live provider coordinates per assistance (AFILIADO `mSocketCoordinates`).
class CoordinateEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get assistanceId => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get sender => text().withDefault(const Constant('provider'))();
  DateTimeColumn get recordedAt => dateTime()();
}

/// Chat send outbox — messages persisted while offline and flushed on
/// reconnect (improvement over AFILIADO which loses them).
class ChatOutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get assistanceId => text()();
  TextColumn get content => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Cached notifications (AFILIADO `obtener_numero_notificaciones` / list).
class NotificationCacheEntries extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get rawJson => text()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}