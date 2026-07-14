/// [SettingsRepository] implementation. Logout clears the session via secure
/// storage and notifies the caller to flip auth state.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/settings_entities.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';
import '../models/settings_dtos.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
    required this.storage,
  });

  final SettingsRemoteDataSource remoteDataSource;
  final SettingsMapper mapper;
  final SecureStorageService storage;

  @override
  Future<Result<AppConfiguration>> appConfiguration(String affKey) async {
    try {
      final dto = await remoteDataSource.fetchConfiguration(affKey);
      return Success(mapper.toEntity(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await remoteDataSource.logout();
    } on Object {
      // Best-effort: clear locally even if the server call fails.
    }
    try {
      await storage.clearSession();
      return Result<void>.guard(() {});
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}