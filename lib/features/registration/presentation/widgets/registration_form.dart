/// Registration form rendering the fields declared by the active flavor
/// (`REGISTER_FIELDS`), with field-type-aware rendering:
/// - `password` → obscured field with strength validation + an auto-derived
///   `confirmPassword` field with match validation.
/// - `address` → Google Maps picker (unless the flavor sets plain text).
/// - `email` → email validation.
/// - everything else → required text.
///
/// Controllers persist across rebuilds to avoid the editing bug (see
/// [LoginForm]).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/validated_text_field.dart';
import '../../../places/presentation/widgets/address_map_picker.dart';
import '../../domain/entities/registration_entities.dart';
import '../providers/registration_providers.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({
    required this.accountType,
    required this.onSubmit,
    super.key,
  });

  final AccountType accountType;
  final VoidCallback onSubmit;

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  late final List<String> _fieldKeys;
  late final Map<String, TextEditingController> _controllers;
  final _confirmKey = GlobalKey<ValidatedTextFieldState>();

  @override
  void initState() {
    super.initState();
    final flavor = ref.read(flavorConfigProvider);
    _fieldKeys = flavor.registerFields;
    final state = ref.read(registrationProvider);
    _controllers = {
      for (final key in _fieldKeys)
        key: TextEditingController(text: state.fields[key] ?? ''),
      if (_fieldKeys.contains('password'))
        'confirmPassword': TextEditingController(
          text: state.fields['confirmPassword'] ?? '',
        ),
    };
    for (final entry in _controllers.entries) {
      entry.value.addListener(() {
        ref
            .read(registrationProvider.notifier)
            .setField(entry.key, entry.value.text);
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

  List<FieldValidator> _validatorsFor(
    String key, {
    required bool strengthRequired,
  }) {
    switch (key) {
      case 'email':
        return [Validators.required(), Validators.email()];
      case 'password':
        return [
          Validators.required(),
          if (strengthRequired) Validators.password(),
        ];
      case 'confirmPassword':
        return [
          Validators.required(),
          Validators.match(() => _controllers['password']!.text),
        ];
      default:
        return [Validators.required()];
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
      case 'document':
        return 'Document';
      case 'address':
        return 'Address';
      case 'password':
        return 'Password';
      case 'confirmPassword':
        return 'Confirm password';
      default:
        return key[0].toUpperCase() + key.substring(1);
    }
  }

  Widget _fieldForKey(String key, {required bool strengthRequired}) {
    if (key == 'address') {
      return ref.read(flavorConfigProvider).addressAsPlainText
          ? _plainAddressField()
          : _addressPickerField();
    }
    final isPassword = key == 'password' || key == 'confirmPassword';
    return ValidatedTextField(
      key: key == 'confirmPassword' ? _confirmKey : null,
      controller: _controllers[key]!,
      label: _labelFor(key),
      keyboardType: _keyboardFor(key),
      obscureText: isPassword,
      obscureTextToggle: isPassword,
      validators: _validatorsFor(key, strengthRequired: strengthRequired),
      onChanged: (value) {
        // Re-validate the confirm field whenever the password changes so the
        // match error stays accurate.
        if (key == 'password') {
          _confirmKey.currentState?.validate();
        }
      },
    );
  }

  Widget _plainAddressField() {
    return ValidatedTextField(
      controller: _controllers['address']!,
      label: _labelFor('address'),
      validators: [Validators.required()],
    );
  }

  Widget _addressPickerField() {
    final address = ref.watch(registrationProvider).fields['address'] ?? '';
    return InkWell(
      onTap: () => _openAddressPicker(),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: _labelFor('address'),
          prefixIcon: const Icon(Icons.location_on_outlined),
          errorText: address.trim().isEmpty ? 'Required' : null,
        ),
        child: Text(
          address.isEmpty ? 'Ubica tu casa' : address,
          style: TextStyle(
            color: address.isEmpty ? Theme.of(context).hintColor : null,
          ),
        ),
      ),
    );
  }

  void _openAddressPicker() {
    final state = ref.read(registrationProvider);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: AddressMapPicker(
          initialAddress: state.fields['address'] ?? '',
          initialLat: state.addressLat,
          initialLng: state.addressLng,
          onPicked: (address, lat, lng) {
            ref
                .read(registrationProvider.notifier)
                .setAddress(address, lat, lng);
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flavor = ref.watch(flavorConfigProvider);
    final strengthRequired = flavor.passwordStrengthRequired;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _fieldKeys.length; i++) ...[
            _fieldForKey(_fieldKeys[i], strengthRequired: strengthRequired),
            const SizedBox(height: 12),
            if (_fieldKeys[i] == 'password') ...[
              _fieldForKey(
                'confirmPassword',
                strengthRequired: strengthRequired,
              ),
              const SizedBox(height: 12),
            ],
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: widget.onSubmit,
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}