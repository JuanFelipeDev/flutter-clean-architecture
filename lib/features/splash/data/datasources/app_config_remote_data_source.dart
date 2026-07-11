/// Remote data source for app config / version check (AFILIADO
/// `info-version-app`).
library;

import 'package:dio/dio.dart';

import '../models/version_check_dto.dart';

class AppConfigRemoteDataSource {
  AppConfigRemoteDataSource(this._dio);
  final Dio _dio;

  static const String _path = 'soaang-configurations-external/api/domain_user/info-version-app';

  Future<VersionCheckDto> fetchVersion() async {
    final response = await _dio.get<dynamic>(_path);
    final dto = VersionCheckDto.tryParse(response.data);
    if (dto == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Invalid version response',
      );
    }
    return dto;
  }
}