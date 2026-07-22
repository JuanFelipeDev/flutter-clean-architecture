/// `configurationapp/` + language + logout).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/settings_entities.dart';
import '../providers/settings_providers.dart';
import '../states/settings_state.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(settingsProvider, _onChanged);
      ref.read(settingsProvider.notifier).loadConfiguration();
    });
  }

  void _onChanged(SettingsState? previous, SettingsState next) {
    if (next.status == SettingsStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final languages = ref.watch(supportedLanguagesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == SettingsStatus.loading,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Language', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final lang in languages)
                ListTile(
                  title: Text(lang.name),
                  trailing: _isActive(state.languageCode, lang.code)
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => ref
                      .read(settingsProvider.notifier)
                      .changeLanguage(lang.code),
                ),
              const Divider(height: 32),
              Text(
                'App configuration',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (state.configuration == null)
                const Text('Not loaded')
              else
                _ConfigView(configuration: state.configuration!),
              const SizedBox(height: 32),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => ref.read(settingsProvider.notifier).logout(),
                child: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Matches the active language by code (handles pt vs pt-BR).
  bool _isActive(String? current, String code) {
    if (current == null) return false;
    return current == code || current == code.split('-').first;
  }
}

class _ConfigView extends StatelessWidget {
  const _ConfigView({required this.configuration});
  final AppConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (configuration.logoUrl != null)
          Text('Logo: ${configuration.logoUrl}'),
        Text('Beneficiaries: ${configuration.displayItemBeneficiaries}'),
        Text('Vehicles: ${configuration.displayItemVehicles}'),
        Text('Shop: ${configuration.displayShoppingList}'),
        Text('Profile: ${configuration.displayItemProfile}'),
        if (configuration.maxInactivityMinutes != null)
          Text('Inactivity (min): ${configuration.maxInactivityMinutes}'),
      ],
    );
  }
}
