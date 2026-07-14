/// DTOs + mappers for the assistance catalogs and Google Places
/// (AFILIADO `get-affiliate-*` responses, `obtener_preguntas_cobertura`,
/// `CreateAssistanceResponse`, `AutocompleteResponse`).
library;

import 'dart:convert';

import '../../domain/entities/assistance_entities.dart';

// -- Catalog DTOs ----------------------------------------------------------

class AccountDto {
  const AccountDto({this.id, this.name, this.number});
  final String? id;
  final String? name;
  final String? number;

  factory AccountDto.fromJson(Map<String, dynamic> json) => AccountDto(
        id: json['idaccount']?.toString() ?? json['id']?.toString(),
        name: json['name']?.toString() ?? json['numero_cuenta']?.toString(),
        number: json['numero_cuenta']?.toString(),
      );
}

class PlanDto {
  const PlanDto({this.id, this.name, this.description});
  final String? id;
  final String? name;
  final String? description;

  factory PlanDto.fromJson(Map<String, dynamic> json) => PlanDto(
        id: json['idplan']?.toString() ?? json['id']?.toString(),
        name: json['name']?.toString() ?? json['plan']?.toString(),
        description: json['description']?.toString(),
      );
}

class FamilyDto {
  const FamilyDto({this.id, this.name});
  final String? id;
  final String? name;
  factory FamilyDto.fromJson(Map<String, dynamic> json) => FamilyDto(
        id: json['idfamilia']?.toString() ?? json['id']?.toString(),
        name: json['name']?.toString() ?? json['familia']?.toString(),
      );
}

class ServiceDto {
  const ServiceDto({this.id, this.name, this.description, this.familyId});
  final String? id;
  final String? name;
  final String? description;
  final String? familyId;

  factory ServiceDto.fromJson(Map<String, dynamic> json) => ServiceDto(
        id: json['idService']?.toString() ?? json['id']?.toString() ?? json['ssid']?.toString(),
        name: json['name']?.toString() ?? json['servicio']?.toString(),
        description: json['description']?.toString(),
        familyId: json['idfamilia']?.toString(),
      );
}

class CoverageQuestionDto {
  const CoverageQuestionDto({this.id, this.text, this.options = const <String>[]});
  final String? id;
  final String? text;
  final List<String> options;

  factory CoverageQuestionDto.fromJson(Map<String, dynamic> json) {
    final opts = json['options'];
    return CoverageQuestionDto(
      id: json['id']?.toString() ?? json['idPregunta']?.toString(),
      text: json['pregunta']?.toString() ?? json['text']?.toString(),
      options: opts is List
          ? opts.map((e) => e.toString()).toList()
          : <String>[],
    );
  }
}

class AssistanceDto {
  const AssistanceDto({this.id, this.serviceId, this.status});
  final String? id;
  final String? serviceId;
  final String? status;

  factory AssistanceDto.fromJson(Map<String, dynamic> json) => AssistanceDto(
        id: json['id']?.toString() ?? json['idAssistance']?.toString() ?? json['ssid']?.toString(),
        serviceId: json['idService']?.toString(),
        status: json['status']?.toString(),
      );
}

// -- Places DTOs -----------------------------------------------------------

class PlaceSuggestionDto {
  const PlaceSuggestionDto({this.placeId, this.description});
  final String? placeId;
  final String? description;

  factory PlaceSuggestionDto.fromJson(Map<String, dynamic> json) => PlaceSuggestionDto(
        placeId: json['placeId']?.toString(),
        description: json['text']?.toString() ?? json['description']?.toString(),
      );
}

class PlaceLocationDto {
  const PlaceLocationDto({this.placeId, this.lat, this.lng, this.formattedAddress});
  final String? placeId;
  final double? lat;
  final double? lng;
  final String? formattedAddress;

  factory PlaceLocationDto.fromJson(Map<String, dynamic> json) {
    final rawLoc = json['location'];
    final Map<String, dynamic>? loc = rawLoc is Map ? Map<String, dynamic>.from(rawLoc) : null;
    final lat = loc?['latitude'] ?? loc?['lat'];
    final lng = loc?['longitude'] ?? loc?['lng'];
    return PlaceLocationDto(
      placeId: json['id']?.toString() ?? json['placeId']?.toString(),
      lat: lat is num ? lat.toDouble() : null,
      lng: lng is num ? lng.toDouble() : null,
      formattedAddress: json['formattedAddress']?.toString() ?? json['address']?.toString(),
    );
  }
}

// -- Mappers ---------------------------------------------------------------

class AssistanceMapper {
  const AssistanceMapper();

  Account toAccount(AccountDto dto) =>
      Account(id: dto.id ?? '', name: dto.name ?? '', number: dto.number);

  Plan toPlan(PlanDto dto) =>
      Plan(id: dto.id ?? '', name: dto.name ?? '', description: dto.description);

  ServiceFamily toFamily(FamilyDto dto) =>
      ServiceFamily(id: dto.id ?? '', name: dto.name ?? '');

  Service toService(ServiceDto dto) => Service(
        id: dto.id ?? '',
        name: dto.name ?? '',
        description: dto.description,
        familyId: dto.familyId,
      );

  CoverageQuestion toQuestion(CoverageQuestionDto dto) => CoverageQuestion(
        id: dto.id ?? '',
        text: dto.text ?? '',
        options: dto.options,
      );

  Assistance toAssistance(AssistanceDto dto) => Assistance(
        id: dto.id ?? '',
        serviceId: dto.serviceId ?? '',
        status: dto.status,
      );

  PlaceSuggestion toSuggestion(PlaceSuggestionDto dto) => PlaceSuggestion(
        placeId: dto.placeId ?? '',
        description: dto.description ?? '',
      );

  PlaceLocation toPlace(PlaceLocationDto dto) => PlaceLocation(
        placeId: dto.placeId ?? '',
        lat: dto.lat,
        lng: dto.lng,
        formattedAddress: dto.formattedAddress,
      );
}

// -- List parsing helpers --------------------------------------------------

List<T> _parseList<T>(
  dynamic body,
  T Function(Map<String, dynamic>) fromJson, [
  String? singleKey,
]) {
  List<Map<String, dynamic>> extract(List<dynamic> list) =>
      list.whereType<Map<dynamic, dynamic>>().map((e) => Map<String, dynamic>.from(e)).toList();

  if (body is List) {
    return extract(body).map(fromJson).toList();
  }
  if (body is Map<String, dynamic> && singleKey != null && body[singleKey] is List) {
    return extract(body[singleKey] as List).map(fromJson).toList();
  }
  return <T>[];
}

List<AccountDto> parseAccounts(dynamic body) => _parseList(body, AccountDto.fromJson, 'accounts');
List<PlanDto> parsePlans(dynamic body) => _parseList(body, PlanDto.fromJson, 'plans');
List<FamilyDto> parseFamilies(dynamic body) => _parseList(body, FamilyDto.fromJson, 'families');
List<ServiceDto> parseServices(dynamic body) => _parseList(body, ServiceDto.fromJson, 'services');
List<CoverageQuestionDto> parseQuestions(dynamic body) =>
    _parseList(body, CoverageQuestionDto.fromJson, 'questions');
List<PlaceSuggestionDto> parseSuggestions(dynamic body) =>
    _parseList(body, PlaceSuggestionDto.fromJson, 'suggestions');

T? parseSingle<T>(dynamic body, T Function(Map<String, dynamic>) fromJson) {
  if (body is Map<String, dynamic>) return fromJson(body);
  if (body is String) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return fromJson(decoded);
  }
  return null;
}