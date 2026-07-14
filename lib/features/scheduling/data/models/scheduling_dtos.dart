/// DTOs + mapper for scheduling (AFILIADO `obtener_franja_horario_servicio`,
/// `ResponseValidateScheduleAssistance`).
library;

import 'dart:convert';

import '../../domain/entities/scheduling_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

class TimeSlotDto {
  const TimeSlotDto({this.start, this.end, this.available});
  final String? start;
  final String? end;
  final bool? available;

  factory TimeSlotDto.fromJson(Map<String, dynamic> json) => TimeSlotDto(
        start: json['start']?.toString() ?? json['hora_inicio']?.toString(),
        end: json['end']?.toString() ?? json['hora_fin']?.toString(),
        available: json['available'] is bool ? json['available'] as bool : null,
      );
}

class ScheduleValidationDto {
  const ScheduleValidationDto({this.valid, this.message});
  final bool? valid;
  final String? message;

  factory ScheduleValidationDto.fromJson(Map<String, dynamic> json) => ScheduleValidationDto(
        valid: json['valid'] is bool
            ? json['valid'] as bool
            : json['status']?.toString() == 'ok',
        message: json['message']?.toString() ?? json['detail']?.toString(),
      );

  static ScheduleValidationDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>) return ScheduleValidationDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return ScheduleValidationDto.fromJson(decoded);
    }
    return null;
  }
}

class SchedulingMapper {
  const SchedulingMapper();

  TimeSlot toEntity(TimeSlotDto dto) => TimeSlot(
        start: dto.start ?? '',
        end: dto.end ?? '',
        available: dto.available ?? true,
      );

  ScheduleValidation toValidation(ScheduleValidationDto dto) => ScheduleValidation(
        valid: dto.valid ?? false,
        message: dto.message,
      );

  Map<String, dynamic> requestToBody(ScheduleRequest request) => {
        'serviceId': request.serviceId,
        'date': _formatDate(request.date),
        'start': request.slot.start,
        'end': request.slot.end,
        if (request.address != null) 'address': request.address,
      };

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

List<TimeSlotDto> parseSlots(dynamic body) =>
    parseJsonList(body, TimeSlotDto.fromJson, 'slots');