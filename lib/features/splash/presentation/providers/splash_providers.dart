/// Riverpod wiring for the splash feature: repository, use cases, and the
/// [SplashNotifier] that orchestrates the splash checks.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/security/security_providers.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/app_config_remote_data_source.dart';
import '../../data/mappers/version_check_mapper.dart';
import '../../data/repositories/app_config_repository_impl.dart';
import '../../domain/repositories/app_config_repository.dart';
import '../../domain/usecases/check_root_usecase.dart';
import '../../domain/usecases/check_version_usecase.dart';
import '../../domain/usecases/decide_initial_route_usecase.dart';
import '../states/splash_state.dart';

final appConfigRemoteDataSourceProvider = Provider<AppConfigRemoteDataSource>((
  ref,
) {
  return AppConfigRemoteDataSource(ref.watch(dioProvider));
});

final appConfigRepositoryProvider = Provider<AppConfigRepository>((ref) {
  return AppConfigRepositoryImpl(
    remoteDataSource: ref.watch(appConfigRemoteDataSourceProvider),
    mapper: const VersionCheckMapper(),
  );
});

final checkRootUseCaseProvider = Provider<CheckRootUseCase>((ref) {
  return CheckRootUseCase(ref.watch(rootDetectionProvider));
});

final checkVersionUseCaseProvider = Provider<CheckVersionUseCase>((ref) {
  return CheckVersionUseCase(ref.watch(appConfigRepositoryProvider));
});

final decideInitialRouteUseCaseProvider = Provider<DecideInitialRouteUseCase>((
  ref,
) {
  return DecideInitialRouteUseCase(ref.watch(sessionRepositoryProvider));
});

class SplashNotifier extends Notifier<SplashState> {
  @override
  SplashState build() => const SplashInitial();

  Future<void> start({String? deepLinkCardId}) async {
    state = const SplashLoading();

    if (!kDebugMode) {
      final rooted = await ref.read(checkRootUseCaseProvider).call();
      if (rooted.getOrNull() == true) {
        state = const SplashRooted();
        return;
      }
    }

    final versionResult = await ref
        .read(checkVersionUseCaseProvider)
        .call(currentVersion: '1.0.0');
    final version = versionResult.getOrNull();
    if (version != null && version.isOutdated) {
      state = SplashUpdateRequired(version.latestVersion);
      return;
    }

    final route = await ref
        .read(decideInitialRouteUseCaseProvider)
        .call(deepLinkCardId: deepLinkCardId);
    state = SplashReady(route);
  }
}

final splashProvider = NotifierProvider<SplashNotifier, SplashState>(
  SplashNotifier.new,
);
