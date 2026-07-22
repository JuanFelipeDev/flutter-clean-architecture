import 'package:affiliate_app/features/places/data/models/places_dtos.dart';
import 'package:affiliate_app/features/places/domain/entities/places_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlaceSuggestionDto', () {
    test('parses placeId + text/description (flat fallback)', () {
      final dto = PlaceSuggestionDto.fromJson({
        'placeId': 'p1',
        'text': 'Calle 100',
      });
      expect(dto.placeId, 'p1');
      expect(dto.description, 'Calle 100');

      final dto2 = PlaceSuggestionDto.fromJson({
        'placeId': 'p2',
        'description': 'Carrera 7',
      });
      expect(dto2.description, 'Carrera 7');
    });

    test('parses Places API (New) placePrediction nesting', () {
      // Real shape of v1/places:autocomplete suggestions[].
      final dto = PlaceSuggestionDto.fromJson({
        'placePrediction': {
          'place': 'places/ChIJ123',
          'placeId': 'ChIJ123',
          'text': {
            'text': 'Calle 100, Bogotá',
            'matches': [{'startOffset': 0, 'endOffset': 6}],
          },
        },
      });
      expect(dto.placeId, 'ChIJ123');
      expect(dto.description, 'Calle 100, Bogotá');
    });

    test('queryPrediction (no placeId) yields empty placeId', () {
      final dto = PlaceSuggestionDto.fromJson({
        'queryPrediction': {
          'text': {'text': 'pizza near me'},
        },
      });
      expect(dto.placeId, isNull);
      expect(dto.description, 'pizza near me');
    });
  });

  group('PlaceLocationDto', () {
    test('parses location.latitude/longitude + formattedAddress', () {
      final dto = PlaceLocationDto.fromJson({
        'id': 'p1',
        'location': {'latitude': 4.6, 'longitude': -74.0},
        'formattedAddress': 'Bogotá, Colombia',
      });
      expect(dto.placeId, 'p1');
      expect(dto.lat, 4.6);
      expect(dto.lng, -74.0);
      expect(dto.formattedAddress, 'Bogotá, Colombia');
    });

    test('parses lat/lng alternate keys', () {
      final dto = PlaceLocationDto.fromJson({
        'placeId': 'p2',
        'location': {'lat': 1.0, 'lng': 2.0},
      });
      expect(dto.lat, 1.0);
      expect(dto.lng, 2.0);
    });
  });

  group('PlacesMapper', () {
    const mapper = PlacesMapper();

    test('maps a suggestion dto', () {
      final entity = mapper.toSuggestion(
        const PlaceSuggestionDto(placeId: 'p1', description: 'Calle 100'),
      );
      expect(entity, isA<PlaceSuggestion>());
      expect(entity.placeId, 'p1');
      expect(entity.description, 'Calle 100');
    });

    test('maps a place dto', () {
      final entity = mapper.toPlace(
        const PlaceLocationDto(
          placeId: 'p1',
          lat: 4.6,
          lng: -74.0,
          formattedAddress: 'Bogotá',
        ),
      );
      expect(entity, isA<PlaceLocation>());
      expect(entity.placeId, 'p1');
      expect(entity.lat, 4.6);
      expect(entity.lng, -74.0);
      expect(entity.formattedAddress, 'Bogotá');
    });

    test('defaults empty ids to empty string', () {
      final entity = mapper.toSuggestion(const PlaceSuggestionDto());
      expect(entity.placeId, '');
      expect(entity.description, '');
    });
  });
}