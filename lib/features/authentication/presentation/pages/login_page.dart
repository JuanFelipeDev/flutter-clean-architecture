/// Login screen — three strategies (standard / EO / Roble) selected per
/// `LoginActivity`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../providers/auth_providers.dart';
import '../states/login_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(loginProvider, _onStateChanged);
    });
  }

  void _onStateChanged(LoginState? previous, LoginState next) {
    switch (next.status) {
      case LoginStatus.success:
        break;
      case LoginStatus.requiresTwoFactor:
        context.go(AppRoute.twoFactor.path);
      case LoginStatus.failure:
        context.showToast(
          next.errorMessage ?? context.l10n.errorGeneric,
          kind: ToastKind.error,
        );
      case LoginStatus.idle:
      case LoginStatus.loading:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final flavor = ref.watch<FlavorConfig>(flavorConfigProvider);
    final env = ref.watch(currentEnvironmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.loginTitle),
        actions: [
          if (flavor.envSwitcherEnabled)
            PopupMenuButton<Environment>(
              tooltip: 'Environment',
              icon: Icon(
                Icons.dns_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              onSelected: (value) {
                ref.read(currentEnvironmentProvider.notifier).state = value;
                ref
                    .read(prefsServiceProvider.future)
                    .then((p) => p.setString('TYPE_ENVIROMENT', value.name));
              },
              itemBuilder: (_) => [
                for (final e in Environment.values)
                  PopupMenuItem(
                    value: e,
                    child: Row(
                      children: [
                        Icon(
                          e == env ? Icons.check_circle : Icons.circle_outlined,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(e.name.toUpperCase()),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == LoginStatus.loading,
          child: LoginForm(strategy: flavor.loginStrategy),
        ),
      ),
    );
  }
}
