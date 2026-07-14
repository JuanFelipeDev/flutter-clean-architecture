import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/features/registration/data/models/registration_dtos.dart';
import 'package:affiliate_app/features/registration/domain/entities/registration_entities.dart';
import 'package:affiliate_app/features/registration/domain/repositories/registration_repository.dart';
import 'package:affiliate_app/features/registration/presentation/providers/registration_providers.dart';
import 'package:affiliate_app/features/registration/presentation/states/registration_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRegistrationRepository implements RegistrationRepository {
  _FakeRegistrationRepository({this.valid = true, this.success = true});

  final bool valid;
  final bool success;

  @override
  Future<Result<ValidateDocumentResult>> validateDocument({
    required String document,
    required AccountType accountType,
  }) async {
    return Success(ValidateDocumentResult(valid: valid, message: valid ? null : 'Invalid'));
  }

  @override
  Future<Result<RegisterResult>> register({
    required AccountType accountType,
    required Map<String, String> fields,
  }) async {
    return Success(
      RegisterResult(success: success, message: success ? null : 'Failed', cveAffiliate: 'aff-1'),
    );
  }
}

void main() {
  group('RegistrationMapper', () {
    test('maps a valid document response', () {
      const dto = ValidateDocumentDto(valid: true, cveAffiliate: 'aff-1');
      const mapper = RegistrationMapper();
      final result = mapper.toValidateResult(dto);
      expect(result.valid, isTrue);
      expect(result.existingCve, 'aff-1');
    });

    test('maps a successful registration', () {
      const dto = RegisterDto(success: true, cveAffiliate: 'aff-1');
      const mapper = RegistrationMapper();
      final result = mapper.toRegisterResult(dto);
      expect(result.success, isTrue);
      expect(result.cveAffiliate, 'aff-1');
    });
  });

  group('RegistrationNotifier', () {
    test('selects account type and advances to validateDocument', () async {
      final container = ProviderContainer(overrides: [
        registrationRepositoryProvider.overrideWithValue(_FakeRegistrationRepository()),
      ]);
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.selectAccountType(AccountType.guest);
      expect(container.read(registrationProvider).step, RegistrationStep.validateDocument);
      expect(container.read(registrationProvider).accountType, AccountType.guest);
    });

    test('validates document and advances to form on success', () async {
      final container = ProviderContainer(overrides: [
        registrationRepositoryProvider.overrideWithValue(_FakeRegistrationRepository(valid: true)),
      ]);
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.selectAccountType(AccountType.affiliate);
      notifier.setDocument('12345');
      await notifier.validateDocument();
      expect(container.read(registrationProvider).step, RegistrationStep.form);
    });

    test('registers successfully and reaches done', () async {
      final container = ProviderContainer(overrides: [
        registrationRepositoryProvider.overrideWithValue(_FakeRegistrationRepository(success: true)),
      ]);
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.selectAccountType(AccountType.affiliate);
      notifier.setDocument('12345');
      await notifier.validateDocument();
      notifier.setField('email', 'a@b.com');
      await notifier.register();
      final state = container.read(registrationProvider);
      expect(state.step, RegistrationStep.done);
      expect(state.status, RegistrationStatus.success);
      expect(state.cveAffiliate, 'aff-1');
    });

    test('fails when document is empty', () async {
      final container = ProviderContainer(overrides: [
        registrationRepositoryProvider.overrideWithValue(_FakeRegistrationRepository()),
      ]);
      addTearDown(container.dispose);

      final notifier = container.read(registrationProvider.notifier);
      notifier.selectAccountType(AccountType.affiliate);
      await notifier.validateDocument();
      expect(container.read(registrationProvider).status, RegistrationStatus.failure);
    });
  });
}