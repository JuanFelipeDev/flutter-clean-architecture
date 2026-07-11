/// Rewrites the request base URL at runtime so the environment picker can
/// switch the server (AFILIADO `setTypeEnviroment`, PRESTADOR inline
/// `hostSelectionInterceptor`). Skips third-party absolute hosts (Google).
library;

import 'package:dio/dio.dart';

/// Returns the current base URL the app should talk to.
abstract class BaseUrlAccessor {
  String currentBaseUrl();
}

class HostSelectionInterceptor extends Interceptor {
  HostSelectionInterceptor(this._baseUrl, {this.skipHosts = const <String>[]});

  final BaseUrlAccessor _baseUrl;

  /// Hosts that must not be rewritten (third-party APIs).
  final List<String> skipHosts;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;
    if (skipHosts.any((h) => uri.host.contains(h))) {
      handler.next(options);
      return;
    }

    final base = _baseUrl.currentBaseUrl();
    if (base.isNotEmpty && options.baseUrl != base) {
      options.baseUrl = base;
    }
    handler.next(options);
  }
}