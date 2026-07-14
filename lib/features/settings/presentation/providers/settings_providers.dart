/// Riverpod wiring for the settings feature. [SettingsNotifier] loads the
/// per-client app configuration, persists the language choice, and logs out
/// (clearing the session + flipping auth so the router returns to login).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/locale_controller.dart';
import '../../../../core/localization/localization_providers.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../../../core/session/session_state_provider.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/settings_remote_data_source.dart';
import '../../data/models/settings_dtos.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/settings_entities.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/settings_usecases.dart';
import '../states/settings_state.dart';

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  return SettingsRemoteDataSource(ref.watch(dioProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    remoteDataSource: ref.watch(settingsRemoteDataSourceProvider),
    mapper: const SettingsMapper(),
    storage: ref.watch(secureStorageProvider),
  );
});

final getAppConfigurationUseCaseProvider = Provider<GetAppConfigurationUseCase>((ref) {
  return GetAppConfigurationUseCase(ref.watch(settingsRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(settingsRepositoryProvider));
});

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final locale = ref.read(localeProvider);
    return SettingsState(languageCode: locale.languageCode);
  }

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  Future<void> loadConfiguration() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(status: SettingsStatus.failure, errorMessage: 'No session');
      return;
    }
    state = state.copyWith(status: SettingsStatus.loading, errorMessage: '');
    final result = await ref.read(getAppConfigurationUseCaseProvider).call(affKey);
    state = state.copyWith(
      configuration: result.getOrNull(),
      status: SettingsStatus.idle,
    );
  }

  Future<void> changeLanguage(String code) async {
    final locale = parseLocale(code);
    ref.read(localeProvider.notifier).state = locale;
    final prefs = await ref.read(prefsServiceProvider.future);
    await prefs.setLocale(languageTag(locale));
    state = state.copyWith(languageCode: locale.languageCode);
  }

  Future<void> logout() async {
    state = state.copyWith(status: SettingsStatus.loading, errorMessage: '');
    final result = await ref.read(logoutUseCaseProvider).call();
    result.fold(
      onSuccess: (_) {
        // Flip app auth state so the router returns to login.
        ref.read(cachedSessionProvider.notifier).state = null;
        ref.read(isAuthenticatedProvider.notifier).state = false;
        state = state.copyWith(status: SettingsStatus.success);
      },
      onFailure: (failure) => state = state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

/// The languages AFILIADO supports (AFILIADO `getNameOfLanguage`).
final supportedLanguagesProvider = Provider<List<LanguageOption>>((ref) {
  return const [
    LanguageOption(code: 'es', name: 'Español'),
    LanguageOption(code: 'en', name: 'English'),
    LanguageOption(code: 'fr', name: 'Français'),
    LanguageOption(code: 'pt', name: 'Português'),
    LanguageOption(code: 'pt-BR', name: 'Português (BR)'),
    LanguageOption(code: 'ar', name: 'العربية'),
  ];
});