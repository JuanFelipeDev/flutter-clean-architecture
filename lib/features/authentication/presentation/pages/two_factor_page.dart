/// Two-factor verification screen (AFILIADO `DoubleFactAuthActivity`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../providers/auth_providers.dart';
import '../states/login_state.dart';

class TwoFactorPage extends ConsumerStatefulWidget {
  const TwoFactorPage({super.key});

  @override
  ConsumerState<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends ConsumerState<TwoFactorPage> {
  final _code = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(loginProvider, _onStateChanged);
    });
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _onStateChanged(LoginState? previous, LoginState next) {
    switch (next.status) {
      case LoginStatus.success:
        context.go(AppRoute.home.path);
      case LoginStatus.failure:
        context.showToast(next.errorMessage ?? context.l10n.errorGeneric, kind: ToastKind.error);
      case LoginStatus.idle:
      case LoginStatus.loading:
      case LoginStatus.requiresTwoFactor:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Two-factor verification')),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == LoginStatus.loading,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter the code sent to you.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _code,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(labelText: 'Code'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () =>
                      ref.read(loginProvider.notifier).submitTwoFactor(_code.text),
                  child: const Text('Verify'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}