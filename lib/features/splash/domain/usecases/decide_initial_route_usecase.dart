/// Decides the initial route after splash: home if a session exists, login
/// `OpenApp` + `SplashActivity.login`).
library;

import '../../../../core/session/session_repository.dart';
import '../entities/splash_entities.dart';

class DecideInitialRouteUseCase {
  DecideInitialRouteUseCase(this._sessionRepository);
  final SessionRepository _sessionRepository;

  Future<SplashRoute> call({String? deepLinkCardId}) async {
    if (deepLinkCardId != null && deepLinkCardId.isNotEmpty) {
      return DeepLinkLoginRoute(deepLinkCardId);
    }
    final hasSession = await _sessionRepository.hasSession();
    return hasSession ? const HomeRoute() : const LoginRoute();
  }
}
