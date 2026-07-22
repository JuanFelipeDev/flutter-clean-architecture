/// `TypesDocumentResponse` / `CompaniesResponse`).
library;

import 'dart:convert';

import '../../domain/entities/profile_entities.dart';

class AffiliateProfileDto {
  const AffiliateProfileDto({
    this.affKey,
    this.firstName,
    this.firstSurname,
    this.email,
    this.phone,
    this.documentTypeId,
    this.documentNumber,
    this.photoUrl,
    this.country,
  });

  final String? affKey;
  final String? firstName;
  final String? firstSurname;
  final String? email;
  final String? phone;
  final String? documentTypeId;
  final String? documentNumber;
  final String? photoUrl;
  final String? country;

  factory AffiliateProfileDto.fromJson(Map<String, dynamic> json) =>
      AffiliateProfileDto(
        affKey:
            json['affKey']?.toString() ??
            json['affkey']?.toString() ??
            json['cve_afiliado']?.toString(),
        firstName:
            json['affFirstName']?.toString() ??
            json['firstName']?.toString() ??
            json['nombre']?.toString(),
        firstSurname:
            json['affFirstSurname']?.toString() ??
            json['firstSurname']?.toString() ??
            json['apellido']?.toString(),
        email: json['email']?.toString() ?? json['correo']?.toString(),
        phone: json['phone']?.toString() ?? json['telefono']?.toString(),
        documentTypeId:
            json['documentTypeId']?.toString() ??
            json['id_tipo_documento']?.toString(),
        documentNumber:
            json['documentNumber']?.toString() ??
            json['numero_documento']?.toString(),
        photoUrl:
            json['photoUrl']?.toString() ?? json['foto_afiliado']?.toString(),
        country: json['country']?.toString() ?? json['pais']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'affKey': affKey,
    'affFirstName': firstName,
    'affFirstSurname': firstSurname,
    'email': email,
    'phone': phone,
    'documentTypeId': documentTypeId,
    'documentNumber': documentNumber,
    'photoUrl': photoUrl,
    'country': country,
  };
}

class DocumentTypeDto {
  const DocumentTypeDto({this.id, this.name});
  final String? id;
  final String? name;
  factory DocumentTypeDto.fromJson(Map<String, dynamic> json) =>
      DocumentTypeDto(
        id: json['id']?.toString() ?? json['idTipoDocumento']?.toString(),
        name:
            json['name']?.toString() ??
            json['tipoDocumento']?.toString() ??
            json['descripcion']?.toString(),
      );
}

class CompanyDto {
  const CompanyDto({this.id, this.name});
  final String? id;
  final String? name;
  factory CompanyDto.fromJson(Map<String, dynamic> json) => CompanyDto(
    id: json['id']?.toString() ?? json['idCompany']?.toString(),
    name:
        json['name']?.toString() ??
        json['companyName']?.toString() ??
        json['nombre']?.toString(),
  );
}

class ProfileMapper {
  const ProfileMapper();

  AffiliateProfile toEntity(AffiliateProfileDto dto) => AffiliateProfile(
    affKey: dto.affKey ?? '',
    firstName: dto.firstName,
    firstSurname: dto.firstSurname,
    email: dto.email,
    phone: dto.phone,
    documentTypeId: dto.documentTypeId,
    documentNumber: dto.documentNumber,
    photoUrl: dto.photoUrl,
    country: dto.country,
  );

  AffiliateProfileDto toDto(AffiliateProfile profile) => AffiliateProfileDto(
    affKey: profile.affKey,
    firstName: profile.firstName,
    firstSurname: profile.firstSurname,
    email: profile.email,
    phone: profile.phone,
    documentTypeId: profile.documentTypeId,
    documentNumber: profile.documentNumber,
    photoUrl: profile.photoUrl,
    country: profile.country,
  );

  DocumentType toDocumentType(DocumentTypeDto dto) =>
      DocumentType(id: dto.id ?? '', name: dto.name ?? '');
  Company toCompany(CompanyDto dto) =>
      Company(id: dto.id ?? '', name: dto.name ?? '');
}

T? _parseSingle<T>(dynamic body, T Function(Map<String, dynamic>) fromJson) {
  if (body is Map<String, dynamic>) return fromJson(body);
  if (body is String) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return fromJson(decoded);
  }
  return null;
}

List<T> _parseList<T>(
  dynamic body,
  T Function(Map<String, dynamic>) fromJson, [
  String? key,
]) {
  List<Map<String, dynamic>> extract(List<dynamic> l) => l
      .whereType<Map<dynamic, dynamic>>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
  if (body is List) return extract(body).map(fromJson).toList();
  if (body is Map<String, dynamic> && key != null && body[key] is List) {
    return extract(body[key] as List).map(fromJson).toList();
  }
  return <T>[];
}

AffiliateProfileDto? parseProfile(dynamic body) =>
    _parseSingle(body, AffiliateProfileDto.fromJson);
List<DocumentTypeDto> parseDocumentTypes(dynamic body) =>
    _parseList(body, DocumentTypeDto.fromJson, 'types');
List<CompanyDto> parseCompanies(dynamic body) =>
    _parseList(body, CompanyDto.fromJson, 'companies');
