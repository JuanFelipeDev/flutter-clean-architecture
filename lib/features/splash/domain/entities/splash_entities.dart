/// Splash feature entities. Pure Dart — no Flutter/Dio deps.
library;

/// Result of a version check (AFILIADO `ResponseValidateUpdate` /
/// `info-version-app`).
class VersionCheck {
  const VersionCheck({
    required this.currentVersion,
    required this.latestVersion,
    this.updateRequired = false,
  });

  final String currentVersion;
  final String latestVersion;
  final bool updateRequired;

  /// True when the published version is newer than the running one, or the
  /// backend explicitly forces an update.
  bool get isOutdated => updateRequired || _isNewer(latestVersion, currentVersion);

  /// Compares dotted version strings (e.g. "1.2.3" > "1.2.0").
  static bool _isNewer(String a, String b) {
    final pa = a.split('.').map(int.tryParse).toList();
    final pb = b.split('.').map(int.tryParse).toList();
    for (var i = 0; i < 3; i++) {
      final av = i < pa.length ? (pa[i] ?? 0) : 0;
      final bv = i < pb.length ? (pb[i] ?? 0) : 0;
      if (av > bv) return true;
      if (av < bv) return false;
    }
    return false;
  }
}

/// Where the splash should route to (AFILIADO `OpenApp` decision +
/// deep-link login from another app).
sealed class SplashRoute {
  const SplashRoute();
}

class LoginRoute extends SplashRoute {
  const LoginRoute();
}

class HomeRoute extends SplashRoute {
  const HomeRoute();
}

/// Deep-link login carrying the affiliate card id (AFILIADO
/// `login(cardId)` from `scheme_app_login`).
class DeepLinkLoginRoute extends SplashRoute {
  const DeepLinkLoginRoute(this.cardId);
  final String cardId;
}