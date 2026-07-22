/// Riverpod providers for the configuration layer.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flavor_config.dart';

/// Active flavor config, read from compile-time `--dart-define` values.
/// No override needed: every `main_<flavor>.dart` is launched with its own
/// `--dart-define-from-file`, so [FlavorConfig.fromEnvironment] resolves the
/// right values per build.
final flavorConfigProvider = Provider<FlavorConfig>((ref) {
  return FlavorConfig.fromEnvironment();
});

/// `setTypeEnviroment`). Seeded from the compile-time flavor env; persisted in
/// `bootstrap` from prefs so the choice survives launches.
final currentEnvironmentProvider = StateProvider<Environment>((ref) {
  return ref.watch(flavorConfigProvider).environment;
});
