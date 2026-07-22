/// Beneficiary use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/beneficiary_entities.dart';
import '../repositories/beneficiary_repository.dart';

class GetBeneficiariesUseCase {
  GetBeneficiariesUseCase(this._repository);
  final BeneficiaryRepository _repository;
  Future<Result<List<Beneficiary>>> call(String affKey) =>
      _repository.list(affKey);
}

class GetBeneficiaryDetailUseCase {
  GetBeneficiaryDetailUseCase(this._repository);
  final BeneficiaryRepository _repository;
  Future<Result<Beneficiary>> call(String affKey, String beneficiaryId) =>
      _repository.detail(affKey, beneficiaryId);
}

class CreateBeneficiaryUseCase {
  CreateBeneficiaryUseCase(this._repository);
  final BeneficiaryRepository _repository;
  Future<Result<Beneficiary>> call(String affKey, Beneficiary beneficiary) =>
      _repository.create(affKey, beneficiary);
}

class UpdateBeneficiaryUseCase {
  UpdateBeneficiaryUseCase(this._repository);
  final BeneficiaryRepository _repository;
  Future<Result<Beneficiary>> call(Beneficiary beneficiary) =>
      _repository.update(beneficiary);
}

class DeleteBeneficiaryUseCase {
  DeleteBeneficiaryUseCase(this._repository);
  final BeneficiaryRepository _repository;
  Future<Result<void>> call(String beneficiaryId) =>
      _repository.delete(beneficiaryId);
}

class GetRelationshipsUseCase {
  GetRelationshipsUseCase(this._repository);
  final BeneficiaryRepository _repository;
  Future<Result<List<Relationship>>> call() => _repository.relationships();
}
