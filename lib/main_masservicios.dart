/// Masservicios flavor entrypoint (MX, certificate-pinned to masservicios.com.mx).
///
///   flutter run -t lib/main_masservicios.dart \
///     --dart-define-from-file=flavors/masservicios/config.json
library;

import 'bootstrap.dart';

Future<void> main() async {
  await bootstrap();
}