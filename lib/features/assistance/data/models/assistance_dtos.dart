/// DTOs + mappers for the assistance catalogs
/// `CreateAssistanceResponse`).
library;

import '../../domain/entities/assistance_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

class AccountDto {
  const AccountDto({this.id, this.name, this.number});
  final String? id;
  final String? name;
  final String? number;

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

  /// The services endpoint expects `fmId` as `idfamilia` (see ItemFamilyFragment ->
  /// ItemServiceFragment.getAffiliateServices), so prefer it over `pk`.
  factory FamilyDto.fromJson(Map<String, dynamic> json) => FamilyDto(
    id:
        json['fmId']?.toString() ??
        json['pk']?.toString() ??
        json['id']?.toString(),
    name:
        json['fmDescription']?.toString() ??
        json['family_name']?.toString() ??
        json['name']?.toString() ??
        json['familia']?.toString(),
  );
}

class ServiceDto {
  const ServiceDto({this.id, this.name, this.description, this.familyId});
  final String? id;
  final String? name;
  final String? description;
  final String? familyId;

  factory ServiceDto.fromJson(Map<String, dynamic> json) => ServiceDto(
    id:
        json['ssId']?.toString() ??
        json['spId']?.toString() ??
        json['id']?.toString(),
    name:
        json['spLabelForUser']?.toString() ??
        json['name']?.toString() ??
        json['servicio']?.toString() ??
        'Service ${json['spId'] ?? ''}',
    description:
        json['spConditionsDescription']?.toString() ??
        json['description']?.toString(),
    familyId: json['familyId']?.toString() ?? json['idfamilia']?.toString(),
  );
}

class CoverageQuestionDto {
  const CoverageQuestionDto({
    this.id,
    this.text,
    this.options = const <String>[],
  });
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
    id:
        json['id']?.toString() ??
        json['idAssistance']?.toString() ??
        json['ssid']?.toString(),
    serviceId: json['idService']?.toString(),
    status: json['status']?.toString(),
  );
}

class AssistanceMapper {
  const AssistanceMapper();

  Account toAccount(AccountDto dto) =>
      Account(id: dto.id ?? '', name: dto.name ?? '', number: dto.number);

  Plan toPlan(PlanDto dto) => Plan(
    id: dto.id ?? '',
    name: dto.name ?? '',
    description: dto.description,
  );

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
}

List<AccountDto> parseAccounts(dynamic body) =>
    parseJsonList(body, AccountDto.fromJson, 'response');
List<PlanDto> parsePlans(dynamic body) =>
    parseJsonList(body, PlanDto.fromJson, 'response');
List<FamilyDto> parseFamilies(dynamic body) =>
    parseJsonList(body, FamilyDto.fromJson, 'response');
List<ServiceDto> parseServices(dynamic body) =>
    parseJsonList(body, ServiceDto.fromJson, 'response');
List<CoverageQuestionDto> parseQuestions(dynamic body) =>
    parseJsonList(body, CoverageQuestionDto.fromJson, 'questions');
