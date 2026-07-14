/// DTOs + mappers for registration (AFILIADO `ValidateDocumentResponse`,
/// `ResponseOfTheRegistrationForm` / `RegisterResponse`).
library;

import 'dart:convert';

import '../../domain/entities/registration_entities.dart';

class ValidateDocumentDto {
  const ValidateDocumentDto({this.valid, this.message, this.cveAffiliate});
  final bool? valid;
  final String? message;
  final String? cveAffiliate;

  factory ValidateDocumentDto.fromJson(Map<String, dynamic> json) {
    return ValidateDocumentDto(
      valid: json['valid'] is bool
          ? json['valid'] as bool
          : json['success'] is bool
              ? json['success'] as bool
              : null,
      message: json['message']?.toString() ?? json['detail']?.toString(),
      cveAffiliate: json['cve_affiliate']?.toString() ?? json['cveAffiliate']?.toString(),
    );
  }

  static ValidateDocumentDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>) return ValidateDocumentDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return ValidateDocumentDto.fromJson(decoded);
    }
    return null;
  }
}

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
      cveAffiliate: json['cve_affiliate']?.toString() ??
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

  ValidateDocumentResult toValidateResult(ValidateDocumentDto dto) {
    return ValidateDocumentResult(
      valid: dto.valid ?? false,
      message: dto.message,
      existingCve: dto.cveAffiliate,
    );
  }

  RegisterResult toRegisterResult(RegisterDto dto) {
    return RegisterResult(
      success: dto.success ?? false,
      message: dto.message,
      cveAffiliate: dto.cveAffiliate,
    );
  }
}