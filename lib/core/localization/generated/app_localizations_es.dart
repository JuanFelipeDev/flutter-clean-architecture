// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Afiliado';

  @override
  String get loading => 'Cargando…';

  @override
  String get retry => 'Reintentar';

  @override
  String get errorGeneric => 'Ocurrió un error inesperado';

  @override
  String get errorNoConnection => 'Sin conexión a internet';

  @override
  String get errorSessionExpired => 'Tu sesión ha expirado';

  @override
  String get splashStarting => 'Iniciando…';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginUsername => 'Usuario';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginSubmit => 'Ingresar';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get tabAssistance => 'Asistencias';

  @override
  String get tabNotifications => 'Notificaciones';

  @override
  String get tabTracking => 'Seguimiento';

  @override
  String get tabHome => 'Inicio';
}
