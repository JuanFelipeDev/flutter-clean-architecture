/// `document_validate/`, `sign_up/`).
library;

import '../../../../core/error/result.dart';
import '../entities/registration_entities.dart';

abstract class RegistrationRepository {
  /// Submits the registration form (fields keyed by name, e.g. email, phone,
  /// / `sign_up/`.
  Future<Result<RegisterResult>> register({
    required String affkey,
    required Map<String, String> fields,
    required String clientId,
  });
}
