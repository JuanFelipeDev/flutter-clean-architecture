/// Remote data source for beneficiary (AFILIADO `obtener_beneficiarios/`,
/// `crear_beneficiarios/`, `editar_beneficiario/`, `eliminar_beneficiario/`,
/// `obtener_parentescos/`).
library;

import 'package:dio/dio.dart';

import '../models/beneficiary_dtos.dart';

class BeneficiaryRemoteDataSource {
  BeneficiaryRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<BeneficiaryDto>> fetchList(String affKey) async {
    final res = await _dio.get<dynamic>(
      'obtener_beneficiarios/',
      queryParameters: {'affkey': affKey},
    );
    return parseBeneficiaries(res.data);
  }

  Future<BeneficiaryDto> fetchDetail(String affKey, String beneficiaryId) async {
    final res = await _dio.get<dynamic>(
      'obtener_detalle_beneficiario/',
      queryParameters: {'affkey': affKey, 'id': beneficiaryId},
    );
    final dto = parseBeneficiary(res.data);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid beneficiary detail response',
      );
    }
    return dto;
  }

  Future<BeneficiaryDto> create(String affKey, BeneficiaryDto dto) async {
    final res = await _dio.post<dynamic>(
      'crear_beneficiarios/',
      data: <String, dynamic>{'affkey': affKey, ...dto.toJson()},
      options: Options(contentType: Headers.jsonContentType),
    );
    return parseBeneficiary(res.data) ?? dto;
  }

  Future<BeneficiaryDto> update(BeneficiaryDto dto) async {
    final res = await _dio.post<dynamic>(
      'editar_beneficiario/',
      data: dto.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return parseBeneficiary(res.data) ?? dto;
  }

  Future<void> delete(String beneficiaryId) async {
    await _dio.post<dynamic>(
      'eliminar_beneficiario/',
      data: {'id': beneficiaryId},
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<List<RelationshipDto>> fetchRelationships() async {
    final res = await _dio.get<dynamic>('obtener_parentescos/');
    return parseRelationships(res.data);
  }
}