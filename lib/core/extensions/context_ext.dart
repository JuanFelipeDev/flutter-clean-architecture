/// Build-context conveniences.
library;

import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
  MediaQueryData get media => MediaQuery.of(this);
  double get screenWidth => media.size.width;
  double get screenHeight => media.size.height;

  /// Pops the top route if possible.
  void maybePop<T extends Object?>([T? result]) => Navigator.maybeOf(this)?.pop(result);
}