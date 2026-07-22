/// `edit-profile/{affkey}/`, `edit-password/{affkey}/`, document types,
/// companies).
library;

import 'package:dio/dio.dart';

import '../models/profile_dtos.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._dio);
  final Dio _dio;

  Future<AffiliateProfileDto> fetchProfile(String affKey) async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/users/get-profile/',
      queryParameters: {'affkey': affKey},
    );
    final dto = parseProfile(res.data);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid profile response',
      );
    }
    return dto;
  }

  Future<AffiliateProfileDto> updateProfile(AffiliateProfileDto dto) async {
    final res = await _dio.patch<dynamic>(
      'soaang-catalogs/api/users/edit-profile/${dto.affKey}/',
      data: dto.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    final updated = parseProfile(res.data);
    return updated ?? dto;
  }

  Future<void> changePassword(String affKey, Map<String, String> body) async {
    await _dio.put<dynamic>(
      'soaang-catalogs/api/users/edit-password/$affKey/',
      data: body,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<List<DocumentTypeDto>> fetchDocumentTypes() async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/parameters/types/5/',
    );
    return parseDocumentTypes(res.data);
  }

  Future<List<CompanyDto>> fetchCompanies() async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/companies/list-company-soa',
    );
    return parseCompanies(res.data);
  }
}
