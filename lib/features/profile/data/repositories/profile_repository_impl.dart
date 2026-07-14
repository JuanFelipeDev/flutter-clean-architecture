/// [ProfileRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/profile_entities.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_dtos.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final ProfileRemoteDataSource remoteDataSource;
  final ProfileMapper mapper;

  @override
  Future<Result<AffiliateProfile>> getProfile(String affKey) async {
    try {
      final dto = await remoteDataSource.fetchProfile(affKey);
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<AffiliateProfile>> updateProfile(AffiliateProfile profile) async {
    try {
      final dto = await remoteDataSource.updateProfile(mapper.toDto(profile));
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> changePassword(String affKey, PassChange change) async {
    try {
      await remoteDataSource.changePassword(affKey, {
        'oldPassword': change.oldPassword,
        'newPassword': change.newPassword,
      });
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<DocumentType>>> documentTypes() async {
    try {
      final dtos = await remoteDataSource.fetchDocumentTypes();
      return Success(dtos.map(mapper.toDocumentType).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<Company>>> companies() async {
    try {
      final dtos = await remoteDataSource.fetchCompanies();
      return Success(dtos.map(mapper.toCompany).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}