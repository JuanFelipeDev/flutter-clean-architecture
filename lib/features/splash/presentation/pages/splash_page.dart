/// Splash screen — runs root (release) + version checks, then routes to login
/// or home (AFILIADO `SplashActivity` / `OpenApp`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../domain/entities/splash_entities.dart';
import '../providers/splash_providers.dart';
import '../states/splash_state.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Start after the first frame so providers are available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SplashState>(splashProvider, (_, next) {
      if (next is SplashReady) {
        _navigate(next);
      }
    });

    final flavor = ref.watch(flavorConfigProvider);
    final theme = Theme.of(context);
    final state = ref.watch(splashProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SafeArea(
        child: Center(child: _body(context, theme, flavor.appName, state)),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    ThemeData theme,
    String appName,
    SplashState state,
  ) {
    return switch (state) {
      SplashInitial() || SplashLoading() => _loading(theme, appName),
      SplashRooted() => _rooted(context, theme),
      SplashUpdateRequired(:final latestVersion) =>
        _updateRequired(context, theme, latestVersion),
      SplashReady() => _loading(theme, appName),
    };
  }

  Widget _loading(ThemeData theme, String appName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_outlined, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          appName,
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: 24),
        CircularProgressIndicator(color: theme.colorScheme.primary),
      ],
    );
  }

  Widget _rooted(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.security, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            context.l10n.errorGeneric,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This device is not supported for security reasons.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _updateRequired(BuildContext context, ThemeData theme, String version) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.system_update, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Update required',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Latest version: $version', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoute.login.path),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigate(SplashReady state) {
    final target = switch (state.route) {
      HomeRoute() => AppRoute.home.path,
      LoginRoute() => AppRoute.login.path,
      DeepLinkLoginRoute() => AppRoute.login.path,
    };
    context.go(target);
  }
}