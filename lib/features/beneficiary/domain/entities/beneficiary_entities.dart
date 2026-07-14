/// Beneficiary entities (AFILIADO `beneficiary/` `Beneficiary` /
/// `BeneficiaryCoordinate` / `Relationship`).
library;

/// A beneficiary tied to the affiliate (AFILIADO `Beneficiary`).
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

/// A relationship type for the beneficiary form (AFILIADO `obtener_parentescos`).
class Relationship {
  const Relationship({required this.id, required this.name});
  final String id;
  final String name;
}

/// Live beneficiary coordinates + state (AFILIADO `BeneficiaryCoordinate` /
/// `SocketEvents`: `tipo` => state update, else coordinates).
class BeneficiaryCoordinate {
  const BeneficiaryCoordinate({required this.beneficiaryId, this.lat, this.lng, this.state});
  final String beneficiaryId;
  final double? lat;
  final double? lng;
  final String? state;
}