/// [VideoCallRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/videocall_entities.dart';
import '../../domain/repositories/videocall_repository.dart';
import '../datasources/videocall_remote_data_source.dart';
import '../models/videocall_dtos.dart';

class VideoCallRepositoryImpl implements VideoCallRepository {
  VideoCallRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  final VideoCallRemoteDataSource remoteDataSource;
  final VideoCallMapper mapper;

  @override
  Future<Result<ScheduleAvailability>> checkSchedule(
    String assistanceId,
  ) async {
    try {
      final dto = await remoteDataSource.checkSchedule(assistanceId);
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<bool>> requestRecordingPermission() async {
    try {
      return Success(await remoteDataSource.requestRecordingPermission());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> updateRecordingPermission(bool granted) async {
    try {
      await remoteDataSource.updateRecordingPermission(granted);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> startRecording() async {
    try {
      await remoteDataSource.startRecording();
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> stopRecording() async {
    try {
      await remoteDataSource.stopRecording();
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}
