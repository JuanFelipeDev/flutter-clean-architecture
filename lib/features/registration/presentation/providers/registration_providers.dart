/// Riverpod wiring for the registration feature.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/registration_remote_data_source.dart';
import '../../data/models/registration_dtos.dart';
import '../../data/repositories/registration_repository_impl.dart';
import '../../domain/entities/registration_entities.dart';
import '../../domain/repositories/registration_repository.dart';
import '../../domain/usecases/registration_usecases.dart';
import '../states/registration_state.dart';

final registrationRemoteDataSourceProvider = Provider<RegistrationRemoteDataSource>((ref) {
  return RegistrationRemoteDataSource(ref.watch(dioProvider));
});

final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  return RegistrationRepositoryImpl(
    remoteDataSource: ref.watch(registrationRemoteDataSourceProvider),
    mapper: const RegistrationMapper(),
  );
});

final validateDocumentUseCaseProvider = Provider<ValidateDocumentUseCase>((ref) {
  return ValidateDocumentUseCase(ref.watch(registrationRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(registrationRepositoryProvider));
});

class RegistrationNotifier extends Notifier<RegistrationState> {
  @override
  RegistrationState build() => const RegistrationState();

  void selectAccountType(AccountType type) {
    state = state.copyWith(accountType: type, step: RegistrationStep.validateDocument);
  }

  void setDocument(String document) {
    state = state.copyWith(document: document);
  }

  void setField(String key, String value) {
    final fields = Map<String, String>.from(state.fields)..[key] = value;
    state = state.copyWith(fields: fields, errorMessage: '');
  }

  Future<void> validateDocument() async {
    if (state.document.isEmpty) {
      state = state.copyWith(status: RegistrationStatus.failure, errorMessage: 'Document required');
      return;
    }
    state = state.copyWith(status: RegistrationStatus.loading, errorMessage: '');
    final result = await ref
        .read(validateDocumentUseCaseProvider)
        .call(document: state.document, accountType: state.accountType);

    result.fold(
      onSuccess: (validation) {
        if (validation.valid) {
          state = state.copyWith(
            step: RegistrationStep.form,
            status: RegistrationStatus.idle,
            errorMessage: '',
          );
        } else {
          state = state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: validation.message ?? 'Document not valid',
          );
        }
      },
      onFailure: (failure) {
        state = state.copyWith(status: RegistrationStatus.failure, errorMessage: failure.message);
      },
    );
  }

  Future<void> register() async {
    state = state.copyWith(status: RegistrationStatus.loading, errorMessage: '');
    final result = await ref
        .read(registerUseCaseProvider)
        .call(accountType: state.accountType, fields: state.fields);

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
        state = state.copyWith(status: RegistrationStatus.failure, errorMessage: failure.message);
      },
    );
  }

  void backTo(RegistrationStep step) {
    state = state.copyWith(step: step, status: RegistrationStatus.idle, errorMessage: '');
  }
}

final registrationProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(RegistrationNotifier.new);