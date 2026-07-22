/// version check). Implemented by the data layer.
library;

import '../../../../core/error/result.dart';
import '../entities/splash_entities.dart';

abstract class AppConfigRepository {
  /// Fetches the published app version info.
  Future<Result<VersionCheck>> checkVersion({required String currentVersion});
}
