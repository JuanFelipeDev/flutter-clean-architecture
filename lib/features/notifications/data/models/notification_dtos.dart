/// DTOs + mapper for notifications (AFILIADO `NotificationsResponse`).
library;

import '../../domain/entities/notification_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

class NotificationDto {
  const NotificationDto({this.id, this.type, this.message, this.assistanceId, this.createdAt, this.read});
  final String? id;
  final String? type;
  final String? message;
  final String? assistanceId;
  final String? createdAt;
  final bool? read;

  factory NotificationDto.fromJson(Map<String, dynamic> json) => NotificationDto(
        id: json['id']?.toString() ?? json['idNotificacion']?.toString(),
        type: json['type']?.toString() ?? json['tipo_msj']?.toString(),
        message: json['message']?.toString() ?? json['mensaje']?.toString(),
        assistanceId: json['assistanceId']?.toString() ?? json['idasistencia']?.toString(),
        createdAt: json['createdAt']?.toString() ?? json['fecha']?.toString(),
        read: json['read'] is bool ? json['read'] as bool : null,
      );
}

class NotificationsMapper {
  const NotificationsMapper();

  AffiliateNotification toEntity(NotificationDto dto) => AffiliateNotification(
        id: dto.id ?? '',
        type: NotificationType.fromName(dto.type),
        message: dto.message,
        assistanceId: dto.assistanceId,
        createdAt: _parseDate(dto.createdAt),
        read: dto.read ?? false,
      );

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

List<NotificationDto> parseNotifications(dynamic body) =>
    parseJsonList(body, NotificationDto.fromJson, 'notifications');