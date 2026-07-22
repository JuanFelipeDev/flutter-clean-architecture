/// Remote data source for assistance catalogs
/// `obtener_preguntas_cobertura`, `assistance-app/`).
library;

import 'package:dio/dio.dart';

import '../../../../core/utils/json_list_parser.dart';
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

  Future<List<ServiceDto>> fetchServices(
    String affKey,
    String planId,
    String familyId,
  ) async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/affiliate/get-affiliate-plan-services/$affKey/$planId/$familyId',
    );
    // ignore: avoid_print
    print(
      '[ASSIST] services $affKey/$planId/$familyId -> '
      '${res.statusCode} ${res.data}',
    );
    return parseServices(res.data);
  }

  Future<List<CoverageQuestionDto>> fetchCoverageQuestions(
    String serviceId,
  ) async {
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
    required String latitude,
    required String longitude,
    required List<Map<String, String>> answers,
  }) async {
    final res = await _dio.post<dynamic>(
      'soaang-assistances/api/assistances/assistance-app/',
      data: {
        'affkey': affKey,
        'ssid': serviceId,
        'idaccount': accountId,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
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