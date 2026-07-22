/// `soaang-users/api/token/refresh/`). Uses a dedicated Dio (no refresh
/// interceptor) to avoid recursion.
library;

import 'package:dio/dio.dart';

class AuthApiService {
  AuthApiService(this._dio);

  final Dio _dio;

  /// Refreshes the access token. Returns the new access token (and refresh if
  /// rotated). Throws [DioException] on failure; the caller maps to [Failure].
  Future<({String access, String? refresh})> refresh(
    String refreshToken,
  ) async {
    final response = await _dio.post<dynamic>(
      'soaang-users/api/token/refresh/',
      data: {'refresh': refreshToken},
    );

    final data = response.data;
    if (data is Map) {
      final access = data['access'] as String?;
      if (access != null && access.isNotEmpty) {
        return (access: access, refresh: data['refresh'] as String?);
      }
    }
    throw DioException(
      requestOptions: RequestOptions(path: 'soaang-users/api/token/refresh/'),
      message: 'Refresh response missing access token',
    );
  }
}
