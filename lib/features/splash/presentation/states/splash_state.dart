/// Splash UI state. Sealed so the page renders each phase explicitly.
library;

import '../../domain/entities/splash_entities.dart';

sealed class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashRooted extends SplashState {
  const SplashRooted();
}

/// / `info-version-app`).
class SplashUpdateRequired extends SplashState {
  const SplashUpdateRequired(this.latestVersion);
  final String latestVersion;
}

/// Checks complete; navigate to [route].
class SplashReady extends SplashState {
  const SplashReady(this.route);
  final SplashRoute route;
}
