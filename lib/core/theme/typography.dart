/// Typography. Built on Material 3 `TextTheme` with a single base family;
/// Phase 8 can swap in custom fonts per flavor.
library;

import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme get textTheme {
    return Typography.material2021().black.merge(
      const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.w700),
        displayMedium: TextStyle(fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.4),
      ),
    );
  }
}
