/// DTOs + mappers for the assistance catalogs and Google Places
/// (AFILIADO `get-affiliate-*` responses, `obtener_preguntas_cobertura`,
/// `CreateAssistanceResponse`, `AutocompleteResponse`).
library;

import 'dart:convert';

import '../../domain/entities/assistance_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

// -- Catalog DTOs ----------------------------------------------------------

class AccountDto {
  const AccountDto({this.id, this.name, this.number});
  final String? id;
  final String? name;
  final String? number;

  /// AFILIADO: each response item is {account: {acId, acName, acPilotNumber, ...}, accountLogo: [...]}
  factory AccountDto.fromJson(Map<String, dynamic> json) {
    final account = json['account'] is Map
        ? Map<String, dynamic>.from(json['account'] as Map)
        : json;
    return AccountDto(
      id: account['acId']?.toString() ?? account['id']?.toString(),
      name: account['acName']?.toString() ?? account['name']?.toString(),
      number: account['acPilotNumber']?.toString(),
    );
  }
}

class PlanDto {
  const PlanDto({this.id, this.name, this.description});
  final String? id;
  final String? name;
  final String? description;

  /// AFILIADO: each response item is {plan: {plId, plName, plIsVip, plStatus, ...}, plan_logo: [...]}
  factory PlanDto.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] is Map
        ? Map<String, dynamic>.from(json['plan'] as Map)
        : json;
    return PlanDto(
      id: plan['plId']?.toString() ?? plan['id']?.toString(),
      name: plan['plName']?.toString() ?? plan['name']?.toString(),
      description: plan['plIsVip'] == true ? 'VIP' : null,
    );
  }
}

class FamilyDto {
  const FamilyDto({this.id, this.name});
  final String? id;
  final String? name;

  /// AFILIADO: GetAffiliateFamilyListDataResponse {pk, fmId, fmDescription, fpLogo}.
  /// The services endpoint expects `fmId` as `idfamilia` (see ItemFamilyFragment ->
  /// ItemServiceFragment.getAffiliateServices), so prefer it over `pk`.
  factory FamilyDto.fromJson(Map<String, dynamic> json) => FamilyDto(
        id: json['fmId']?.toString() ?? json['pk']?.toString() ?? json['id']?.toString(),
        name: json['fmDescription']?.toString() ?? json['family_name']?.toString() ??
            json['name']?.toString() ?? json['familia']?.toString(),
      );
}

class ServiceDto {
  const ServiceDto({this.id, this.name, this.description, this.familyId});
  final String? id;
  final String? name;
  final String? description;
  final String? familyId;

  /// AFILIADO: GetDataServicesResponse {spId, familyId, spLabelForUser, spConditionsDescription, ssId, ...}
  factory ServiceDto.fromJson(Map<String, dynamic> json) => ServiceDto(
        id: json['ssId']?.toString() ?? json['spId']?.toString() ?? json['id']?.toString(),
        name: json['spLabelForUser']?.toString() ?? json['name']?.toString() ??
            json['servicio']?.toString() ?? 'Service ${json['spId'] ?? ''}',
        description: json['spConditionsDescription']?.toString() ?? json['description']?.toString(),
        familyId: json['familyId']?.toString() ?? json['idfamilia']?.toString(),
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


List<AccountDto> parseAccounts(dynamic body) => parseJsonList(body, AccountDto.fromJson, 'response');
List<PlanDto> parsePlans(dynamic body) => parseJsonList(body, PlanDto.fromJson, 'response');
List<FamilyDto> parseFamilies(dynamic body) => parseJsonList(body, FamilyDto.fromJson, 'response');
List<ServiceDto> parseServices(dynamic body) => parseJsonList(body, ServiceDto.fromJson, 'response');
List<CoverageQuestionDto> parseQuestions(dynamic body) =>
    parseJsonList(body, CoverageQuestionDto.fromJson, 'questions');
List<PlaceSuggestionDto> parseSuggestions(dynamic body) =>
    parseJsonList(body, PlaceSuggestionDto.fromJson, 'suggestions');

T? parseSingle<T>(dynamic body, T Function(Map<String, dynamic>) fromJson) {
  if (body is Map<String, dynamic>) return fromJson(body);
  if (body is String) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return fromJson(decoded);
  }
  return null;
}