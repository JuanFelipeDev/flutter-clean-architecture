/// Registration repository contract (AFILIADO `registro_mejorado/`,
/// `document_validate/`, `sign_up/`).
library;

import '../../../../core/error/result.dart';
import '../entities/registration_entities.dart';

abstract class RegistrationRepository {
  /// Validates the affiliate document/code before allowing registration
  /// (AFILIADO `ValidateDocumentAndPoliceActivity`).
  Future<Result<ValidateDocumentResult>> validateDocument({
    required String document,
    required AccountType accountType,
  });

  /// Submits the registration form (fields keyed by name, e.g. email, phone,
  /// name, lastname, nit). AFILIADO `RegisterActivity` -> `registro_mejorado/`
  /// / `sign_up/`.
  Future<Result<RegisterResult>> register({
    required AccountType accountType,
    required Map<String, String> fields,
  });
}