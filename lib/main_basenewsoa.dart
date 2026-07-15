/// Basenewsoa flavor entrypoint (standard login, Colombia).
///
///   flutter run -t lib/main_basenewsoa.dart --dart-define-from-file=flavors/basenewsoa/config.json
library;

import 'bootstrap.dart';

Future<void> main() async {
  await bootstrap();
}