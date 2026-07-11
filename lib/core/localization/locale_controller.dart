/// Locale management. AFILIADO supports `es, en, fr, pt, pt-BR, ar` (with RTL
/// for Arabic). This controller holds the active locale, maps it to an
/// `Accept-Language` tag, and persists the choice (AFILIADO `LANGUAGE` pref).
library;

import 'dart:ui';

import 'package:flutter/material.dart';

/// Supported locales (AFILIADO `getNameOfLanguage`).
const List<Locale> supportedLocales = <Locale>[
  Locale('es'),
  Locale('en'),
  Locale('fr'),
  Locale('pt'),
  Locale('pt', 'BR'),
  Locale('ar'),
];

/// Default locale when none is persisted.
const Locale defaultLocale = Locale('es');

/// True for RTL locales (Arabic).
bool isRtl(Locale locale) => locale.languageCode == 'ar';

/// Maps a locale to the `Accept-Language` header value (AFILIADO `getLanguage`).
String languageTag(Locale locale) {
  if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
    return '${locale.languageCode}-${locale.countryCode}';
  }
  return locale.languageCode;
}

/// Parses a stored tag ("es", "pt-BR") back into a [Locale], falling back to
/// [defaultLocale].
Locale parseLocale(String? tag) {
  if (tag == null || tag.isEmpty) return defaultLocale;
  final parts = tag.split('-');
  if (parts.length == 1) {
    return Locale(parts[0]);
  }
  return Locale(parts[0], parts[1]);
}