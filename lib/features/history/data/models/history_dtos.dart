/// DTOs + mapper for history (AFILIADO `AssistanceHistoryResponse`).
library;

import '../../domain/entities/history_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

class HistoryItemDto {
  const HistoryItemDto({this.id, this.serviceId, this.serviceName, this.status, this.createdAt, this.address, this.providerName});
  final String? id;
  final String? serviceId;
  final String? serviceName;
  final String? status;
  final String? createdAt;
  final String? address;
  final String? providerName;

  factory HistoryItemDto.fromJson(Map<String, dynamic> json) => HistoryItemDto(
        id: json['id']?.toString() ?? json['ssid']?.toString() ?? json['idAssistance']?.toString(),
        serviceId: json['idService']?.toString() ?? json['serviceId']?.toString(),
        serviceName: json['serviceName']?.toString() ?? json['servicio']?.toString(),
        status: json['status']?.toString() ?? json['estado']?.toString(),
        createdAt: json['createdAt']?.toString() ?? json['fecha']?.toString(),
        address: json['address']?.toString() ?? json['direccion']?.toString(),
        providerName: json['providerName']?.toString() ?? json['proveedor']?.toString(),
      );
}

class HistoryMapper {
  const HistoryMapper();

  HistoryItem toEntity(HistoryItemDto dto) => HistoryItem(
        id: dto.id ?? '',
        serviceId: dto.serviceId ?? '',
        serviceName: dto.serviceName,
        status: dto.status,
        createdAt: _parseDate(dto.createdAt),
        address: dto.address,
        providerName: dto.providerName,
      );

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

List<HistoryItemDto> parseHistory(dynamic body) =>
    parseJsonList(body, HistoryItemDto.fromJson, 'assistances');