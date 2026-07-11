/// Login screen — three strategies (standard / EO / Roble) selected per
/// flavor, 2FA hand-off, and navigation to home on success (AFILIADO
/// `LoginActivity`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../core/navigation/app_routes.dart';
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
        context.go(AppRoute.home.path);
      case LoginStatus.requiresTwoFactor:
        context.go(AppRoute.twoFactor.path);
      case LoginStatus.failure:
        context.showToast(next.errorMessage ?? context.l10n.errorGeneric, kind: ToastKind.error);
      case LoginStatus.idle:
      case LoginStatus.loading:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final flavor = ref.watch<FlavorConfig>(flavorConfigProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.loginTitle)),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == LoginStatus.loading,
          child: LoginForm(strategy: flavor.loginStrategy),
        ),
      ),
    );
  }
}