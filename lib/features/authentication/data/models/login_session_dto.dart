/// DTO for `soaang-users/api/token/` and `/twoFactorAuth/verify/`
/// (AFILIADO `LoginSession`).
library;

import 'dart:convert';

import '../../domain/entities/login_entities.dart';

class LoginSessionDto {
  const LoginSessionDto({
    this.access,
    this.refresh,
    this.userName,
    this.cltId,
    this.affKey,
    this.user,
  });

  final String? access;
  final String? refresh;
  final String? userName;
  final String? cltId;
  final String? affKey;
  final Map<String, dynamic>? user;

  factory LoginSessionDto.fromJson(Map<String, dynamic> json) {
    return LoginSessionDto(
      access: json['access']?.toString(),
      refresh: json['refresh']?.toString(),
      userName: json['userName']?.toString() ?? json['username']?.toString(),
      cltId: json['cltId']?.toString() ?? json['client_id']?.toString(),
      affKey: json['affKey']?.toString() ?? json['aff_key']?.toString(),
      user: json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : null,
    );
  }

  static LoginSessionDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>) return LoginSessionDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return LoginSessionDto.fromJson(decoded);
    }
    return null;
  }
}

class LoginSessionMapper {
  const LoginSessionMapper();

  LoginSession toEntity(LoginSessionDto dto) {
    final user = dto.user == null
        ? null
        : AffiliateUser(
            id: dto.user!['id']?.toString(),
            affKey: dto.user!['affKey']?.toString() ?? dto.affKey,
            userName: dto.user!['userName']?.toString() ?? dto.userName,
          );

    return LoginSession(
      accessToken: dto.access ?? '',
      refreshToken: dto.refresh,
      userName: dto.userName,
      clientId: dto.cltId,
      affKey: dto.affKey,
      user: user,
    );
  }
}