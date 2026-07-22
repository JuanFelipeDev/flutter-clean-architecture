/// Riverpod wiring for the Places feature (Google Places + Geocoding).
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/session_providers.dart';
import '../../data/datasources/places_remote_data_source.dart';
import '../../data/models/places_dtos.dart';
import '../../data/repositories/places_repository_impl.dart';
import '../../domain/repositories/places_repository.dart';
import '../../domain/usecases/places_usecases.dart';

/// API key for the **REST** Places/Geocoding calls. The Maps SDK key
/// (`MAPS_API_KEY`) is often Android-app-restricted, which makes REST calls
/// from Dio fail with 403. Set `PLACES_API_KEY` (an unrestricted or
/// HTTP-restricted key) via `--dart-define` to override; otherwise falls back
/// to the runtime Maps key.
final placesRestApiKeyProvider = Provider<String>((ref) {
  const override = String.fromEnvironment('PLACES_API_KEY');
  if (override.isNotEmpty) return override;
  return ref.watch(mapsApiKeyProvider);
});

/// A separate Dio for Google Places (different base host + timeout). Uses the
/// per-client `cltInfoApiKey` resolved at login, falling back to the flavor
/// compile-time key.
final placesDioProvider = Provider<Dio>((ref) {
  final apiKey = ref.watch(placesRestApiKeyProvider);
  return Dio(
    BaseOptions(
      baseUrl: 'https://places.googleapis.com/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'X-Goog-Api-Key': apiKey},
    ),
  );
});

/// Dio for the Google Geocoding API (reverse-lookup). Different host from
/// Places and authenticates via the `key` query param, not a header.
final geocodingDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://maps.googleapis.com/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
});

final placesRemoteDataSourceProvider = Provider<PlacesRemoteDataSource>((ref) {
  return PlacesRemoteDataSource(
    ref.watch(placesDioProvider),
    ref.watch(geocodingDioProvider),
    ref.watch(placesRestApiKeyProvider),
  );
});

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  return PlacesRepositoryImpl(
    remoteDataSource: ref.watch(placesRemoteDataSourceProvider),
    mapper: const PlacesMapper(),
  );
});

final autocompletePlacesUseCaseProvider = Provider<AutocompletePlacesUseCase>((
  ref,
) {
  return AutocompletePlacesUseCase(ref.watch(placesRepositoryProvider));
});

final placeDetailsUseCaseProvider = Provider<PlaceDetailsUseCase>((ref) {
  return PlaceDetailsUseCase(ref.watch(placesRepositoryProvider));
});

final reverseGeocodeUseCaseProvider = Provider<ReverseGeocodeUseCase>((ref) {
  return ReverseGeocodeUseCase(ref.watch(placesRepositoryProvider));
});