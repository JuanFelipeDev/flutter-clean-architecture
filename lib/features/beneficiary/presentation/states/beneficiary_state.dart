/// `MapsBeneficiariesActivity`).
library;

import '../../domain/entities/beneficiary_entities.dart';

enum BeneficiaryStatus { idle, loading, saving, failure }

class BeneficiaryState {
  const BeneficiaryState({
    this.beneficiaries = const [],
    this.relationships = const [],
    this.coordinates = const {},
    this.selectedId,
    this.status = BeneficiaryStatus.idle,
    this.errorMessage,
  });

  final List<Beneficiary> beneficiaries;
  final List<Relationship> relationships;
  final Map<String, BeneficiaryCoordinate> coordinates;
  final String? selectedId;
  final BeneficiaryStatus status;
  final String? errorMessage;

  BeneficiaryState copyWith({
    List<Beneficiary>? beneficiaries,
    List<Relationship>? relationships,
    Map<String, BeneficiaryCoordinate>? coordinates,
    String? selectedId,
    BeneficiaryStatus? status,
    String? errorMessage,
  }) {
    return BeneficiaryState(
      beneficiaries: beneficiaries ?? this.beneficiaries,
      relationships: relationships ?? this.relationships,
      coordinates: coordinates ?? this.coordinates,
      selectedId: selectedId ?? this.selectedId,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
