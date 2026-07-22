/// [PlacesRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/places_entities.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/places_remote_data_source.dart';
import '../models/places_dtos.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  PlacesRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final PlacesRemoteDataSource remoteDataSource;
  final PlacesMapper mapper;

  @override
  Future<Result<List<PlaceSuggestion>>> autocomplete(String query) async {
    try {
      final dtos = await remoteDataSource.autocomplete(query);
      return Success(dtos.map(mapper.toSuggestion).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<PlaceLocation>> placeDetails(String placeId) async {
    try {
      final dto = await remoteDataSource.placeDetails(placeId);
      return Success(mapper.toPlace(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<String>> reverseGeocode(double lat, double lng) async {
    try {
      final address = await remoteDataSource.reverseGeocode(lat, lng);
      if (address == null || address.isEmpty) {
        return Err(Failure.unknown('No address found for location'));
      }
      return Success(address);
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}