library;

import '../../../../core/config/flavor_config.dart';

enum LoginStatus { idle, loading, requiresTwoFactor, success, failure }

class LoginState {
  const LoginState({
    required this.strategy,
    this.username = '',
    this.password = '',
    this.phone = '',
    this.name = '',
    this.nit = '',
    this.placa = '',
    this.dpi = '',
    this.twoFactorUserName,
    this.status = LoginStatus.idle,
    this.errorMessage,
  });

  final LoginStrategy strategy;
  final String username;
  final String password;
  final String phone;
  final String name;
  final String nit;
  final String placa;
  final String dpi;
  final String? twoFactorUserName;
  final LoginStatus status;
  final String? errorMessage;

  LoginState copyWith({
    LoginStrategy? strategy,
    String? username,
    String? password,
    String? phone,
    String? name,
    String? nit,
    String? placa,
    String? dpi,
    String? twoFactorUserName,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      strategy: strategy ?? this.strategy,
      username: username ?? this.username,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      nit: nit ?? this.nit,
      placa: placa ?? this.placa,
      dpi: dpi ?? this.dpi,
      twoFactorUserName: twoFactorUserName ?? this.twoFactorUserName,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
