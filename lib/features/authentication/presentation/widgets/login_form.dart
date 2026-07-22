/// Login form that renders the fields for the active [LoginStrategy]
///
/// Controllers are created once in [initState] and persisted across rebuilds.
/// Recreating them on every build (the naive approach) resets the
/// [TextField]'s selection/composing region on each keystroke, which breaks
/// backspace and jumps the cursor. The controllers are the source of truth
/// while editing; their listeners keep the [LoginNotifier] state in sync for
/// submission.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/flavor_config.dart';
import '../../../../core/localization/l10n.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/validated_text_field.dart';
import '../providers/auth_providers.dart';
import '../states/login_state.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({required this.strategy, super.key});

  final LoginStrategy strategy;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final state = ref.read(loginProvider);
    _controllers = {
      for (final key in _keysFor(widget.strategy))
        key: TextEditingController(text: _readField(state, key)),
    };
    for (final entry in _controllers.entries) {
      entry.value.addListener(() {
        ref.read(loginProvider.notifier).setField(entry.key, entry.value.text);
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<String> _keysFor(LoginStrategy strategy) {
    switch (strategy) {
      case LoginStrategy.standard:
        return ['username', 'password'];
      case LoginStrategy.eo:
        return ['phone', 'name', 'password'];
      case LoginStrategy.roble:
        return ['nit', 'placa', 'dpi'];
    }
  }

  String _readField(LoginState state, String key) => switch (key) {
    'username' => state.username,
    'password' => state.password,
    'phone' => state.phone,
    'name' => state.name,
    'nit' => state.nit,
    'placa' => state.placa,
    'dpi' => state.dpi,
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._fields(context),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => ref.read(loginProvider.notifier).submit(),
            child: Text(context.l10n.loginSubmit),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.push(AppRoute.register.path),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  List<Widget> _fields(BuildContext context) {
    switch (widget.strategy) {
      case LoginStrategy.standard:
        return [
          ValidatedTextField(
            controller: _controllers['username']!,
            label: context.l10n.loginUsername,
            validators: [Validators.required()],
          ),
          const SizedBox(height: 12),
          ValidatedTextField(
            controller: _controllers['password']!,
            label: context.l10n.loginPassword,
            obscureText: true,
            validators: [Validators.required()],
          ),
        ];
      case LoginStrategy.eo:
        return [
          ValidatedTextField(
            controller: _controllers['phone']!,
            label: 'Phone',
            keyboardType: TextInputType.phone,
            validators: [Validators.required()],
          ),
          const SizedBox(height: 12),
          ValidatedTextField(
            controller: _controllers['name']!,
            label: 'Full name',
            validators: [Validators.required()],
          ),
          const SizedBox(height: 12),
          ValidatedTextField(
            controller: _controllers['password']!,
            label: context.l10n.loginPassword,
            obscureText: true,
            validators: [Validators.required()],
          ),
        ];
      case LoginStrategy.roble:
        return [
          ValidatedTextField(controller: _controllers['nit']!, label: 'NIT'),
          const SizedBox(height: 12),
          ValidatedTextField(
            controller: _controllers['placa']!,
            label: 'Placa',
          ),
          const SizedBox(height: 12),
          ValidatedTextField(controller: _controllers['dpi']!, label: 'DPI'),
          const SizedBox(height: 8),
          Text(
            'Complete at least two fields.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ];
    }
  }
}
