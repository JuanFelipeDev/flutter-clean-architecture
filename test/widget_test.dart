// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in a test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures to a widget and verify that the UI responds as expected.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:affiliate_app/app.dart';
import 'package:affiliate_app/core/config/config_providers.dart';
import 'package:affiliate_app/core/config/flavor_config.dart';
import 'package:affiliate_app/core/session/session_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('AffiliateApp boots and renders the splash screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          flavorConfigProvider.overrideWithValue(FlavorConfig.fromEnvironment()),
          isAuthenticatedProvider.overrideWith((_) => false),
        ],
        child: const AffiliateApp(),
      ),
    );

    // First frame + async localization/router settle.
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(Scaffold), findsWidgets);
  });
}