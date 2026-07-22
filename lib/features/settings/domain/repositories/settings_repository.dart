library;

import '../../../../core/error/result.dart';
import '../entities/settings_entities.dart';

abstract class SettingsRepository {
  /// `api-python/affiliate/application_settings/`).
  Future<Result<AppConfiguration>> appConfiguration(String affKey);

  /// `soaang-users/api/logout/`).
  Future<Result<void>> logout();
}
