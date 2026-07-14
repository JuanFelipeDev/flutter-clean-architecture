/// Profile use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/profile_entities.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);
  final ProfileRepository _repository;
  Future<Result<AffiliateProfile>> call(String affKey) => _repository.getProfile(affKey);
}

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;
  Future<Result<AffiliateProfile>> call(AffiliateProfile profile) =>
      _repository.updateProfile(profile);
}

class ChangePasswordUseCase {
  ChangePasswordUseCase(this._repository);
  final ProfileRepository _repository;
  Future<Result<void>> call(String affKey, PassChange change) =>
      _repository.changePassword(affKey, change);
}

class GetDocumentTypesUseCase {
  GetDocumentTypesUseCase(this._repository);
  final ProfileRepository _repository;
  Future<Result<List<DocumentType>>> call() => _repository.documentTypes();
}

class GetCompaniesUseCase {
  GetCompaniesUseCase(this._repository);
  final ProfileRepository _repository;
  Future<Result<List<Company>>> call() => _repository.companies();
}