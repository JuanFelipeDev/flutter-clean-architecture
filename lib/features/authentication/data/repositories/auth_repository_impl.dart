/// [AuthRepository] implementation. Persists the resolved session via secure
/// storage and notifies the caller to update auth state.
library;

import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/session/session_data.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/login_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_session_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storage,
    required this.onSessionChanged,
  });

  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService storage;
  final void Function(SessionData?) onSessionChanged;

  static const LoginSessionMapper _mapper = LoginSessionMapper();

  @override
  Future<Result<LoginSession>> login(
    LoginCredentials credentials, {
    String? deviceToken,
  }) async {
    try {
      final dto = await remoteDataSource.login(
        credentials,
        deviceToken: deviceToken,
      );
      final session = _mapper.toEntity(dto);

      if (session.requiresTwoFactor) {
        return Success(session);
      }
      await _persist(session);
      return Success(session);
    } on DioException catch (error) {
      return Err(mapDioError(error));
    } on Object catch (error, stackTrace) {
      return Err(Failure.unknown(error, stackTrace));
    }
  }

  @override
  Future<Result<LoginSession>> verifyTwoFactor(
    String userName,
    String code,
  ) async {
    try {
      final dto = await remoteDataSource.verifyTwoFactor(userName, code);
      final session = _mapper.toEntity(dto);
      await _persist(session);
      return Success(session);
    } on DioException catch (error) {
      return Err(mapDioError(error));
    } on Object catch (error, stackTrace) {
      return Err(Failure.unknown(error, stackTrace));
    }
  }

  @override
  Future<void> logout() async {
    await storage.clearSession();
    onSessionChanged(null);
  }

  Future<void> _persist(LoginSession session) async {
    if (session.accessToken.isEmpty) return;
    final data = session.toSessionData();
    await data.save(storage);
    onSessionChanged(data);
  }
}
