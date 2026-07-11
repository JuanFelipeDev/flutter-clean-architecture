/// Adds the `Accept-Language` header from the active locale (AFILIADO
/// `Accept-Language` es/en/fr/pt/pt-BR/ar), skipping endpoints that must not
/// receive it (PRESTADOR `Constants.URL_WITHOUT_HEADERS_ACCEPT_LANGUAGE`).
library;

import 'package:dio/dio.dart';

import '../../config/app_constants.dart';

abstract class LocaleAccessor {
  String currentLanguageTag();
}

class LanguageInterceptor extends Interceptor {
  LanguageInterceptor(this._locale, {this.skipPaths = const <String>[]});

  final LocaleAccessor _locale;
  final List<String> skipPaths;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!skipPaths.any(options.path.contains)) {
      options.headers[HttpHeaders.acceptLanguage] = _locale.currentLanguageTag();
    }
    handler.next(options);
  }
}