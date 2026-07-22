/// [BeneficiaryRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/beneficiary_entities.dart';
import '../../domain/repositories/beneficiary_repository.dart';
import '../datasources/beneficiary_remote_data_source.dart';
import '../models/beneficiary_dtos.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  BeneficiaryRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  final BeneficiaryRemoteDataSource remoteDataSource;
  final BeneficiaryMapper mapper;

  @override
  Future<Result<List<Beneficiary>>> list(String affKey) async {
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
  Future<Result<Beneficiary>> detail(
    String affKey,
    String beneficiaryId,
  ) async {
    try {
      final dto = await remoteDataSource.fetchDetail(affKey, beneficiaryId);
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<Beneficiary>> create(
    String affKey,
    Beneficiary beneficiary,
  ) async {
    try {
      final dto = await remoteDataSource.create(
        affKey,
        mapper.toDto(beneficiary),
      );
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<Beneficiary>> update(Beneficiary beneficiary) async {
    try {
      final dto = await remoteDataSource.update(mapper.toDto(beneficiary));
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> delete(String beneficiaryId) async {
    try {
      await remoteDataSource.delete(beneficiaryId);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<Relationship>>> relationships() async {
    try {
      final dtos = await remoteDataSource.fetchRelationships();
      return Success(dtos.map(mapper.toRelationship).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}
