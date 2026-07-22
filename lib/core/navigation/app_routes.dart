/// objects — paths are constants referenced by both [AppRouter] and deep-link
/// handling, never magic strings scattered in widgets.
library;

/// Every navigable destination in the app. New features add an entry here
/// (Phase 5 wires the builders).
enum AppRoute {
  splash('/splash'),
  login('/login'),
  twoFactor('/login/two-factor'),
  biometric('/login/biometric'),
  register('/register'),
  home('/home'),
  assistance('/assistance'),
  assistanceDetail('/assistance/detail'),
  tracking('/tracking'),
  trackingMap('/tracking/map'),
  chat('/chat'),
  videoCall('/videocall'),
  payment('/payment'),
  profile('/profile'),
  beneficiary('/beneficiary'),
  vehicle('/vehicle'),
  notifications('/notifications'),
  history('/history'),
  scheduling('/scheduling'),
  survey('/survey'),
  events('/events'),
  settings('/settings');

  const AppRoute(this.path);
  final String path;

  /// Whether the route requires an authenticated session.
  bool get isProtected {
    switch (this) {
      case AppRoute.splash:
      case AppRoute.login:
      case AppRoute.twoFactor:
      case AppRoute.biometric:
      case AppRoute.register:
        return false;
      case AppRoute.home:
      case AppRoute.assistance:
      case AppRoute.assistanceDetail:
      case AppRoute.tracking:
      case AppRoute.trackingMap:
      case AppRoute.chat:
      case AppRoute.videoCall:
      case AppRoute.payment:
      case AppRoute.profile:
      case AppRoute.beneficiary:
      case AppRoute.vehicle:
      case AppRoute.notifications:
      case AppRoute.history:
      case AppRoute.scheduling:
      case AppRoute.survey:
      case AppRoute.events:
      case AppRoute.settings:
        return true;
    }
  }
}

class RouteExtraKeys {
  const RouteExtraKeys._();
  static const String assistanceId = 'assistanceId';
  static const String notificationType = 'notificationType';
  static const String fromNotification = 'fromNotification';
  static const String isChatNotification = 'isChatNotification';
}
