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
    this.mapsApiKey,
    this.user,
    this.twoFactorsAuth,
  });

  final String? access;
  final String? refresh;
  final String? userName;
  final String? cltId;
  final String? affKey;
  final String? mapsApiKey;
  final Map<String, dynamic>? user;
  final bool? twoFactorsAuth;

  factory LoginSessionDto.fromJson(Map<String, dynamic> json) {
    // AFILIADO: `affKey` and `userName` live INSIDE the `user` object, not at
    // the top level. `clientId` comes from `user.clients[0].cltId`.
    // UserLogin: @SerializedName("affKey") val affKey: String
    // UserLogin: @SerializedName("username") val userName: String?
    // UserLogin: @SerializedName("clients") val clients: List<ClientUser>?
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['user'] is Map ? Map<String, dynamic>.from(json['user'] as Map) : null);

    // affKey: prefer user.affKey (String, as AFILIADO uses it), fall back to
    // top-level affKey (List<String>) taking the first.
    String? affKey = user?['affKey']?.toString();
    if (affKey == null || affKey.isEmpty) {
      final rawTopAffKey = json['affKey'] ?? json['aff_key'];
      if (rawTopAffKey is List && rawTopAffKey.isNotEmpty) {
        affKey = rawTopAffKey.first?.toString();
      } else if (rawTopAffKey is String) {
        affKey = rawTopAffKey;
      }
    }

    // clientId: from user.clients[0].cltId (AFILIADO LoginActivity:633-634).
    String? cltId;
    String? mapsApiKey;
    final clients = user?['clients'];
    if (clients is List && clients.isNotEmpty) {
      final firstClient = clients.first;
      if (firstClient is Map) {
        cltId = firstClient['cltId']?.toString();
        // AFILIADO: ClientUser.cltInfoApiKey is the Google Maps key used for
        // Places/Geocoding at runtime (UserRepository stores it as the api key).
        mapsApiKey = firstClient['cltInfoApiKey']?.toString();
      }
    }
    cltId ??= json['cltId']?.toString() ?? json['client_id']?.toString();
    mapsApiKey ??= json['cltInfoApiKey']?.toString() ?? json['maps_api_key']?.toString();

    // userName: from user.username (AFILIADO UserLogin @SerializedName("username")).
    final userName = user?['username']?.toString() ??
        json['userName']?.toString() ??
        json['username']?.toString();

    // twoFactorsAuth: top-level field (AFILIADO LoginSession.twoFactorsAuth).
    final twoFactorsAuth = json['twoFactorsAuth'] is bool
        ? json['twoFactorsAuth'] as bool
        : (user?['two_factors_auth'] is bool
            ? user!['two_factors_auth'] as bool
            : null);

    return LoginSessionDto(
      access: json['access']?.toString(),
      refresh: json['refresh']?.toString(),
      userName: userName,
      cltId: cltId,
      affKey: affKey,
      mapsApiKey: mapsApiKey,
      user: user,
      twoFactorsAuth: twoFactorsAuth,
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
      mapsApiKey: dto.mapsApiKey,
      user: user,
      twoFactorsAuth: dto.twoFactorsAuth ?? false,
    );
  }
}