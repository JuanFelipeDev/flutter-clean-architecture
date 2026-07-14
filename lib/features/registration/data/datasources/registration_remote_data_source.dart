/// Remote data source for registration (AFILIADO `document_validate/`,
/// `sign_up/`, `registro_mejorado/`).
library;

import 'package:dio/dio.dart';

import '../../domain/entities/registration_entities.dart';
import '../models/registration_dtos.dart';

class RegistrationRemoteDataSource {
  RegistrationRemoteDataSource(this._dio);
  final Dio _dio;

  static const String _documentValidatePath = 'api-python/affiliate/document_validate/';
  static const String _signUpPath = 'api-python/affiliate/sign_up/';

  Future<ValidateDocumentDto> validateDocument({
    required String document,
    required AccountType accountType,
  }) async {
    final response = await _dio.post<dynamic>(
      _documentValidatePath,
      data: {
        'document': document,
        'account_type': accountType.name,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    final dto = ValidateDocumentDto.tryParse(response.data);
    if (dto == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Invalid document validation response',
      );
    }
    return dto;
  }

  Future<RegisterDto> register({
    required AccountType accountType,
    required Map<String, String> fields,
  }) async {
    final body = <String, dynamic>{
      'account_type': accountType.name,
      ...fields,
    };
    final response = await _dio.post<dynamic>(
      _signUpPath,
      data: body,
      options: Options(contentType: Headers.formUrlEncodedContentType),
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