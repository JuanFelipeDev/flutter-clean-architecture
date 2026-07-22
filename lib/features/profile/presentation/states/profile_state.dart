library;

import '../../domain/entities/profile_entities.dart';

enum ProfileStatus { idle, loading, saving, success, failure }

class ProfileState {
  const ProfileState({
    this.profile,
    this.documentTypes = const [],
    this.companies = const [],
    this.status = ProfileStatus.idle,
    this.errorMessage,
  });

  final AffiliateProfile? profile;
  final List<DocumentType> documentTypes;
  final List<Company> companies;
  final ProfileStatus status;
  final String? errorMessage;

  ProfileState copyWith({
    AffiliateProfile? profile,
    List<DocumentType>? documentTypes,
    List<Company>? companies,
    ProfileStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      documentTypes: documentTypes ?? this.documentTypes,
      companies: companies ?? this.companies,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
