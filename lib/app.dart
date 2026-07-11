/// Root widget. Wires theme (per-flavor, light/dark), locale + RTL, and the
/// GoRouter. Pure composition — no business logic.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/config_providers.dart';
import 'core/localization/generated/app_localizations.dart';
import 'core/localization/locale_controller.dart';
import 'core/localization/localization_providers.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class AffiliateApp extends ConsumerWidget {
  const AffiliateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorConfigProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: flavor.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(flavor),
      darkTheme: AppTheme.dark(flavor),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        // Force RTL layout for Arabic (AFILIADO `forceLayoutDirection`).
        final direction = isRtl(locale) ? TextDirection.rtl : TextDirection.ltr;
        return Directionality(textDirection: direction, child: child ?? const SizedBox());
      },
    );
  }
}