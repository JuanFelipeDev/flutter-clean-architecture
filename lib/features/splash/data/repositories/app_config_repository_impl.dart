/// [AppConfigRepository] implementation backed by the remote data source.
library;

import '../../../../core/error/result.dart';
import '../../domain/entities/splash_entities.dart';
import '../../domain/repositories/app_config_repository.dart';
import '../datasources/app_config_remote_data_source.dart';
import '../mappers/version_check_mapper.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  AppConfigRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final AppConfigRemoteDataSource remoteDataSource;
  final VersionCheckMapper mapper;

  @override
  Future<Result<VersionCheck>> checkVersion({required String currentVersion}) async {
    return Result.guardAsync(() async {
      final dto = await remoteDataSource.fetchVersion();
      return mapper.toEntity(dto, currentVersion: currentVersion);
    }).then((result) {
      // A network/server failure during version check should not block the
      // app: degrade to "not outdated" so the user proceeds.
      return result.fold(
        onSuccess: (check) => Success(check),
        onFailure: (_) => Success(VersionCheck(
          currentVersion: currentVersion,
          latestVersion: currentVersion,
        )),
      );
    });
  }
}