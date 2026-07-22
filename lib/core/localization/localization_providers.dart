/// Riverpod providers for localization. The active locale is held as a
/// [StateProvider] so the Dio `LanguageInterceptor` and the `MaterialApp`
/// locale both react to changes.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage_providers.dart';
import 'locale_controller.dart';

/// Active locale. Seeded from persisted prefs (async) or [defaultLocale].
final localeProvider = StateProvider<Locale>((ref) {
  final prefsAsync = ref.watch(prefsServiceProvider);
  return prefsAsync.maybeWhen(
    data: (prefs) => parseLocale(prefs.locale),
    orElse: () => defaultLocale,
  );
});

/// Convenience: the `Accept-Language` tag for the active locale.
final languageTagProvider = Provider<String>((ref) {
  return languageTag(ref.watch(localeProvider));
});
