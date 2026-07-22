/// Remote data source for Google Places autocomplete, place details, and
/// reverse geocoding. Uses two Dio clients (Places host with header auth,
/// Geocoding host with `key` query param).
library;

import 'package:dio/dio.dart';

import '../../../../core/utils/json_list_parser.dart';
import '../models/places_dtos.dart';

class PlacesRemoteDataSource {
  PlacesRemoteDataSource(this._dio, this._geocodingDio, this._apiKey);

  /// Places API host (`https://places.googleapis.com/`, header auth).
  final Dio _dio;

  /// Geocoding API host (`https://maps.googleapis.com/`, `key` query param).
  final Dio _geocodingDio;
  final String _apiKey;

  /// `v1/places:autocomplete` (POST body with input).
  Future<List<PlaceSuggestionDto>> autocomplete(String query) async {
    final res = await _dio.post<dynamic>(
      'v1/places:autocomplete',
      data: {'input': query},
      options: Options(
        contentType: Headers.jsonContentType,
        headers: const {
          // Optional for autocomplete, but lowers cost/latency.
          'X-Goog-FieldMask':
              'suggestions.placePrediction.placeId,'
              'suggestions.placePrediction.text.text',
        },
      ),
    );
    return parseJsonList(res.data, PlaceSuggestionDto.fromJson, 'suggestions');
  }

  /// `v1/places/{placeId}` (GET). Requires `X-Goog-FieldMask` (mandatory for
  /// Place Details in the New API) listing the fields to return.
  Future<PlaceLocationDto> placeDetails(String placeId) async {
    final res = await _dio.get<dynamic>(
      'v1/places/$placeId',
      options: Options(
        headers: const {'X-Goog-FieldMask': 'id,location,formattedAddress'},
      ),
    );
    final dto = parseSingle<PlaceLocationDto>(
      res.data,
      PlaceLocationDto.fromJson,
    );
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid place details response',
      );
    }
    return dto;
  }

  /// Returns the first `formatted_address` for the given lat/lng, or null when
  /// the API returns no results.
  Future<String?> reverseGeocode(double lat, double lng) async {
    final res = await _geocodingDio.get<dynamic>(
      'maps/api/geocode/json',
      queryParameters: {'latlng': '$lat,$lng', 'key': _apiKey},
    );
    final data = res.data;
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List && results.isNotEmpty) {
        final first = results.first;
        if (first is Map<String, dynamic>) {
          return first['formatted_address']?.toString();
        }
      }
    }
    return null;
  }
}