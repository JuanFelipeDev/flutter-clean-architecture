/// [SchedulingRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/scheduling_entities.dart';
import '../../domain/repositories/scheduling_repository.dart';
import '../datasources/scheduling_remote_data_source.dart';
import '../models/scheduling_dtos.dart';

class SchedulingRepositoryImpl implements SchedulingRepository {
  SchedulingRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final SchedulingRemoteDataSource remoteDataSource;
  final SchedulingMapper mapper;

  @override
  Future<Result<List<TimeSlot>>> timeSlots(String serviceId, DateTime date) async {
    try {
      final dateIso = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dtos = await remoteDataSource.fetchSlots(serviceId, dateIso);
      return Success(dtos.map(mapper.toEntity).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<ScheduleValidation>> validate(ScheduleRequest request) async {
    try {
      final dto = await remoteDataSource.validate(mapper.requestToBody(request));
      return Success(mapper.toValidation(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> schedule(ScheduleRequest request) async {
    try {
      await remoteDataSource.schedule(mapper.requestToBody(request));
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}