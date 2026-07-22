/// App router (GoRouter) + reactive auth redirect. The router refreshes when
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/assistance/presentation/pages/assistance_page.dart';
import '../../features/beneficiary/presentation/pages/beneficiary_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/videocall/presentation/pages/videocall_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/scheduling/presentation/pages/scheduling_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/survey/presentation/pages/survey_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/authentication/presentation/pages/two_factor_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/registration/presentation/pages/register_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/tracking/presentation/pages/tracking_page.dart';
import '../../features/vehicle/presentation/pages/vehicle_page.dart';
import '../session/session_state_provider.dart';
import 'app_routes.dart';

/// Holds the current auth state and notifies GoRouter to re-run its redirect.
/// The redirect reads the **current** value dynamically (not a captured
/// variable from provider creation), so flipping `isAuthenticated` from
/// `false` → `true` at login time correctly redirects to home.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this._isAuthenticated);
  bool _isAuthenticated;
  bool get isAuthenticated => _isAuthenticated;

  void update(bool value) {
    if (_isAuthenticated != value) {
      _isAuthenticated = value;
      notifyListeners();
    }
  }
}

/// The app's [GoRouter]. Created ONCE; the redirect reads auth state
/// dynamically from [_AuthRefreshNotifier] so it always sees the latest value.
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRefreshNotifier(ref.read(isAuthenticatedProvider));

  ref.listen<bool>(isAuthenticatedProvider, (_, next) {
    notifier.update(next);
  });
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRoute.splash.path,
    refreshListenable: notifier,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final to = state.matchedLocation;
      final isAuthenticated = notifier.isAuthenticated;
      final goingToProtected = AppRoute.values
          .where((r) => r.isProtected)
          .any((r) => to.startsWith(r.path));

      if (goingToProtected && !isAuthenticated) {
        return AppRoute.login.path;
      }
      if (to == AppRoute.login.path && isAuthenticated) {
        return AppRoute.home.path;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(path: AppRoute.login.path, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: AppRoute.twoFactor.path,
        builder: (_, _) => const TwoFactorPage(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        builder: (_, _) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoute.assistance.path,
        builder: (_, _) => const AssistancePage(),
      ),
      GoRoute(
        path: AppRoute.tracking.path,
        builder: (_, _) => const TrackingPage(),
      ),
      GoRoute(
        path: AppRoute.chat.path,
        builder: (context, state) =>
            ChatPage(assistanceId: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: AppRoute.videoCall.path,
        builder: (context, state) =>
            VideoCallPage(assistanceId: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: AppRoute.payment.path,
        builder: (_, _) => const PaymentPage(),
      ),
      GoRoute(
        path: AppRoute.profile.path,
        builder: (_, _) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoute.beneficiary.path,
        builder: (_, _) => const BeneficiaryPage(),
      ),
      GoRoute(
        path: AppRoute.vehicle.path,
        builder: (_, _) => const VehiclePage(),
      ),
      GoRoute(
        path: AppRoute.notifications.path,
        builder: (_, _) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoute.history.path,
        builder: (_, _) => const HistoryPage(),
      ),
      GoRoute(
        path: AppRoute.scheduling.path,
        builder: (context, state) =>
            SchedulingPage(serviceId: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: AppRoute.survey.path,
        builder: (context, state) =>
            SurveyPage(assistanceId: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: AppRoute.settings.path,
        builder: (_, _) => const SettingsPage(),
      ),
      GoRoute(path: AppRoute.home.path, builder: (_, _) => const HomePage()),
    ],
  );
});
