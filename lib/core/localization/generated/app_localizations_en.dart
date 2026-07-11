// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Affiliate';

  @override
  String get loading => 'Loading…';

  @override
  String get retry => 'Retry';

  @override
  String get errorGeneric => 'An unexpected error occurred';

  @override
  String get errorNoConnection => 'No internet connection';

  @override
  String get errorSessionExpired => 'Your session has expired';

  @override
  String get splashStarting => 'Starting…';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get homeTitle => 'Home';

  @override
  String get tabAssistance => 'Assistance';

  @override
  String get tabNotifications => 'Notifications';

  @override
  String get tabTracking => 'Tracking';

  @override
  String get tabHome => 'Home';
}
