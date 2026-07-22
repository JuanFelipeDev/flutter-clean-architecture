/// Convenience accessor for generated [AppLocalizations].
library;

import 'package:flutter/material.dart';

import 'generated/app_localizations.dart';

extension L10nContext on BuildContext {
  /// Typed access to the active translations.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
