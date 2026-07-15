/// Remote data source for authentication (AFILIADO `Webservice.java` token +
/// twoFactorAuth endpoints).
library;

import 'package:dio/dio.dart';

import '../../domain/entities/login_entities.dart';
import '../models/login_session_dto.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);
  final Dio _dio;

  static const String _tokenPath = 'soaang-users/api/token/';
  static const String _twoFactorPath = 'soaang-users/api/twoFactorAuth/verify/';

  Future<LoginSessionDto> login(
    LoginCredentials credentials, {
    String? deviceToken,
  }) async {
    final form = _buildForm(credentials, deviceToken: deviceToken);
    final response = await _dio.post<dynamic>(
      _tokenPath,
      data: form,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    // Debug: log the raw response so we can see what the backend returned.
    // ignore: avoid_print
    print('[LOGIN] status=${response.statusCode} data=${response.data}');
    return _parse(response.data, _tokenPath);
  }

  Future<LoginSessionDto> verifyTwoFactor(String userName, String code) async {
    final response = await _dio.post<dynamic>(
      _twoFactorPath,
      data: {'userName': userName, 'code': code},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return _parse(response.data, _twoFactorPath);
  }

  Map<String, dynamic> _buildForm(LoginCredentials credentials, {String? deviceToken}) {
    final base = <String, dynamic>{
      'DialDevice': 'android',
      'DeviceToken': deviceToken ?? '',
      'platform': 'app_affiliate',
      'versionApp': '1.0.0',
      'nameApp': 'app_affiliate',
      'addressMac': '',
    };

    switch (credentials) {
      case StandardCredentials(:final username, :final password):
        return base..addAll({'username': username, 'password': password});
      case EoCredentials(:final phone, :final name, :final password):
        return base..addAll({'username': phone, 'name': name, 'password': password});
      case RobleCredentials(:final nit, :final placa, :final dpi):
        return base
          ..addAll({
            if (nit != null && nit.isNotEmpty) 'nit': nit,
            if (placa != null && placa.isNotEmpty) 'placa': placa,
            if (dpi != null && dpi.isNotEmpty) 'dpi': dpi,
          });
    }
  }

  LoginSessionDto _parse(dynamic body, String path) {
    final dto = LoginSessionDto.tryParse(body);
    if (dto == null) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        message: 'Invalid login response',
      );
    }
    return dto;
  }
}