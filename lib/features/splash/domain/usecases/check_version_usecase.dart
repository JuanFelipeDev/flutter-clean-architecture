/// Checks the published app version against the running one (AFILIADO
/// `info-version-app`).
library;

import '../../../../core/error/result.dart';
import '../entities/splash_entities.dart';
import '../repositories/app_config_repository.dart';

class CheckVersionUseCase {
  CheckVersionUseCase(this._repository);
  final AppConfigRepository _repository;

  Future<Result<VersionCheck>> call({required String currentVersion}) async {
    return _repository.checkVersion(currentVersion: currentVersion);
  }
}