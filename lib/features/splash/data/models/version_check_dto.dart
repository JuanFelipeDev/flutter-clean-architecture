/// DTO for `soaang-configurations-external/api/domain_user/info-version-app`
/// (AFILIADO `ResponseValidateUpdate`).
library;

import 'dart:convert';

class VersionCheckDto {
  const VersionCheckDto({
    this.vaVersion,
    this.vaTypeApp,
    this.vaDispositive,
    this.vaState,
  });

  final String? vaVersion;
  final String? vaTypeApp;
  final String? vaDispositive;
  final String? vaState;

  factory VersionCheckDto.fromJson(Map<String, dynamic> json) {
    return VersionCheckDto(
      vaVersion: json['vaVersion']?.toString(),
      vaTypeApp: json['vaTypeApp']?.toString(),
      vaDispositive: json['vaDispositive']?.toString(),
      vaState: json['vaState']?.toString(),
    );
  }

  static VersionCheckDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>) return VersionCheckDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return VersionCheckDto.fromJson(decoded);
    }
    return null;
  }
}