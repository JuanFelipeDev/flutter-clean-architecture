/// Settings repository contract (AFILIADO `application_settings` + logout).
library;

import '../../../../core/error/result.dart';
import '../entities/settings_entities.dart';

abstract class SettingsRepository {
  /// Fetches the per-client app configuration (AFILIADO
  /// `api-python/affiliate/application_settings/`).
  Future<Result<AppConfiguration>> appConfiguration(String affKey);

  /// Logs the affiliate out server-side + clears the session (AFILIADO
  /// `soaang-users/api/logout/`).
  Future<Result<void>> logout();
}