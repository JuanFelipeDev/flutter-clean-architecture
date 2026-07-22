/// Places entities (Google Places autocomplete + Geocoding). Pure Dart.
library;

class PlaceSuggestion {
  const PlaceSuggestion({required this.placeId, required this.description});
  final String placeId;
  final String description;
}

class PlaceLocation {
  const PlaceLocation({
    required this.placeId,
    this.lat,
    this.lng,
    this.formattedAddress,
  });
  final String placeId;
  final double? lat;
  final double? lng;
  final String? formattedAddress;
}