/// Handles HTTP 401 by refreshing the access token (with a mutex to avoid
/// concurrent refreshes) and retrying the original request once. Skips auth
library;

import 'dart:async';

import 'package:dio/dio.dart';

/// Performs the refresh and returns the new access token (persisted by the
/// session layer). Implemented by the session layer.
abstract class TokenRefresher {
  Future<String> refresh();
}

/// Endpoints that must not trigger a refresh attempt.
const List<String> _refreshSkipPaths = <String>[
  'api/token/',
  'api/token/refresh/',
  'api/twoFactorAuth/verify/',
  'password-reset',
];

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(this._refresher);

  final TokenRefresher _refresher;

  Future<String>? _pendingRefresh;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;
    final isAuthEndpoint = _refreshSkipPaths.any(path.contains);

    if (status != 401 || isAuthEndpoint) {
      handler.next(err);
      return;
    }

    unawaited(
      _refresh()
          .then((token) => _retry(err, token))
          .then((response) => handler.resolve(response))
          .catchError((Object error) {
            handler.next(err);
          }),
    );
  }

  Future<String> _refresh() {
    return _pendingRefresh ??= _refresher.refresh().whenComplete(() {
      _pendingRefresh = null;
    });
  }

  Future<Response<dynamic>> _retry(DioException err, String token) async {
    final retryDio = Dio(BaseOptions());
    err.requestOptions.headers['Authorization'] = 'Bearer $token';
    final response = await retryDio.fetch<dynamic>(err.requestOptions);
    return response;
  }
}
