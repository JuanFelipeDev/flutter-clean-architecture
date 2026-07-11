/// Two-factor verification use case (AFILIADO `DoubleFactAuthViewModel`).
library;

import '../../../../core/error/result.dart';
import '../entities/login_entities.dart';
import '../repositories/auth_repository.dart';

class TwoFactorUseCase {
  TwoFactorUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<LoginSession>> call(String userName, String code) async {
    return _repository.verifyTwoFactor(userName, code);
  }
}