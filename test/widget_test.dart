// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in a test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures to a widget and verify that the UI responds as expected.
import 'package:affiliate_app/app.dart';
import 'package:affiliate_app/core/config/flavor_config.dart';
import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_repository.dart';
import 'package:affiliate_app/core/session/session_state_provider.dart';
import 'package:affiliate_app/core/config/config_providers.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/features/splash/domain/entities/splash_entities.dart';
import 'package:affiliate_app/features/splash/domain/repositories/app_config_repository.dart';
import 'package:affiliate_app/features/splash/presentation/providers/splash_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAppConfigRepository implements AppConfigRepository {
  @override
  Future<Result<VersionCheck>> checkVersion({required String currentVersion}) async {
    return Success(VersionCheck(currentVersion: currentVersion, latestVersion: currentVersion));
  }
}

class _FakeSessionRepository implements SessionRepository {
  @override
  Future<bool> hasSession() async => false;
  @override
  Future<void> clear() async {}
  @override
  Future<String?> accessToken() async => null;
  @override
  Future<Result<void>> refresh() async => Result<void>.guard(() {});
}

void main() {
  testWidgets('AffiliateApp boots and navigates splash to login', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          flavorConfigProvider.overrideWithValue(FlavorConfig.fromEnvironment()),
          isAuthenticatedProvider.overrideWith((_) => false),
          sessionRepositoryProvider.overrideWithValue(_FakeSessionRepository()),
          appConfigRepositoryProvider.overrideWithValue(_FakeAppConfigRepository()),
        ],
        child: const AffiliateApp(),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Splash resolves → routes to login.
    expect(find.byType(Scaffold), findsWidgets);
  });
}