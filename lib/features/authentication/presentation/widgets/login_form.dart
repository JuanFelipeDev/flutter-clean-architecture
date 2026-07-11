/// Login form that renders the fields for the active [LoginStrategy]
/// (AFILIADO standard / EO / Roble).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/flavor_config.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/validated_text_field.dart';
import '../providers/auth_providers.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({required this.strategy, super.key});

  final LoginStrategy strategy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._fields(context, ref),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => ref.read(loginProvider.notifier).submit(),
            child: Text(context.l10n.loginSubmit),
          ),
        ],
      ),
    );
  }

  List<Widget> _fields(BuildContext context, WidgetRef ref) {
    switch (strategy) {
      case LoginStrategy.standard:
        return [
          ValidatedTextField(
            controller: _bind(ref, 'username'),
            label: context.l10n.loginUsername,
            validators: [Validators.required()],
          ),
          const SizedBox(height: 12),
          ValidatedTextField(
            controller: _bind(ref, 'password'),
            label: context.l10n.loginPassword,
            obscureText: true,
            validators: [Validators.required()],
          ),
        ];
      case LoginStrategy.eo:
        return [
          ValidatedTextField(
            controller: _bind(ref, 'phone'),
            label: 'Phone',
            keyboardType: TextInputType.phone,
            validators: [Validators.required()],
          ),
          const SizedBox(height: 12),
          ValidatedTextField(
            controller: _bind(ref, 'name'),
            label: 'Full name',
            validators: [Validators.required()],
          ),
          const SizedBox(height: 12),
          ValidatedTextField(
            controller: _bind(ref, 'password'),
            label: context.l10n.loginPassword,
            obscureText: true,
            validators: [Validators.required()],
          ),
        ];
      case LoginStrategy.roble:
        return [
          ValidatedTextField(controller: _bind(ref, 'nit'), label: 'NIT'),
          const SizedBox(height: 12),
          ValidatedTextField(controller: _bind(ref, 'placa'), label: 'Placa'),
          const SizedBox(height: 12),
          ValidatedTextField(controller: _bind(ref, 'dpi'), label: 'DPI'),
          const SizedBox(height: 8),
          Text(
            'Complete at least two fields.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ];
    }
  }

  /// Returns a controller backed by the notifier field, kept in sync both
  /// ways.
  TextEditingController _bind(WidgetRef ref, String key) {
    final notifier = ref.read(loginProvider.notifier);
    final value = _readField(ref, key);
    final controller = TextEditingController(text: value);
    controller.addListener(() => notifier.setField(key, controller.text));
    return controller;
  }

  String _readField(WidgetRef ref, String key) {
    final state = ref.read(loginProvider);
    switch (key) {
      case 'username':
        return state.username;
      case 'password':
        return state.password;
      case 'phone':
        return state.phone;
      case 'name':
        return state.name;
      case 'nit':
        return state.nit;
      case 'placa':
        return state.placa;
      case 'dpi':
        return state.dpi;
      default:
        return '';
    }
  }
}