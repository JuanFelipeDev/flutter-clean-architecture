/// Profile entities (AFILIADO `perfil/` `ClientProfile` / `PerfilDataResponse` /
/// `TypesDocumentResponse` / `CompaniesResponse`).
library;

/// Affiliate profile (AFILIADO `ClientProfile`).
class AffiliateProfile {
  const AffiliateProfile({
    required this.affKey,
    this.firstName,
    this.firstSurname,
    this.email,
    this.phone,
    this.documentTypeId,
    this.documentNumber,
    this.photoUrl,
    this.country,
  });
  final String affKey;
  final String? firstName;
  final String? firstSurname;
  final String? email;
  final String? phone;
  final String? documentTypeId;
  final String? documentNumber;
  final String? photoUrl;
  final String? country;
}

/// A document type for the profile form (AFILIADO `tipos_documentos` /
/// `soaang-catalogs/api/parameters/types/5/`).
class DocumentType {
  const DocumentType({required this.id, required this.name});
  final String id;
  final String name;
}

/// A company (AFILIADO `soaang-catalogs/api/companies/list-company-soa`).
class Company {
  const Company({required this.id, required this.name});
  final String id;
  final String name;
}

/// A password change request (AFILIADO `PassChangeBody`).
class PassChange {
  const PassChange({required this.oldPassword, required this.newPassword});
  final String oldPassword;
  final String newPassword;
}