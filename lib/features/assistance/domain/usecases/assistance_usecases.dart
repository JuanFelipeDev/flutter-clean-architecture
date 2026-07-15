/// Assistance use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/assistance_entities.dart';
import '../repositories/assistance_repository.dart';

class GetAccountsUseCase {
  GetAccountsUseCase(this._repository);
  final AssistanceRepository _repository;
  Future<Result<List<Account>>> call(String affKey) => _repository.accounts(affKey);
}

class GetPlansUseCase {
  GetPlansUseCase(this._repository);
  final AssistanceRepository _repository;
  Future<Result<List<Plan>>> call(String affKey, String accountId) =>
      _repository.plans(affKey, accountId);
}

class GetFamiliesUseCase {
  GetFamiliesUseCase(this._repository);
  final AssistanceRepository _repository;
  Future<Result<List<ServiceFamily>>> call(String affKey, String planId) =>
      _repository.families(affKey, planId);
}

class GetServicesUseCase {
  GetServicesUseCase(this._repository);
  final AssistanceRepository _repository;
  Future<Result<List<Service>>> call(String affKey, String planId, String familyId) =>
      _repository.services(affKey, planId, familyId);
}

class GetCoverageQuestionsUseCase {
  GetCoverageQuestionsUseCase(this._repository);
  final AssistanceRepository _repository;
  Future<Result<List<CoverageQuestion>>> call(String serviceId) =>
      _repository.coverageQuestions(serviceId);
}

class CreateAssistanceUseCase {
  CreateAssistanceUseCase(this._repository);
  final AssistanceRepository _repository;
  Future<Result<Assistance>> call({
    required String affKey,
    required String serviceId,
    required String accountId,
    required String address,
    required String latitude,
    required String longitude,
    required List<CoverageAnswer> answers,
  }) async {
    return _repository.createAssistance(
      affKey: affKey,
      serviceId: serviceId,
      accountId: accountId,
      address: address,
      latitude: latitude,
      longitude: longitude,
      answers: answers,
    );
  }
}

class AutocompletePlacesUseCase {
  AutocompletePlacesUseCase(this._repository);
  final PlacesRepository _repository;
  Future<Result<List<PlaceSuggestion>>> call(String query) => _repository.autocomplete(query);
}

class PlaceDetailsUseCase {
  PlaceDetailsUseCase(this._repository);
  final PlacesRepository _repository;
  Future<Result<PlaceLocation>> call(String placeId) => _repository.placeDetails(placeId);
}

class ReverseGeocodeUseCase {
  ReverseGeocodeUseCase(this._repository);
  final PlacesRepository _repository;
  Future<Result<String>> call(double lat, double lng) =>
      _repository.reverseGeocode(lat, lng);
}