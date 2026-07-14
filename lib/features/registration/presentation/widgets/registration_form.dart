/// Registration form rendering the fields declared by
/// [FlavorConfig.registerFields] (AFILIADO per-flavor `BuildConfig` field
/// flags: EMAIL/PHONE/NAME/LASTNAME/NIT/...). Controllers persist across
/// rebuilds to avoid the editing bug (see [LoginForm]).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/validated_text_field.dart';
import '../../domain/entities/registration_entities.dart';
import '../providers/registration_providers.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({required this.accountType, required this.onSubmit, super.key});

  final AccountType accountType;
  final VoidCallback onSubmit;

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  late final List<String> _fieldKeys;
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final flavor = ref.read(flavorConfigProvider);
    _fieldKeys = flavor.registerFields;
    final state = ref.read(registrationProvider);
    _controllers = {
      for (final key in _fieldKeys)
        key: TextEditingController(text: state.fields[key] ?? ''),
    };
    for (final entry in _controllers.entries) {
      entry.value.addListener(() {
        ref.read(registrationProvider.notifier).setField(entry.key, entry.value.text);
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Account type: ${widget.accountType.name}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _fieldKeys.length; i++) ...[
            ValidatedTextField(
              controller: _controllers[_fieldKeys[i]]!,
              label: _labelFor(_fieldKeys[i]),
              keyboardType: _keyboardFor(_fieldKeys[i]),
              validators: [Validators.required()],
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          FilledButton(onPressed: widget.onSubmit, child: const Text('Register')),
        ],
      ),
    );
  }

  String _labelFor(String key) {
    switch (key) {
      case 'email':
        return 'Email';
      case 'phone':
        return 'Phone';
      case 'name':
        return 'Name';
      case 'lastname':
        return 'Last name';
      case 'nit':
        return 'NIT';
      case 'address':
        return 'Address';
      default:
        return key[0].toUpperCase() + key.substring(1);
    }
  }

  TextInputType? _keyboardFor(String key) {
    switch (key) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      default:
        return null;
    }
  }
}