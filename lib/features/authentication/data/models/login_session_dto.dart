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
    this.twoFactorsAuth,
  });

  final String? access;
  final String? refresh;
  final String? userName;
  final String? cltId;
  final String? affKey;
  final Map<String, dynamic>? user;
  final bool? twoFactorsAuth;

  factory LoginSessionDto.fromJson(Map<String, dynamic> json) {
    // AFILIADO `LoginSession.affKey` is a List<String>; take the first as the
    // active affiliate key (the app operates on one affKey at a time).
    final rawAffKey = json['affKey'] ?? json['aff_key'];
    String? affKey;
    if (rawAffKey is List && rawAffKey.isNotEmpty) {
      affKey = rawAffKey.first?.toString();
    } else if (rawAffKey is String) {
      affKey = rawAffKey;
    }

    return LoginSessionDto(
      access: json['access']?.toString(),
      refresh: json['refresh']?.toString(),
      userName: json['userName']?.toString() ?? json['username']?.toString(),
      cltId: json['cltId']?.toString() ?? json['client_id']?.toString(),
      affKey: affKey,
      user: json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : null,
      twoFactorsAuth: json['twoFactorsAuth'] is bool ? json['twoFactorsAuth'] as bool : null,
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
      twoFactorsAuth: dto.twoFactorsAuth ?? false,
    );
  }
}