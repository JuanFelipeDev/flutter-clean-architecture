/// Login use case (AFILIADO `LoginViewModel.setCredentials`).
library;

import '../../../../core/error/result.dart';
import '../entities/login_entities.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<LoginSession>> call(
    LoginCredentials credentials, {
    String? deviceToken,
  }) async {
    return _repository.login(credentials, deviceToken: deviceToken);
  }
}