/// Settings use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/settings_entities.dart';
import '../repositories/settings_repository.dart';

class GetAppConfigurationUseCase {
  GetAppConfigurationUseCase(this._repository);
  final SettingsRepository _repository;
  Future<Result<AppConfiguration>> call(String affKey) =>
      _repository.appConfiguration(affKey);
}

class LogoutUseCase {
  LogoutUseCase(this._repository);
  final SettingsRepository _repository;
  Future<Result<void>> call() => _repository.logout();
}
