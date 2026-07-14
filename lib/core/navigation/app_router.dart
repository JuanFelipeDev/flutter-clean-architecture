/// App router (GoRouter) + reactive auth redirect. The router refreshes when
/// [isAuthenticatedProvider] changes, reproducing AFILIADO's `OpenApp`
/// token-vs-login routing and PRESTADOR's `NavManager` typed registry.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/assistance/presentation/pages/assistance_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/videocall/presentation/pages/videocall_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/authentication/presentation/pages/two_factor_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/registration/presentation/pages/register_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/tracking/presentation/pages/tracking_page.dart';
import '../session/session_state_provider.dart';
import 'app_routes.dart';

/// Bridges auth-state changes to GoRouter's `refreshListenable`.
class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// The app's [GoRouter]. Re-routes on auth flips and on locale/env changes.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier();
  ref.listen<bool>(isAuthenticatedProvider, (_, _) => refresh.notify());
  ref.onDispose(refresh.dispose);

  final isAuthenticated = ref.read(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: AppRoute.splash.path,
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final to = state.matchedLocation;
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
      GoRoute(
        path: AppRoute.login.path,
        builder: (_, _) => const LoginPage(),
      ),
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
        builder: (context, state) => ChatPage(assistanceId: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: AppRoute.videoCall.path,
        builder: (context, state) => VideoCallPage(assistanceId: (state.extra as String?) ?? ''),
      ),
      GoRoute(
        path: AppRoute.payment.path,
        builder: (_, _) => const PaymentPage(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        builder: (_, _) => const HomePage(),
      ),
      // Remaining routes are wired in Phase 5 alongside their features.
    ],
  );
});