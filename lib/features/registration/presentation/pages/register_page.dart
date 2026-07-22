/// `ValidateDocumentAndPoliceActivity` -> `RegisterActivity`). A single page
/// that renders the current step driven by [RegistrationState.step].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/registration_entities.dart';
import '../providers/registration_providers.dart';
import '../states/registration_state.dart';
import '../widgets/registration_form.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(registrationProvider, _onStateChanged);
    });
  }

  void _onStateChanged(RegistrationState? previous, RegistrationState next) {
    if (next.status == RegistrationStatus.success &&
        next.step == RegistrationStep.done) {
      context.showToast('Registration successful', kind: ToastKind.success);
      context.go(AppRoute.login.path);
    } else if (next.status == RegistrationStatus.failure) {
      context.showToast(
        next.errorMessage ?? context.l10n.errorGeneric,
        kind: ToastKind.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);
    final hasTypeSelection = ref
        .watch(flavorConfigProvider)
        .requiresAccountTypeSelection;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.loginTitle == 'Sign in' ? 'Register' : 'Registro',
        ),
        leading: state.step != RegistrationStep.selectType
            ? BackButton(onPressed: () => _back(context, state, hasTypeSelection))
            : null,
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == RegistrationStatus.loading,
          child: _step(context, state),
        ),
      ),
    );
  }

  Widget _step(BuildContext context, RegistrationState state) {
    switch (state.step) {
      case RegistrationStep.selectType:
        return _SelectTypeStep(
          onSelected: ref.read(registrationProvider.notifier).selectAccountType,
        );
      case RegistrationStep.form:
        return RegistrationForm(
          accountType: state.accountType,
          onSubmit: ref.read(registrationProvider.notifier).register,
        );
      case RegistrationStep.done:
        return const Center(child: Text('Done'));
    }
  }

  void _back(
    BuildContext context,
    RegistrationState state,
    bool hasTypeSelection,
  ) {
    switch (state.step) {
      case RegistrationStep.form:
        if (hasTypeSelection) {
          ref
              .read(registrationProvider.notifier)
              .backTo(RegistrationStep.selectType);
        } else {
          Navigator.of(context).maybePop();
        }
      default:
        Navigator.of(context).maybePop();
    }
  }
}

/// Account-type selection. Only rendered for flavors that require it (ccife).
class _SelectTypeStep extends StatelessWidget {
  const _SelectTypeStep({required this.onSelected});
  final void Function(AccountType) onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select account type',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => onSelected(AccountType.affiliate),
            child: const Text('Affiliate'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => onSelected(AccountType.guest),
            child: const Text('Guest'),
          ),
        ],
      ),
    );
  }
}