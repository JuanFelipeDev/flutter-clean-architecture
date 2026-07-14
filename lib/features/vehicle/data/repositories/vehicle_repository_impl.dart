/// [VehicleRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/vehicle_entities.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_data_source.dart';
import '../models/vehicle_dtos.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final VehicleRemoteDataSource remoteDataSource;
  final VehicleMapper mapper;

  @override
  Future<Result<List<Vehicle>>> list(String affKey) async {
    try {
      final dtos = await remoteDataSource.fetchList(affKey);
      return Success(dtos.map(mapper.toEntity).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<Vehicle>> create(String affKey, Vehicle vehicle) async {
    try {
      final dto = await remoteDataSource.create(affKey, mapper.toDto(vehicle));
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> disable(String vehicleId) async {
    try {
      await remoteDataSource.disable(vehicleId);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<Brand>>> brands() async {
    try {
      final dtos = await remoteDataSource.fetchBrands();
      return Success(dtos.map(mapper.toBrand).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<VehicleModel>>> models(String brandId) async {
    try {
      final dtos = await remoteDataSource.fetchModels(brandId);
      return Success(dtos.map(mapper.toModel).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}