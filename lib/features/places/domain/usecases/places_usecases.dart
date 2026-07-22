/// Places use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/places_entities.dart';
import '../repositories/places_repository.dart';

class AutocompletePlacesUseCase {
  AutocompletePlacesUseCase(this._repository);
  final PlacesRepository _repository;
  Future<Result<List<PlaceSuggestion>>> call(String query) =>
      _repository.autocomplete(query);
}

class PlaceDetailsUseCase {
  PlaceDetailsUseCase(this._repository);
  final PlacesRepository _repository;
  Future<Result<PlaceLocation>> call(String placeId) =>
      _repository.placeDetails(placeId);
}

class ReverseGeocodeUseCase {
  ReverseGeocodeUseCase(this._repository);
  final PlacesRepository _repository;
  Future<Result<String>> call(double lat, double lng) =>
      _repository.reverseGeocode(lat, lng);
}