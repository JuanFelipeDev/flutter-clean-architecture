/// Session data parsed from the persisted `login_data` JSON (AFILIADO
/// `LoginSession`). Holds what `core/` needs (interceptors, telemetry user id)
/// without pulling in the full auth feature models.
library;

import 'dart:convert';

import '../config/app_constants.dart';
import '../storage/secure_storage_service.dart';

class SessionData {
  const SessionData({
    required this.accessToken,
    this.refreshToken,
    this.clientId,
    this.username,
    this.affKey,
  });

  final String accessToken;
  final String? refreshToken;
  final String? clientId;
  final String? username;
  final String? affKey;

  bool get isEmpty => accessToken.isEmpty;

  Map<String, dynamic> toJson() => {
        'access': accessToken,
        if (refreshToken != null) 'refresh': refreshToken,
        if (clientId != null) 'client_id': clientId,
        if (username != null) 'username': username,
        if (affKey != null) 'aff_key': affKey,
      };

  static SessionData? fromJson(Map<String, dynamic> json) {
    final access = json['access'] as String?;
    if (access == null || access.isEmpty) return null;
    return SessionData(
      accessToken: access,
      refreshToken: json['refresh'] as String?,
      clientId: json['client_id']?.toString(),
      username: json['username'] as String?,
      affKey: json['aff_key']?.toString(),
    );
  }

  /// Loads + parses the persisted session from secure storage, or null.
  static Future<SessionData?> load(SecureStorageService storage) async {
    final raw = await storage.loginData();
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return SessionData.fromJson(decoded);
    return null;
  }

  /// Persists this session as JSON under [StorageKeys.loginData].
  Future<void> save(SecureStorageService storage) async {
    await storage.setLoginData(jsonEncode(toJson()));
    await storage.setAccessToken(accessToken);
    if (refreshToken != null) await storage.setRefreshToken(refreshToken);
  }
}