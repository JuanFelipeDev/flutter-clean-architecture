/// `BeneficiaryCoordinate` / `Relationship`).
library;

class Beneficiary {
  const Beneficiary({
    required this.id,
    required this.name,
    this.relationship,
    this.documentNumber,
    this.state,
  });
  final String id;
  final String name;
  final String? relationship;
  final String? documentNumber;
  final String? state;
}

class Relationship {
  const Relationship({required this.id, required this.name});
  final String id;
  final String name;
}

/// `SocketEvents`: `tipo` => state update, else coordinates).
class BeneficiaryCoordinate {
  const BeneficiaryCoordinate({
    required this.beneficiaryId,
    this.lat,
    this.lng,
    this.state,
  });
  final String beneficiaryId;
  final double? lat;
  final double? lng;
  final String? state;
}
