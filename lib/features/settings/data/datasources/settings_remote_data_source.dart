/// `soaang-users/api/logout/`).
library;

import 'package:dio/dio.dart';

import '../models/settings_dtos.dart';

class SettingsRemoteDataSource {
  SettingsRemoteDataSource(this._dio);
  final Dio _dio;

  Future<AppConfigurationDto> fetchConfiguration(String affKey) async {
    final res = await _dio.get<dynamic>(
      'api-python/affiliate/application_settings/',
      queryParameters: {'affkey': affKey},
    );
    final dto = AppConfigurationDto.tryParse(res.data);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid app configuration response',
      );
    }
    return dto;
  }

  Future<void> logout() async {
    await _dio.post<dynamic>('soaang-users/api/logout/', options: Options());
  }
}
