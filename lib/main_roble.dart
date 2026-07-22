/// Roble flavor entrypoint (NIT+placa+DPI login).
///
///   flutter run -t lib/main_roble.dart --dart-define-from-file=flavors/roble/config.json
library;

import 'bootstrap.dart';

Future<void> main() async {
  await bootstrap();
}
