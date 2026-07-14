/// Profile screen — editable affiliate profile + password change (AFILIADO
/// `ProfileFragment`). Fields use persistent controllers (see LoginForm) so
/// editing/backspace works.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../core/widgets/validated_text_field.dart';
import '../../domain/entities/profile_entities.dart';
import '../providers/profile_providers.dart';
import '../states/profile_state.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final Map<String, TextEditingController> _controllers;
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllers = {
      'firstName': TextEditingController(),
      'firstSurname': TextEditingController(),
      'email': TextEditingController(),
      'phone': TextEditingController(),
      'documentNumber': TextEditingController(),
    };
    for (final entry in _controllers.entries) {
      entry.value.addListener(() =>
          ref.read(profileProvider.notifier).editField(entry.key, entry.value.text));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(profileProvider, _onChanged);
      ref.read(profileProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _oldPass.dispose();
    _newPass.dispose();
    super.dispose();
  }

  void _onChanged(ProfileState? previous, ProfileState next) {
    // Sync controllers once when the profile first arrives.
    if (previous?.profile == null && next.profile != null) {
      _syncControllers(next.profile!);
    }
    if (next.status == ProfileStatus.success) {
      context.showToast('Saved', kind: ToastKind.success);
    } else if (next.status == ProfileStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  void _syncControllers(AffiliateProfile profile) {
    _controllers['firstName']!.text = profile.firstName ?? '';
    _controllers['firstSurname']!.text = profile.firstSurname ?? '';
    _controllers['email']!.text = profile.email ?? '';
    _controllers['phone']!.text = profile.phone ?? '';
    _controllers['documentNumber']!.text = profile.documentNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == ProfileStatus.loading,
          child: state.profile == null
              ? const Center(child: Text('No profile'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ValidatedTextField(
                        controller: _controllers['firstName']!,
                        label: 'First name',
                        validators: [Validators.required()],
                      ),
                      const SizedBox(height: 12),
                      ValidatedTextField(
                        controller: _controllers['firstSurname']!,
                        label: 'Last name',
                        validators: [Validators.required()],
                      ),
                      const SizedBox(height: 12),
                      ValidatedTextField(
                        controller: _controllers['email']!,
                        label: 'Email',
                        validators: [Validators.required(), Validators.email()],
                      ),
                      const SizedBox(height: 12),
                      ValidatedTextField(
                        controller: _controllers['phone']!,
                        label: 'Phone',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        key: ValueKey('doctype-${state.profile?.documentTypeId}'),
                        initialValue: state.profile?.documentTypeId,
                        decoration: const InputDecoration(labelText: 'Document type'),
                        items: [
                          for (final t in state.documentTypes)
                            DropdownMenuItem(value: t.id, child: Text(t.name)),
                        ],
                        onChanged: (value) {
                          if (value != null) ref.read(profileProvider.notifier).editField('documentTypeId', value);
                        },
                      ),
                      const SizedBox(height: 12),
                      ValidatedTextField(
                        controller: _controllers['documentNumber']!,
                        label: 'Document number',
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: state.status == ProfileStatus.saving
                            ? null
                            : () => ref.read(profileProvider.notifier).save(),
                        child: const Text('Save'),
                      ),
                      const Divider(height: 48),
                      Text('Change password', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _oldPass,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Current password'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _newPass,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'New password'),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => ref
                            .read(profileProvider.notifier)
                            .changePassword(_oldPass.text, _newPass.text),
                        child: const Text('Change password'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}