/// [HistoryRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/history_entities.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';
import '../models/history_dtos.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final HistoryRemoteDataSource remoteDataSource;
  final HistoryMapper mapper;

  @override
  Future<Result<List<HistoryItem>>> list(String affKey, {int page = 1}) async {
    try {
      final dtos = await remoteDataSource.fetchPage(affKey, page: page);
      return Success(dtos.map(mapper.toEntity).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}