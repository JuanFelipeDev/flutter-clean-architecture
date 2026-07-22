import 'package:affiliate_app/core/config/config_providers.dart';
import 'package:affiliate_app/core/config/flavor_config.dart';
import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/features/registration/data/models/registration_dtos.dart';
import 'package:affiliate_app/features/registration/domain/entities/registration_entities.dart';
import 'package:affiliate_app/features/registration/domain/repositories/registration_repository.dart';
import 'package:affiliate_app/features/registration/presentation/providers/registration_providers.dart';
import 'package:affiliate_app/features/registration/presentation/states/registration_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRegistrationRepository implements RegistrationRepository {
  _FakeRegistrationRepository({this.success = true});

  final bool success;

  String? lastAffkey;
  Map<String, String>? lastFields;
  String? lastClientId;

  @override
  Future<Result<RegisterResult>> register({
    required String affkey,
    required Map<String, String> fields,
    required String clientId,
  }) async {
    lastAffkey = affkey;
    lastFields = Map<String, String>.from(fields);
    lastClientId = clientId;
    return Success(
      RegisterResult(
        success: success,
        message: success ? null : 'Failed',
        cveAffiliate: 'aff-1',
      ),
    );
  }
}

FlavorConfig _flavor({bool requiresAccountTypeSelection = false}) =>
    FlavorConfig(
      flavor: Flavor.basenewsoa,
      environment: Environment.dev,
      appName: 'Afiliado',
      primaryColor: 0xFF1E88E5,
      accentColor: 0xFFFFC107,
      loginStrategy: LoginStrategy.standard,
      registerFields: const <String>[
        'email',
        'phone',
        'name',
        'lastname',
        'document',
        'password',
        'address',
      ],
      clientId: 'basenewsoa',
      country: 'CO',
      urlServerDev: 'https://api.sistemaoperaciones.com/',
      urlServerQa: 'https://api.sistemaoperaciones.com/',
      urlServerProd: 'https://app.sistemaoperaciones.com/',
      urlServerPreprod: 'https://api.sistemaoperaciones.com/',
      urlSocket: 'https://api.sistemaoperaciones.com/',
      socketPath: '/soaang-notifier/wss/',
      sentryDsn: '',
      mapsApiKey: '',
      envSwitcherEnabled: true,
      requiresAccountTypeSelection: requiresAccountTypeSelection,
      passwordStrengthRequired: true,
      addressAsPlainText: false,
    );

void main() {
  group('RegistrationMapper', () {
    test('maps a successful registration', () {
      const dto = RegisterDto(success: true, cveAffiliate: 'aff-1');
      const mapper = RegistrationMapper();
      final result = mapper.toRegisterResult(dto);
      expect(result.success, isTrue);
      expect(result.cveAffiliate, 'aff-1');
    });
  });

  group('RegistrationNotifier', () {
    test('starts directly on the form when no account-type selection is required',
        () async {
      final container = ProviderContainer(
        overrides: [
          flavorConfigProvider.overrideWithValue(_flavor()),
          registrationRepositoryProvider.overrideWithValue(
            _FakeRegistrationRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = container.read(registrationProvider);
      expect(state.step, RegistrationStep.form);
    });

    test('selects account type and advances to form', () async {
      final container = ProviderContainer(
        overrides: [
          flavorConfigProvider.overrideWithValue(
            _flavor(requiresAccountTypeSelection: true),
          ),
          registrationRepositoryProvider.overrideWithValue(
            _FakeRegistrationRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      // With account-type selection required, the flow starts at selectType.
      expect(
        container.read(registrationProvider).step,
        RegistrationStep.selectType,
      );

      final notifier = container.read(registrationProvider.notifier);
      notifier.selectAccountType(AccountType.guest);
      expect(
        container.read(registrationProvider).step,
        RegistrationStep.form,
      );
      expect(
        container.read(registrationProvider).accountType,
        AccountType.guest,
      );
    });

    test('registers successfully and reaches done', () async {
      final fake = _FakeRegistrationRepository(success: true);
      final container = ProviderContainer(
        overrides: [
          flavorConfigProvider.overrideWithValue(_flavor()),
          registrationRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.setField('document', '12345');
      notifier.setField('address', 'Cra 1 #2-3');
      notifier.setField('password', 'Secret1!');
      notifier.setField('confirmPassword', 'Secret1!');
      await notifier.register();
      final state = container.read(registrationProvider);
      expect(state.step, RegistrationStep.done);
      expect(state.status, RegistrationStatus.success);
      expect(state.cveAffiliate, 'aff-1');
      // affkey resolved from the document field; client_id from flavor.
      expect(fake.lastAffkey, '12345');
      expect(fake.lastClientId, 'basenewsoa');
      // confirmPassword is validation-only and must never reach the backend.
      expect(fake.lastFields, isNotNull);
      expect(fake.lastFields!.containsKey('confirmPassword'), isFalse);
      expect(fake.lastFields!['password'], 'Secret1!');
      expect(fake.lastFields!['address'], 'Cra 1 #2-3');
    });

    test('resolves affkey from the nit field when document is absent',
        () async {
      final fake = _FakeRegistrationRepository(success: true);
      final container = ProviderContainer(
        overrides: [
          flavorConfigProvider.overrideWithValue(_flavor()),
          registrationRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.setField('nit', 'GT-12345');
      notifier.setField('address', 'Zona 1');
      await notifier.register();
      final state = container.read(registrationProvider);
      expect(state.step, RegistrationStep.done);
      expect(state.status, RegistrationStatus.success);
      expect(fake.lastAffkey, 'GT-12345');
    });

    test('fails when the document/affkey is empty', () async {
      final container = ProviderContainer(
        overrides: [
          flavorConfigProvider.overrideWithValue(_flavor()),
          registrationRepositoryProvider.overrideWithValue(
            _FakeRegistrationRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.setField('email', 'a@b.com');
      await notifier.register();
      final state = container.read(registrationProvider);
      expect(state.status, RegistrationStatus.failure);
      expect(state.errorMessage, 'Document required');
    });

    test('fails when the address is empty but document is set', () async {
      final fake = _FakeRegistrationRepository();
      final container = ProviderContainer(
        overrides: [
          flavorConfigProvider.overrideWithValue(_flavor()),
          registrationRepositoryProvider.overrideWithValue(fake),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.setField('document', '12345');
      await notifier.register();
      final state = container.read(registrationProvider);
      expect(state.status, RegistrationStatus.failure);
      expect(state.errorMessage, 'Address required');
      // The repository must not have been called.
      expect(fake.lastFields, isNull);
    });
  });
}