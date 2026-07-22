/// Core [SessionRepository] implementation: token persistence + refresh.
/// The login UI/strategies live in `features/authentication` (Phase 5); this
/// is the reusable infra the interceptors and guards depend on.
library;

import 'dart:async';

import '../error/failures.dart';
import '../error/result.dart';
import '../storage/secure_storage_service.dart';
import 'auth_api_service.dart';
import 'session_data.dart';
import 'session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({required this.storage, required this.authApi});

  final SecureStorageService storage;
  final AuthApiService authApi;

  @override
  Future<bool> hasSession() => storage.hasSession();

  @override
  Future<String?> accessToken() => storage.accessToken();

  @override
  Future<void> clear() async {
    await storage.clearSession();
  }

  @override
  Future<Result<void>> refresh() async {
    return Result.guardAsync(() async {
      final data = await SessionData.load(storage);
      final refreshToken = data?.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        throw Failure.auth('No refresh token');
      }

      final result = await authApi.refresh(refreshToken);
      final updated = SessionData(
        accessToken: result.access,
        refreshToken: result.refresh ?? refreshToken,
        clientId: data?.clientId,
        username: data?.username,
        affKey: data?.affKey,
      );
      await updated.save(storage);
    });
  }
}
