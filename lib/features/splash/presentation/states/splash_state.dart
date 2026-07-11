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

/// Device is rooted/jailbroken (release gating, AFILIADO `security_root`).
class SplashRooted extends SplashState {
  const SplashRooted();
}

/// A newer version is published — force update (AFILIADO publisher channel
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