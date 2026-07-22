/// `ValidateDocumentAndPoliceActivity` + `RegisterActivity`).
library;

import '../../domain/entities/registration_entities.dart';

/// Registration steps. CVE validation is intentionally absent — the flow goes
/// straight to the form (AFILIADO goes to `RegisterActivity` directly for
/// non-ccife flavors). `selectType` is only the first step for flavors that
/// require an account-type choice (ccife); otherwise the flow starts at `form`.
enum RegistrationStep { selectType, form, done }

enum RegistrationStatus { idle, loading, success, failure }

class RegistrationState {
  const RegistrationState({
    this.step = RegistrationStep.form,
    this.accountType = AccountType.affiliate,
    this.fields = const <String, String>{},
    this.addressLat,
    this.addressLng,
    this.status = RegistrationStatus.idle,
    this.errorMessage,
    this.cveAffiliate,
  });

  final RegistrationStep step;
  final AccountType accountType;
  final Map<String, String> fields;
  /// Coordinates captured by the address map picker. The registration body
  /// only sends the `address` text (like AFILIADO's `CreateAccountAffiliate`);
  /// lat/lng are kept for future use.
  final double? addressLat;
  final double? addressLng;
  final RegistrationStatus status;
  final String? errorMessage;
  final String? cveAffiliate;

  RegistrationState copyWith({
    RegistrationStep? step,
    AccountType? accountType,
    Map<String, String>? fields,
    double? addressLat,
    double? addressLng,
    RegistrationStatus? status,
    String? errorMessage,
    String? cveAffiliate,
  }) {
    return RegistrationState(
      step: step ?? this.step,
      accountType: accountType ?? this.accountType,
      fields: fields ?? this.fields,
      addressLat: addressLat ?? this.addressLat,
      addressLng: addressLng ?? this.addressLng,
      status: status ?? this.status,
      errorMessage: errorMessage,
      cveAffiliate: cveAffiliate ?? this.cveAffiliate,
    );
  }
}