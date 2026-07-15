/// Builds a configured [Dio] instance with a given interceptor chain. Pure
/// construction — no DI. The [dioProvider] wires real interceptors.
library;

import 'package:dio/dio.dart';

import '../config/app_constants.dart';
import '../config/flavor_config.dart';

/// Creates a [Dio] configured with base URL ([flavor.urlServerFor] of [env]),
/// timeouts, and the provided interceptors (order-sensitive, matching
/// PRESTADOR's `NetworkModule`).
Dio createDio(FlavorConfig flavor, Environment env, List<Interceptor> interceptors) {
  final dio = Dio(
    BaseOptions(
      baseUrl: flavor.urlServerFor(env),
      connectTimeout: NetworkLimits.defaultTimeout,
      sendTimeout: NetworkLimits.defaultTimeout,
      receiveTimeout: NetworkLimits.defaultTimeout,
      responseType: ResponseType.json,
      validateStatus: (_) => true, // errors handled by interceptors + mapper
      headers: const <String, dynamic>{
        'Accept': 'application/json',
      },
    ),
  );

  // Order mirrors PRESTADOR's NetworkModule interceptor chain.
  for (final interceptor in interceptors) {
    dio.interceptors.add(interceptor);
  }
  return dio;
}