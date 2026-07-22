/// `RecordingPermissionVerificationResponse`).
library;

import 'dart:convert';

import '../../domain/entities/videocall_entities.dart';

class ScheduleAvailabilityDto {
  const ScheduleAvailabilityDto({this.allowed, this.message, this.requiresOtp});
  final bool? allowed;
  final String? message;
  final bool? requiresOtp;

  factory ScheduleAvailabilityDto.fromJson(Map<String, dynamic> json) =>
      ScheduleAvailabilityDto(
        allowed: json['allowed'] is bool
            ? json['allowed'] as bool
            : json['status']?.toString() == 'ok',
        message: json['message']?.toString() ?? json['detail']?.toString(),
        requiresOtp: json['requires_otp'] is bool
            ? json['requires_otp'] as bool
            : null,
      );

  static ScheduleAvailabilityDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>)
      return ScheduleAvailabilityDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>)
        return ScheduleAvailabilityDto.fromJson(decoded);
    }
    return null;
  }
}

class VideoCallMapper {
  const VideoCallMapper();

  ScheduleAvailability toEntity(ScheduleAvailabilityDto dto) =>
      ScheduleAvailability(
        allowed: dto.allowed ?? false,
        message: dto.message,
        requiresOtp: dto.requiresOtp,
      );
}
