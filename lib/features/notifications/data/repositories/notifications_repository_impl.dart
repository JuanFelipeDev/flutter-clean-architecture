/// [NotificationsRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/notification_entities.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/notification_dtos.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  final NotificationsRemoteDataSource remoteDataSource;
  final NotificationsMapper mapper;

  @override
  Future<Result<List<AffiliateNotification>>> list(String username) async {
    try {
      final dtos = await remoteDataSource.fetchList(username);
      return Success(dtos.map(mapper.toEntity).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<int>> unreadCount(String username) async {
    try {
      return Success(await remoteDataSource.fetchUnreadCount(username));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}
