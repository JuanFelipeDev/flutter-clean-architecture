/// Authentication repository contract.
library;

import '../../../../core/error/result.dart';
import '../entities/login_entities.dart';

abstract class AuthRepository {
  /// Submits credentials; returns a [LoginSession] (which may signal 2FA).
  Future<Result<LoginSession>> login(
    LoginCredentials credentials, {
    String? deviceToken,
  });

  /// Verifies the 2FA code, returning the resolved session.
  Future<Result<LoginSession>> verifyTwoFactor(String userName, String code);

  /// Clears the persisted session (logout).
  Future<void> logout();
}
