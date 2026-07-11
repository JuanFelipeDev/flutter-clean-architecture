/// Theme mode provider. Persisted via [PrefsService] (AFILIADO has no dark
/// mode; this is a Flutter improvement).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage_providers.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final prefsAsync = ref.watch(prefsServiceProvider);
  return prefsAsync.maybeWhen(
    data: (prefs) {
      switch (prefs.themeMode) {
        case 'dark':
          return ThemeMode.dark;
        case 'light':
          return ThemeMode.light;
        default:
          return ThemeMode.system;
      }
    },
    orElse: () => ThemeMode.system,
  );
});