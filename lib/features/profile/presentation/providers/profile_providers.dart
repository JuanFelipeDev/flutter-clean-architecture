/// Riverpod wiring for the profile feature. [ProfileNotifier] loads the
/// profile + document types + companies, saves edits, and changes the
/// password (AFILIADO `ProfileFragment` + `modificar_contrasena`).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/models/profile_dtos.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entities.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../states/profile_state.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    mapper: const ProfileMapper(),
  );
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(profileRepositoryProvider));
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.watch(profileRepositoryProvider));
});

final getDocumentTypesUseCaseProvider = Provider<GetDocumentTypesUseCase>((ref) {
  return GetDocumentTypesUseCase(ref.watch(profileRepositoryProvider));
});

final getCompaniesUseCaseProvider = Provider<GetCompaniesUseCase>((ref) {
  return GetCompaniesUseCase(ref.watch(profileRepositoryProvider));
});

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState(status: ProfileStatus.loading);

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  Future<void> load() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(status: ProfileStatus.failure, errorMessage: 'No session');
      return;
    }
    state = state.copyWith(status: ProfileStatus.loading, errorMessage: '');
    final profile = await ref.read(getProfileUseCaseProvider).call(affKey);
    final docTypes = await ref.read(getDocumentTypesUseCaseProvider).call();
    final companies = await ref.read(getCompaniesUseCaseProvider).call();

    state = state.copyWith(
      profile: profile.getOrNull(),
      documentTypes: docTypes.getOrNull() ?? const [],
      companies: companies.getOrNull() ?? const [],
      status: ProfileStatus.idle,
    );
  }

  /// Edits a profile field locally.
  void editField(String key, String value) {
    final current = state.profile;
    if (current == null) return;
    final updated = AffiliateProfile(
      affKey: current.affKey,
      firstName: key == 'firstName' ? value : current.firstName,
      firstSurname: key == 'firstSurname' ? value : current.firstSurname,
      email: key == 'email' ? value : current.email,
      phone: key == 'phone' ? value : current.phone,
      documentTypeId: key == 'documentTypeId' ? value : current.documentTypeId,
      documentNumber: key == 'documentNumber' ? value : current.documentNumber,
      photoUrl: current.photoUrl,
      country: current.country,
    );
    state = state.copyWith(profile: updated);
  }

  Future<void> save() async {
    final profile = state.profile;
    if (profile == null) return;
    state = state.copyWith(status: ProfileStatus.saving, errorMessage: '');
    final result = await ref.read(updateProfileUseCaseProvider).call(profile);
    result.fold(
      onSuccess: (updated) => state = state.copyWith(
        profile: updated,
        status: ProfileStatus.success,
      ),
      onFailure: (failure) => state = state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final affKey = _affKey;
    if (affKey == null) return;
    state = state.copyWith(status: ProfileStatus.saving, errorMessage: '');
    final result =
        await ref.read(changePasswordUseCaseProvider).call(affKey, PassChange(oldPassword: oldPassword, newPassword: newPassword));
    result.fold(
      onSuccess: (_) => state = state.copyWith(status: ProfileStatus.success),
      onFailure: (failure) => state = state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }
}

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);