/// Remote data sources for assistance catalogs + Google Places
/// (AFILIADO `soaang-catalogs/api/affiliate/get-affiliate-*`,
/// `obtener_preguntas_cobertura`, `assistance-app/`, Google `v1/places*`).
library;

import 'package:dio/dio.dart';

import '../models/assistance_dtos.dart';

class AssistanceRemoteDataSource {
  AssistanceRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<AccountDto>> fetchAccounts(String affKey) async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/affiliate/get-affiliate-accounts/$affKey/',
    );
    return parseAccounts(res.data);
  }

  Future<List<PlanDto>> fetchPlans(String affKey, String accountId) async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/affiliate/get-affiliate-plans/$affKey/$accountId/',
    );
    return parsePlans(res.data);
  }

  Future<List<FamilyDto>> fetchFamilies(String affKey, String planId) async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/affiliate/get-affiliate-family-services/$affKey/$planId/',
    );
    return parseFamilies(res.data);
  }

  Future<List<ServiceDto>> fetchServices(String affKey, String planId, String familyId) async {
    // AFILIADO `Webservice.getAffiliateServices` has NO trailing slash on this
    // route (unlike family-services). Keep it slash-less to avoid a backend
    // redirect/404 that strips auth headers.
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/affiliate/get-affiliate-plan-services/$affKey/$planId/$familyId',
    );
    // ignore: avoid_print
    print('[ASSIST] services $affKey/$planId/$familyId -> '
        '${res.statusCode} ${res.data}');
    return parseServices(res.data);
  }

  Future<List<CoverageQuestionDto>> fetchCoverageQuestions(String serviceId) async {
    final res = await _dio.get<dynamic>(
      'api-python/obtener_preguntas_cobertura/',
      queryParameters: {'service_id': serviceId},
    );
    return parseQuestions(res.data);
  }

  Future<AssistanceDto> createAssistance({
    required String affKey,
    required String serviceId,
    required String accountId,
    required String address,
    required List<Map<String, String>> answers,
  }) async {
    final res = await _dio.post<dynamic>(
      'soaang-assistances/api/assistances/assistance-app/',
      data: {
        'affkey': affKey,
        'ssid': serviceId,
        'idaccount': accountId,
        'address': address,
        'answers': answers,
      },
      options: Options(contentType: Headers.jsonContentType),
    );
    final dto = parseSingle<AssistanceDto>(res.data, AssistanceDto.fromJson);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid create-assistance response',
      );
    }
    return dto;
  }
}

class PlacesRemoteDataSource {
  PlacesRemoteDataSource(this._dio);
  final Dio _dio;

  /// `v1/places:autocomplete` (POST body with input).
  Future<List<PlaceSuggestionDto>> autocomplete(String query) async {
    final res = await _dio.post<dynamic>(
      'v1/places:autocomplete',
      data: {'input': query},
      options: Options(contentType: Headers.jsonContentType),
    );
    return parseSuggestions(res.data);
  }

  /// `v1/places/{placeId}` (GET).
  Future<PlaceLocationDto> placeDetails(String placeId) async {
    final res = await _dio.get<dynamic>('v1/places/$placeId');
    final dto = parseSingle<PlaceLocationDto>(res.data, PlaceLocationDto.fromJson);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid place details response',
      );
    }
    return dto;
  }
}