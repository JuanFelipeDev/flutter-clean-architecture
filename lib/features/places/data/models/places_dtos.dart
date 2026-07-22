/// DTOs + mapper for Google Places autocomplete and place details.
library;

import '../../domain/entities/places_entities.dart';

class PlaceSuggestionDto {
  const PlaceSuggestionDto({this.placeId, this.description});
  final String? placeId;
  final String? description;

  /// Parses a Places API (New) autocomplete suggestion. Each entry is a union
  /// of `placePrediction` / `queryPrediction`; only `placePrediction` carries a
  /// `placeId` usable for place details. `text` is a `FormattableText` object
  /// (`{ "text": "...", "matches": [...] }`), not a bare string.
  factory PlaceSuggestionDto.fromJson(Map<String, dynamic> json) {
    final placePrediction = json['placePrediction'];
    if (placePrediction is Map<String, dynamic>) {
      return PlaceSuggestionDto(
        placeId: placePrediction['placeId']?.toString(),
        description: _textToString(placePrediction['text']),
      );
    }
    final queryPrediction = json['queryPrediction'];
    if (queryPrediction is Map<String, dynamic>) {
      // Query predictions have no placeId (they're free-text searches).
      return PlaceSuggestionDto(
        placeId: null,
        description: _textToString(queryPrediction['text']),
      );
    }
    // Fallback for flat/legacy shapes (placeId + text/description at top).
    return PlaceSuggestionDto(
      placeId: json['placeId']?.toString(),
      description:
          _textToString(json['text']) ?? json['description']?.toString(),
    );
  }
}

/// `text` may be a `FormattableText` object (`{ "text": "..." }`) or a bare
/// string; extract the human-readable string either way.
String? _textToString(dynamic text) {
  if (text == null) return null;
  if (text is Map) return text['text']?.toString();
  return text.toString();
}

class PlaceLocationDto {
  const PlaceLocationDto({
    this.placeId,
    this.lat,
    this.lng,
    this.formattedAddress,
  });
  final String? placeId;
  final double? lat;
  final double? lng;
  final String? formattedAddress;

  factory PlaceLocationDto.fromJson(Map<String, dynamic> json) {
    final rawLoc = json['location'];
    final Map<String, dynamic>? loc = rawLoc is Map
        ? Map<String, dynamic>.from(rawLoc)
        : null;
    final lat = loc?['latitude'] ?? loc?['lat'];
    final lng = loc?['longitude'] ?? loc?['lng'];
    return PlaceLocationDto(
      placeId: json['id']?.toString() ?? json['placeId']?.toString(),
      lat: lat is num ? lat.toDouble() : null,
      lng: lng is num ? lng.toDouble() : null,
      formattedAddress:
          json['formattedAddress']?.toString() ?? json['address']?.toString(),
    );
  }
}

class PlacesMapper {
  const PlacesMapper();

  PlaceSuggestion toSuggestion(PlaceSuggestionDto dto) => PlaceSuggestion(
    placeId: dto.placeId ?? '',
    description: dto.description ?? '',
  );

  PlaceLocation toPlace(PlaceLocationDto dto) => PlaceLocation(
    placeId: dto.placeId ?? '',
    lat: dto.lat,
    lng: dto.lng,
    formattedAddress: dto.formattedAddress,
  );
}