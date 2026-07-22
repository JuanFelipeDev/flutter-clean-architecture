/// [TrackingRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/tracking_entities.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_data_source.dart';
import '../models/tracking_dtos.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  TrackingRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  final TrackingRemoteDataSource remoteDataSource;
  final TrackingMapper mapper;

  @override
  Future<Result<List<ActiveAssistance>>> activeAssistances(
    String affKey,
  ) async {
    try {
      final dtos = await remoteDataSource.fetchActive(affKey);
      return Success(dtos.map(mapper.toEntity).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> confirmArrival(String assistanceId) async {
    try {
      await remoteDataSource.stageUpdate(assistanceId, 'arrival_confirmed');
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> confirmFinal(String assistanceId) async {
    try {
      await remoteDataSource.stageUpdate(assistanceId, 'final_confirmed');
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> sendPanic(
    String assistanceId,
    double lat,
    double lng,
  ) async {
    try {
      await remoteDataSource.panic(assistanceId, lat, lng);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}
