import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/core/session/session_state_provider.dart';
import 'package:affiliate_app/core/localization/localization_providers.dart';
import 'package:affiliate_app/core/storage/prefs_service.dart';
import 'package:affiliate_app/core/storage/storage_providers.dart';
import 'package:affiliate_app/features/settings/data/models/settings_dtos.dart';
import 'package:affiliate_app/features/settings/domain/entities/settings_entities.dart';
import 'package:affiliate_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:affiliate_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:affiliate_app/features/settings/presentation/states/settings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePrefs implements PrefsService {
  String? _localeTag;
  @override
  String? get locale => _localeTag;
  @override
  Future<void> setLocale(String tag) async {
    _localeTag = tag;
  }

  @override
  String? getString(String key) => null;
  @override
  Future<void> setString(String key, String value) async {}
  @override
  bool? getBool(String key) => null;
  @override
  Future<void> setBool(String key, bool value) async {}
  @override
  Future<void> remove(String key) async {}
  @override
  String? get themeMode => null;
  @override
  Future<void> setThemeMode(String mode) async {}
  @override
  bool get displayItemBeneficiaries => false;
  @override
  bool get displayItemVehicles => false;
  @override
  bool get displayShoppingList => false;
  @override
  bool get displayItemProfile => true;
}

class _FakeSettingsRepository implements SettingsRepository {
  bool loggedOut = false;

  @override
  Future<Result<AppConfiguration>> appConfiguration(String affKey) async =>
      const Success(
        AppConfiguration(
          primaryColor: 0xFF1E88E5,
          displayItemBeneficiaries: true,
          maxInactivityMinutes: 10,
        ),
      );
  @override
  Future<Result<void>> logout() async {
    loggedOut = true;
    return Result<void>.guard(() {});
  }
}

void main() {
  const session = SessionData(accessToken: 'tok', affKey: 'aff-1');

  group('SettingsMapper', () {
    const mapper = SettingsMapper();
    test('parses colors and flags', () {
      final cfg = mapper.toEntity(
        const AppConfigurationDto(
          primaryColor: '#1E88E5',
          displayItemBeneficiaries: true,
          maxInactivityMinutes: 10,
        ),
      );
      expect(cfg.primaryColor, 0xFF1E88E5);
      expect(cfg.displayItemBeneficiaries, isTrue);
      expect(cfg.maxInactivityMinutes, 10);
    });
    test('defaults flags when missing', () {
      final cfg = mapper.toEntity(const AppConfigurationDto());
      expect(cfg.displayItemBeneficiaries, isFalse);
      expect(cfg.displayItemProfile, isTrue);
    });
  });

  group('SettingsNotifier', () {
    late _FakeSettingsRepository repo;

    ProviderContainer makeContainer() {
      repo = _FakeSettingsRepository();
      return ProviderContainer(
        overrides: [
          cachedSessionProvider.overrideWith((_) => session),
          settingsRepositoryProvider.overrideWithValue(repo),
          prefsServiceProvider.overrideWith((_) => _FakePrefs()),
        ],
      );
    }

    test('loads configuration', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(settingsProvider.notifier);
      await notifier.loadConfiguration();
      expect(
        container
            .read(settingsProvider)
            .configuration
            ?.displayItemBeneficiaries,
        isTrue,
      );
    });

    test('changeLanguage updates the locale', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(settingsProvider.notifier);
      await notifier.changeLanguage('en');
      expect(container.read(settingsProvider).languageCode, 'en');
      expect(container.read(localeProvider).languageCode, 'en');
    });

    test('logout clears auth state', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      container.read(isAuthenticatedProvider.notifier).state = true;
      final notifier = container.read(settingsProvider.notifier);
      await notifier.logout();
      expect(container.read(isAuthenticatedProvider), isFalse);
      expect(container.read(cachedSessionProvider), isNull);
      expect(repo.loggedOut, isTrue);
      expect(container.read(settingsProvider).status, SettingsStatus.success);
    });
  });
}
