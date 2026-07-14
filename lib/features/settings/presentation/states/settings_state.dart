/// Settings UI state (AFILIADO `configurationapp/` + language + logout).
library;

import '../../domain/entities/settings_entities.dart';

enum SettingsStatus { idle, loading, success, failure }

class SettingsState {
  const SettingsState({
    this.configuration,
    this.languageCode,
    this.status = SettingsStatus.idle,
    this.errorMessage,
  });

  final AppConfiguration? configuration;
  final String? languageCode;
  final SettingsStatus status;
  final String? errorMessage;

  SettingsState copyWith({
    AppConfiguration? configuration,
    String? languageCode,
    SettingsStatus? status,
    String? errorMessage,
  }) {
    return SettingsState(
      configuration: configuration ?? this.configuration,
      languageCode: languageCode ?? this.languageCode,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}