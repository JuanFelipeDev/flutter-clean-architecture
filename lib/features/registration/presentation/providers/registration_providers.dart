/// Riverpod wiring for the registration feature.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/config_providers.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/registration_remote_data_source.dart';
import '../../data/models/registration_dtos.dart';
import '../../data/repositories/registration_repository_impl.dart';
import '../../domain/entities/registration_entities.dart';
import '../../domain/repositories/registration_repository.dart';
import '../../domain/usecases/registration_usecases.dart';
import '../states/registration_state.dart';

final registrationRemoteDataSourceProvider =
    Provider<RegistrationRemoteDataSource>((ref) {
      return RegistrationRemoteDataSource(ref.watch(dioProvider));
    });

final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  return RegistrationRepositoryImpl(
    remoteDataSource: ref.watch(registrationRemoteDataSourceProvider),
    mapper: const RegistrationMapper(),
  );
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(registrationRepositoryProvider));
});

class RegistrationNotifier extends Notifier<RegistrationState> {
  @override
  RegistrationState build() {
    final flavor = ref.watch(flavorConfigProvider);
    return RegistrationState(
      step: flavor.requiresAccountTypeSelection
          ? RegistrationStep.selectType
          : RegistrationStep.form,
    );
  }

  void selectAccountType(AccountType type) {
    state = state.copyWith(
      accountType: type,
      step: RegistrationStep.form,
    );
  }

  void setField(String key, String value) {
    final fields = Map<String, String>.from(state.fields)..[key] = value;
    state = state.copyWith(fields: fields, errorMessage: '');
  }

  /// Address resolved by the map picker: stores the street text in
  /// `fields['address']` and the coordinates in state.
  void setAddress(String address, double lat, double lng) {
    final fields = Map<String, String>.from(state.fields)
      ..['address'] = address;
    state = state.copyWith(fields: fields, addressLat: lat, addressLng: lng);
  }

  /// Resolves the affiliate key (CVE / document) from the form fields.
  /// Flavors use `document` (basenewsoa) or `nit` (roble / masservicios) as
  /// their document field.
  String? _affkeyFromFields(Map<String, String> fields) {
    final document = fields['document']?.trim();
    if (document != null && document.isNotEmpty) return document;
    final nit = fields['nit']?.trim();
    if (nit != null && nit.isNotEmpty) return nit;
    return null;
  }

  Future<void> register() async {
    final affkey = _affkeyFromFields(state.fields);
    if (affkey == null) {
      state = state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: 'Document required',
      );
      return;
    }
    final flavor = ref.read(flavorConfigProvider);
    // The address field is only required for flavors that request it.
    final needsAddress = flavor.registerFields.contains('address');
    if (needsAddress && (state.fields['address'] ?? '').trim().isEmpty) {
      state = state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: 'Address required',
      );
      return;
    }
    // `confirmPassword` is validation-only; never send it to the backend.
    final bodyFields = Map<String, String>.from(state.fields)
      ..remove('confirmPassword');
    final clientId = flavor.clientId;
    state = state.copyWith(
      status: RegistrationStatus.loading,
      errorMessage: '',
    );
    final result = await ref
        .read(registerUseCaseProvider)
        .call(affkey: affkey, fields: bodyFields, clientId: clientId);

    result.fold(
      onSuccess: (registration) {
        if (registration.success) {
          state = state.copyWith(
            step: RegistrationStep.done,
            status: RegistrationStatus.success,
            cveAffiliate: registration.cveAffiliate,
          );
        } else {
          state = state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: registration.message ?? 'Registration failed',
          );
        }
      },
      onFailure: (failure) {
        state = state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: failure.message,
        );
      },
    );
  }

  void backTo(RegistrationStep step) {
    state = state.copyWith(
      step: step,
      status: RegistrationStatus.idle,
      errorMessage: '',
    );
  }
}

final registrationProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(
      RegistrationNotifier.new,
    );