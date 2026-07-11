/// Splash screen — PLACEHOLDER. Phase 5 implements the real splash:
/// location permission, root/signature check (release), version check, and
/// the `OpenApp` token-vs-login decision. For Phase 3 it is a visual shell
/// proving the router + theme + localization load.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/navigation/app_routes.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorConfigProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                flavor.appName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${flavor.flavor.name} • ${flavor.environment.name}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.go(AppRoute.login.path),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}