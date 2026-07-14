/// DTOs + mapper for beneficiary (AFILIADO `BeneficiariesResponse` /
/// `BeneficiaryCoordinate` / `RelationshipResponse`).
library;

import 'dart:convert';

import '../../domain/entities/beneficiary_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

class BeneficiaryDto {
  const BeneficiaryDto({this.id, this.name, this.relationship, this.documentNumber, this.state});
  final String? id;
  final String? name;
  final String? relationship;
  final String? documentNumber;
  final String? state;

  factory BeneficiaryDto.fromJson(Map<String, dynamic> json) {
    final first = json['affFirstName']?.toString() ?? '';
    final surname = json['affFirstSurname']?.toString() ?? '';
    final composed = '$first $surname'.trim();
    return BeneficiaryDto(
      id: json['id']?.toString() ?? json['idBeneficiario']?.toString(),
      name: json['name']?.toString() ?? json['nombre']?.toString() ?? composed,
      relationship: json['relationship']?.toString() ?? json['parentesco']?.toString(),
      documentNumber: json['documentNumber']?.toString() ?? json['numero_documento']?.toString(),
      state: json['state']?.toString() ?? json['estado']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'relationship': relationship,
        'documentNumber': documentNumber,
      };
}

class RelationshipDto {
  const RelationshipDto({this.id, this.name});
  final String? id;
  final String? name;
  factory RelationshipDto.fromJson(Map<String, dynamic> json) => RelationshipDto(
        id: json['id']?.toString() ?? json['idParentesco']?.toString(),
        name: json['name']?.toString() ?? json['parentesco']?.toString() ?? json['descripcion']?.toString(),
      );
}

class BeneficiaryMapper {
  const BeneficiaryMapper();

  Beneficiary toEntity(BeneficiaryDto dto) => Beneficiary(
        id: dto.id ?? '',
        name: dto.name ?? '',
        relationship: dto.relationship,
        documentNumber: dto.documentNumber,
        state: dto.state,
      );

  BeneficiaryDto toDto(Beneficiary beneficiary) => BeneficiaryDto(
        id: beneficiary.id,
        name: beneficiary.name,
        relationship: beneficiary.relationship,
        documentNumber: beneficiary.documentNumber,
      );

  Relationship toRelationship(RelationshipDto dto) =>
      Relationship(id: dto.id ?? '', name: dto.name ?? '');

  /// Parses a socket payload (AFILIADO `SocketEvents`): if `tipo` is present
  /// it's a state update; otherwise it's coordinates.
  BeneficiaryCoordinate parseCoordinates(Map<String, dynamic> payload) {
    final lat = payload['lat'] ?? payload['latitude'];
    final lng = payload['lng'] ?? payload['longitude'];
    return BeneficiaryCoordinate(
      beneficiaryId: payload['idBeneficiario']?.toString() ??
          payload['beneficiaryId']?.toString() ??
          payload['idbeneficiario']?.toString() ??
          '',
      lat: lat is num ? lat.toDouble() : null,
      lng: lng is num ? lng.toDouble() : null,
      state: payload['tipo']?.toString() ?? payload['state']?.toString(),
    );
  }
}


T? _single<T>(dynamic body, T Function(Map<String, dynamic>) fromJson) {
  if (body is Map<String, dynamic>) return fromJson(body);
  if (body is String) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return fromJson(decoded);
  }
  return null;
}

List<BeneficiaryDto> parseBeneficiaries(dynamic body) =>
    parseJsonList(body, BeneficiaryDto.fromJson, 'beneficiaries');
List<RelationshipDto> parseRelationships(dynamic body) =>
    parseJsonList(body, RelationshipDto.fromJson, 'parentescos');
BeneficiaryDto? parseBeneficiary(dynamic body) => _single(body, BeneficiaryDto.fromJson);