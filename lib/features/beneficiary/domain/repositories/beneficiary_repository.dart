/// `crear_beneficiarios/`, `editar_beneficiario/`, `eliminar_beneficiario/`,
/// `obtener_parentescos/`).
library;

import '../../../../core/error/result.dart';
import '../entities/beneficiary_entities.dart';

abstract class BeneficiaryRepository {
  Future<Result<List<Beneficiary>>> list(String affKey);
  Future<Result<Beneficiary>> detail(String affKey, String beneficiaryId);
  Future<Result<Beneficiary>> create(String affKey, Beneficiary beneficiary);
  Future<Result<Beneficiary>> update(Beneficiary beneficiary);
  Future<Result<void>> delete(String beneficiaryId);
  Future<Result<List<Relationship>>> relationships();
}
