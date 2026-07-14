/// Registration entities. Pure Dart.
///
/// Reproduces AFILIADO `SelectUserTypeActivity` (affiliate/guest) +
/// `ValidateDocumentAndPoliceActivity` (document validation) + `RegisterActivity`
/// (form fields driven per flavor).
library;

/// Account type the user is creating (AFILIADO `SelectUserTypeActivity`).
enum AccountType { affiliate, guest }

/// Result of validating the affiliate document/code (AFILIADO
/// `api-python/affiliate/document_validate/` / `validar_cve_cuenta/`).
class ValidateDocumentResult {
  const ValidateDocumentResult({required this.valid, this.message, this.existingCve});
  final bool valid;
  final String? message;
  final String? existingCve;
}

/// Result of the registration call (AFILIADO `ResponseOfTheRegistrationForm` /
/// `RegisterResponse`).
class RegisterResult {
  const RegisterResult({required this.success, this.message, this.cveAffiliate});
  final bool success;
  final String? message;
  final String? cveAffiliate;
}