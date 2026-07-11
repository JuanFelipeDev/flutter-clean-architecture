/// Authentication entities. Pure Dart.
///
/// Reproduces AFILIADO `LoginSession` / `LoginActivity`:
/// - three login strategies (standard / EO / Roble), selected per flavor;
/// - 2FA hand-off when the token response carries no `user` but a `userName`.
library;

import '../../../../core/session/session_data.dart';

/// Minimal affiliate user from the login response (AFILIADO `user` object).
class AffiliateUser {
  const AffiliateUser({this.id, this.affKey, this.userName});
  final String? id;
  final String? affKey;
  final String? userName;
}

/// The resolved session after login (or 2FA verification).
class LoginSession {
  const LoginSession({
    required this.accessToken,
    this.refreshToken,
    this.userName,
    this.clientId,
    this.affKey,
    this.user,
  });

  final String accessToken;
  final String? refreshToken;
  final String? userName;
  final String? clientId;
  final String? affKey;
  final AffiliateUser? user;

  /// AFILIADO 2FA rule: response without `user` but with `userName` requires
  /// two-factor verification.
  bool get requiresTwoFactor {
    final name = userName;
    return user == null && name != null && name.isNotEmpty;
  }

  SessionData toSessionData() => SessionData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        clientId: clientId,
        username: userName,
        affKey: affKey,
      );
}

/// Per-strategy credentials submitted to the login endpoint.
sealed class LoginCredentials {
  const LoginCredentials();
}

class StandardCredentials extends LoginCredentials {
  const StandardCredentials(this.username, this.password);
  final String username;
  final String password;
}

class EoCredentials extends LoginCredentials {
  const EoCredentials(this.phone, this.name, this.password);
  final String phone;
  final String name;
  final String password;
}

/// Roble: NIT + placa + DPI, at least two filled (AFILIADO `completar_dos_campos`).
class RobleCredentials extends LoginCredentials {
  const RobleCredentials({this.nit, this.placa, this.dpi});
  final String? nit;
  final String? placa;
  final String? dpi;

  bool get isValid =>
      [nit, placa, dpi].where((v) => v != null && v.isNotEmpty).length >= 2;
}