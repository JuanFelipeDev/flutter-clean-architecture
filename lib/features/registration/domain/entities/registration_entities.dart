/// Registration entities. Pure Dart.
///
/// `ValidateDocumentAndPoliceActivity` (document validation) + `RegisterActivity`
/// (form fields driven per flavor).
library;

enum AccountType { affiliate, guest }

/// `RegisterResponse`).
class RegisterResult {
  const RegisterResult({
    required this.success,
    this.message,
    this.cveAffiliate,
  });
  final bool success;
  final String? message;
  final String? cveAffiliate;
}
