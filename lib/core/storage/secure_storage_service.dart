/// Encrypted storage for sensitive data (JWT, session JSON, biometric creds).
/// Direct analog of AFILIADO's `EncryptedPreferences` + PRESTADOR's
/// `ProviderPreferences` (EncryptedSharedPreferences, AES256-GCM).
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_constants.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();

  // -- Typed convenience (session) ---------------------------------------

  Future<String?> accessToken() => read(StorageKeys.accessToken);

  Future<void> setAccessToken(String? token) async {
    if (token == null) {
      await delete(StorageKeys.accessToken);
    } else {
      await write(StorageKeys.accessToken, token);
    }
  }

  Future<String?> refreshToken() => read(StorageKeys.refreshToken);

  Future<void> setRefreshToken(String? token) async {
    if (token == null) {
      await delete(StorageKeys.refreshToken);
    } else {
      await write(StorageKeys.refreshToken, token);
    }
  }

  /// Serialized `LoginSession` JSON (AFILIADO `login_data`).
  Future<String?> loginData() => read(StorageKeys.loginData);
  Future<void> setLoginData(String? json) async {
    if (json == null) {
      await delete(StorageKeys.loginData);
    } else {
      await write(StorageKeys.loginData, json);
    }
  }

  /// Serialized `ClientProfile` JSON (AFILIADO `profile_data`).
  Future<String?> profileData() => read(StorageKeys.profileData);
  Future<void> setProfileData(String? json) async {
    if (json == null) {
      await delete(StorageKeys.profileData);
    } else {
      await write(StorageKeys.profileData, json);
    }
  }

  Future<bool> hasSession() async => (await accessToken()) != null;

  Future<void> clearSession() async {
    await delete(StorageKeys.accessToken);
    await delete(StorageKeys.refreshToken);
    await delete(StorageKeys.loginData);
    await delete(StorageKeys.profileData);
  }
}