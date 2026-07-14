/// Registration use cases (AFILIADO document validation + sign-up).
library;

import '../../../../core/error/result.dart';
import '../entities/registration_entities.dart';
import '../repositories/registration_repository.dart';

class ValidateDocumentUseCase {
  ValidateDocumentUseCase(this._repository);
  final RegistrationRepository _repository;

  Future<Result<ValidateDocumentResult>> call({
    required String document,
    required AccountType accountType,
  }) async {
    return _repository.validateDocument(document: document, accountType: accountType);
  }
}

class RegisterUseCase {
  RegisterUseCase(this._repository);
  final RegistrationRepository _repository;

  Future<Result<RegisterResult>> call({
    required AccountType accountType,
    required Map<String, String> fields,
  }) async {
    return _repository.register(accountType: accountType, fields: fields);
  }
}