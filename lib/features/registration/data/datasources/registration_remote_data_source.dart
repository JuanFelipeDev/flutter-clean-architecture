/// `sign_up/`, `registro_mejorado/`).
library;

import 'package:dio/dio.dart';

import '../models/registration_dtos.dart';

class RegistrationRemoteDataSource {
  RegistrationRemoteDataSource(this._dio);
  final Dio _dio;

  /// Modern AFILIADO affiliate registration route
  /// (`createAccountAffiliateWithoutAccountId`):
  /// `soaang-catalogs-external/api/validate-affiliate/{affkey}/`.
  static const String _signUpPath =
      'soaang-catalogs-external/api/validate-affiliate';

  Future<RegisterDto> register({
    required String affkey,
    required Map<String, String> fields,
    required String clientId,
  }) async {
    final body = <String, dynamic>{
      ...fields,
      // AFILIADO sends `client_id` as int; coerce when the flavor config is
      // numeric, otherwise forward the raw value.
      'client_id': int.tryParse(clientId) ?? clientId,
    };
    final response = await _dio.post<dynamic>(
      '$_signUpPath/${Uri.encodeComponent(affkey)}/',
      data: body,
      options: Options(contentType: Headers.jsonContentType),
    );
    final dto = RegisterDto.tryParse(response.data);
    if (dto == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Invalid registration response',
      );
    }
    return dto;
  }
}