/// Registration wizard (AFILIADO `SelectUserTypeActivity` ->
/// `ValidateDocumentAndPoliceActivity` -> `RegisterActivity`). A single page
/// that renders the current step driven by [RegistrationState.step].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    if (next.status == RegistrationStatus.success && next.step == RegistrationStep.done) {
      context.showToast('Registration successful', kind: ToastKind.success);
      context.go(AppRoute.login.path);
    } else if (next.status == RegistrationStatus.failure) {
      context.showToast(next.errorMessage ?? context.l10n.errorGeneric, kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.loginTitle == 'Sign in' ? 'Register' : 'Registro'),
        leading: state.step != RegistrationStep.selectType
            ? BackButton(onPressed: () => _back(context, state))
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
      case RegistrationStep.validateDocument:
        return _ValidateDocumentStep(
          document: state.document,
          onChanged: ref.read(registrationProvider.notifier).setDocument,
          onSubmit: ref.read(registrationProvider.notifier).validateDocument,
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

  void _back(BuildContext context, RegistrationState state) {
    switch (state.step) {
      case RegistrationStep.validateDocument:
        ref.read(registrationProvider.notifier).backTo(RegistrationStep.selectType);
      case RegistrationStep.form:
        ref.read(registrationProvider.notifier).backTo(RegistrationStep.validateDocument);
      default:
        Navigator.of(context).maybePop();
    }
  }
}

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
          Text('Select account type', style: Theme.of(context).textTheme.titleLarge),
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

class _ValidateDocumentStep extends StatefulWidget {
  const _ValidateDocumentStep({
    required this.document,
    required this.onChanged,
    required this.onSubmit,
  });

  final String document;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  State<_ValidateDocumentStep> createState() => _ValidateDocumentStepState();
}

class _ValidateDocumentStepState extends State<_ValidateDocumentStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.document);
    _controller.addListener(() => widget.onChanged(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Enter your document', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Document')),
          const SizedBox(height: 24),
          FilledButton(onPressed: widget.onSubmit, child: const Text('Validate')),
        ],
      ),
    );
  }
}