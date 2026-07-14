/// [ChatRepository] implementation with an offline outbox fallback
/// (improvement over AFILIADO which drops offline sends). Uses the drift
/// `ChatOutboxDao` to enqueue sends that fail due to no network, then flushes
/// them when connectivity is restored.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/storage/database/app_database.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_dtos.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
    required this.database,
    required this.connectivity,
  });

  final ChatRemoteDataSource remoteDataSource;
  final ChatMapper mapper;
  final AppDatabase database;
  final ConnectivityService connectivity;

  @override
  Future<Result<List<ChatMessage>>> history(String assistanceId, {int page = 1}) async {
    try {
      final dtos = await remoteDataSource.fetchHistory(assistanceId, page: page);
      return Success(dtos.map(mapper.toEntity).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> send(String assistanceId, String content) async {
    try {
      await remoteDataSource.send(assistanceId, content);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      // Offline / network failure -> enqueue in the outbox and flush later.
      if (await connectivity.isConnected == false || e.type == DioExceptionType.connectionError) {
        await database.chatOutboxDao.enqueue(
          ChatOutboxEntriesCompanion.insert(
            assistanceId: assistanceId,
            content: content,
          ),
        );
        return Result<void>.guard(() {});
      }
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> flushOutbox(String assistanceId) async {
    try {
      final pending = await database.chatOutboxDao.pending();
      for (final entry in pending) {
        try {
          await remoteDataSource.send(entry.assistanceId, entry.content);
          await database.chatOutboxDao.markStatus(entry.id, 'sent');
        } on Object {
          await database.chatOutboxDao.markStatus(entry.id, 'failed');
        }
      }
      return Result<void>.guard(() {});
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}