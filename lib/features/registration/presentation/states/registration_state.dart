/// Registration UI state (AFILIADO `SelectUserTypeActivity` +
/// `ValidateDocumentAndPoliceActivity` + `RegisterActivity`).
library;

import '../../domain/entities/registration_entities.dart';

enum RegistrationStep { selectType, validateDocument, form, done }
enum RegistrationStatus { idle, loading, success, failure }

class RegistrationState {
  const RegistrationState({
    this.step = RegistrationStep.selectType,
    this.accountType = AccountType.affiliate,
    this.document = '',
    this.fields = const <String, String>{},
    this.status = RegistrationStatus.idle,
    this.errorMessage,
    this.cveAffiliate,
  });

  final RegistrationStep step;
  final AccountType accountType;
  final String document;
  final Map<String, String> fields;
  final RegistrationStatus status;
  final String? errorMessage;
  final String? cveAffiliate;

  RegistrationState copyWith({
    RegistrationStep? step,
    AccountType? accountType,
    String? document,
    Map<String, String>? fields,
    RegistrationStatus? status,
    String? errorMessage,
    String? cveAffiliate,
  }) {
    return RegistrationState(
      step: step ?? this.step,
      accountType: accountType ?? this.accountType,
      document: document ?? this.document,
      fields: fields ?? this.fields,
      status: status ?? this.status,
      errorMessage: errorMessage,
      cveAffiliate: cveAffiliate ?? this.cveAffiliate,
    );
  }
}