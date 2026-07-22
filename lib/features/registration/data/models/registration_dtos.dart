/// `ResponseOfTheRegistrationForm` / `RegisterResponse`).
library;

import 'dart:convert';

import '../../domain/entities/registration_entities.dart';

class RegisterDto {
  const RegisterDto({this.success, this.message, this.cveAffiliate});
  final bool? success;
  final String? message;
  final String? cveAffiliate;

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      success: json['success'] is bool
          ? json['success'] as bool
          : json['status']?.toString() == 'ok' || json['id'] != null,
      message: json['message']?.toString() ?? json['detail']?.toString(),
      cveAffiliate:
          json['cve_affiliate']?.toString() ??
          json['cveAffiliate']?.toString() ??
          json['id']?.toString(),
    );
  }

  static RegisterDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>) return RegisterDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return RegisterDto.fromJson(decoded);
    }
    return null;
  }
}

class RegistrationMapper {
  const RegistrationMapper();

  RegisterResult toRegisterResult(RegisterDto dto) {
    return RegisterResult(
      success: dto.success ?? false,
      message: dto.message,
      cveAffiliate: dto.cveAffiliate,
    );
  }
}