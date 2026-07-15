/// Assistance repository contract (AFILIADO catalogs + creation).
library;

import '../../../../core/error/result.dart';
import '../entities/assistance_entities.dart';

abstract class AssistanceRepository {
  Future<Result<List<Account>>> accounts(String affKey);
  Future<Result<List<Plan>>> plans(String affKey, String accountId);
  Future<Result<List<ServiceFamily>>> families(String affKey, String planId);
  Future<Result<List<Service>>> services(String affKey, String planId, String familyId);
  Future<Result<List<CoverageQuestion>>> coverageQuestions(String serviceId);
  Future<Result<Assistance>> createAssistance({
    required String affKey,
    required String serviceId,
    required String accountId,
    required String address,
    required String latitude,
    required String longitude,
    required List<CoverageAnswer> answers,
  });
}

/// Google Places repository (AFILIADO `v1/places:autocomplete` + details +
/// reverse geocoding for the map picker).
abstract class PlacesRepository {
  Future<Result<List<PlaceSuggestion>>> autocomplete(String query);
  Future<Result<PlaceLocation>> placeDetails(String placeId);
  Future<Result<String>> reverseGeocode(double lat, double lng);
}