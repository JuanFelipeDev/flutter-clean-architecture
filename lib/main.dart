/// Default entrypoint (basenewsoa flavor, dev environment).
///
/// Build/run:
///   flutter run -t lib/main.dart --dart-define-from-file=flavors/basenewsoa/config.json
///
/// Other flavors have their own entrypoints + config files:
///   lib/main_roble.dart       flavors/roble/config.json
///   lib/main_masservicios.dart flavors/masservicios/config.json
library;

import 'bootstrap.dart';

Future<void> main() async {
  await bootstrap();
}
