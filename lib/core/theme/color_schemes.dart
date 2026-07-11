/// Color schemes derived per flavor from the configured primary/accent colors
/// (AFILIADO `PRIMARY_COLOR`/`ACCENT_COLOR` from `configuraciones_app_afiliado/`).
/// Produces both light and dark Material 3 schemes — dark mode is a Flutter
/// improvement (both source apps are light-only).
library;

import 'package:flutter/material.dart';

import '../config/flavor_config.dart';

class AppColorSchemes {
  const AppColorSchemes._();

  static ColorScheme light(FlavorConfig flavor) {
    final seed = Color(flavor.primaryColor);
    return ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light)
        .copyWith(secondary: Color(flavor.accentColor));
  }

  static ColorScheme dark(FlavorConfig flavor) {
    final seed = Color(flavor.primaryColor);
    return ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark)
        .copyWith(secondary: Color(flavor.accentColor));
  }
}