/// DTOs + mapper for tracking (AFILIADO `TrackingResponse`,
/// `list-afiliate-active-assistances` items).
library;

import '../../domain/entities/tracking_entities.dart';

class ActiveAssistanceDto {
  const ActiveAssistanceDto({this.id, this.serviceId, this.status, this.stage, this.providerName});

  final String? id;
  final String? serviceId;
  final String? status;
  final String? stage;
  final String? providerName;

  factory ActiveAssistanceDto.fromJson(Map<String, dynamic> json) => ActiveAssistanceDto(
        id: json['id']?.toString() ?? json['assistanceId']?.toString() ?? json['ssid']?.toString(),
        serviceId: json['idService']?.toString() ?? json['serviceId']?.toString(),
        status: json['status']?.toString(),
        stage: json['stage']?.toString() ?? json['nextStage_ssId']?.toString(),
        providerName: json['providerName']?.toString() ?? json['proveedor']?.toString(),
      );
}

class TrackingMapper {
  const TrackingMapper();

  ActiveAssistance toEntity(ActiveAssistanceDto dto) => ActiveAssistance(
        id: dto.id ?? '',
        serviceId: dto.serviceId ?? '',
        status: dto.status,
        stage: dto.stage,
        providerName: dto.providerName,
      );

  /// Parses a raw socket payload (AFILIADO `SocketTrackingEvents` JSON) into a
  /// typed [TrackingEventType] + assistance id.
  ({TrackingEventType type, String? assistanceId}) parseTrackingEvent(
    Map<String, dynamic> payload,
  ) {
    final type = TrackingEventType.fromName(
      payload['Type']?.toString() ?? payload['type']?.toString(),
    );
    final assistanceId =
        payload['assistance_id']?.toString() ?? payload['idasistencia']?.toString();
    return (type: type, assistanceId: assistanceId);
  }

  /// Parses a raw socket payload (AFILIADO `mSocketCoordinates` JSON) into
  /// [ProviderCoordinates], or null when the payload has no coordinates.
  ProviderCoordinates? parseCoordinates(
    String assistanceId,
    Map<String, dynamic> payload,
  ) {
    final lat = payload['lat'] ?? payload['latitude'];
    final lng = payload['lng'] ?? payload['longitude'];
    if (lat is num && lng is num) {
      return ProviderCoordinates(
        assistanceId: assistanceId,
        lat: lat.toDouble(),
        lng: lng.toDouble(),
      );
    }
    return null;
  }
}