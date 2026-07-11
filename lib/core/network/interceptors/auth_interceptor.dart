/// Adds `Authorization`, `client-id` and `username` headers to every request,
/// skipping auth endpoints. Mirrors PRESTADOR's inline `authorizationInterceptor`
/// + AFILIADO's `ConfigUtils.TOKEN_BEARER`.
library;

import 'dart:async';

import 'package:dio/dio.dart';

import '../../config/app_constants.dart';

/// Resolves the credentials to attach. Implemented by the session layer and
/// injected into the interceptor (dependency inversion).
abstract class CredentialAccessor {
  Future<String?> accessToken();
  String? clientId();
  String? username();
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._credentials, {this.skipPaths = const <String>[]});

  final CredentialAccessor _credentials;

  /// URL fragments that must NOT receive an auth header (login, refresh).
  final List<String> skipPaths;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    if (_shouldSkip(path)) {
      handler.next(options);
      return;
    }

    options.headers
      ..remove(HttpHeaders.authorization)
      ..remove(HttpHeaders.clientId)
      ..remove(HttpHeaders.username);

    final clientId = _credentials.clientId();
    final username = _credentials.username();
    if (clientId != null) options.headers[HttpHeaders.clientId] = clientId;
    if (username != null) options.headers[HttpHeaders.username] = username;

    unawaited(
      _credentials.accessToken().then((token) {
        if (token != null && token.isNotEmpty) {
          options.headers[HttpHeaders.authorization] = 'Bearer $token';
        }
        handler.next(options);
      }).catchError((Object _) {
        handler.next(options);
        return null;
      }),
    );
  }

  bool _shouldSkip(String path) =>
      skipPaths.any((skip) => path.contains(skip));
}