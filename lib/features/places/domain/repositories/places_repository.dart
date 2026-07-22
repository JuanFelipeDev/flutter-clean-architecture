/// Places repository contract: Google Places autocomplete, place details, and
/// reverse geocoding for the map picker.
library;

import '../../../../core/error/result.dart';
import '../entities/places_entities.dart';

abstract class PlacesRepository {
  Future<Result<List<PlaceSuggestion>>> autocomplete(String query);
  Future<Result<PlaceLocation>> placeDetails(String placeId);
  Future<Result<String>> reverseGeocode(double lat, double lng);
}