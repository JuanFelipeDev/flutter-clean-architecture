library;

import '../../../../core/error/result.dart';
import '../entities/registration_entities.dart';
import '../repositories/registration_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._repository);
  final RegistrationRepository _repository;

  Future<Result<RegisterResult>> call({
    required String affkey,
    required Map<String, String> fields,
    required String clientId,
  }) async {
    return _repository.register(
      affkey: affkey,
      fields: fields,
      clientId: clientId,
    );
  }
}