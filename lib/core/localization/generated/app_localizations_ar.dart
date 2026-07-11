// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'المنتسب';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorGeneric => 'حدث خطأ غير متوقع';

  @override
  String get errorNoConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorSessionExpired => 'انتهت جلستك';

  @override
  String get splashStarting => 'جارٍ البدء…';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginUsername => 'المستخدم';

  @override
  String get loginPassword => 'كلمة المرور';

  @override
  String get loginSubmit => 'دخول';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get tabAssistance => 'المساعدات';

  @override
  String get tabNotifications => 'الإشعارات';

  @override
  String get tabTracking => 'التتبع';

  @override
  String get tabHome => 'الرئيسية';
}
