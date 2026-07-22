/// Maps [VersionCheckDto] → [VersionCheck] entity.
library;

import '../../domain/entities/splash_entities.dart';
import '../models/version_check_dto.dart';

class VersionCheckMapper {
  const VersionCheckMapper();

  VersionCheck toEntity(VersionCheckDto dto, {required String currentVersion}) {
    return VersionCheck(
      currentVersion: currentVersion,
      latestVersion: dto.vaVersion ?? currentVersion,
      updateRequired: dto.vaState?.toLowerCase() == 'force_update',
    );
  }
}
