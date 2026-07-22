library;

import 'dart:convert';

import '../../domain/entities/settings_entities.dart';

class AppConfigurationDto {
  const AppConfigurationDto({
    this.primaryColor,
    this.accentColor,
    this.logoUrl,
    this.displayItemBeneficiaries,
    this.displayItemVehicles,
    this.displayShoppingList,
    this.displayItemProfile,
    this.maxInactivityMinutes,
  });

  final String? primaryColor;
  final String? accentColor;
  final String? logoUrl;
  final bool? displayItemBeneficiaries;
  final bool? displayItemVehicles;
  final bool? displayShoppingList;
  final bool? displayItemProfile;
  final int? maxInactivityMinutes;

  factory AppConfigurationDto.fromJson(Map<String, dynamic> json) =>
      AppConfigurationDto(
        primaryColor:
            json['primaryColor']?.toString() ??
            json['primary_color']?.toString(),
        accentColor:
            json['accentColor']?.toString() ?? json['accent_color']?.toString(),
        logoUrl: json['logo']?.toString() ?? json['LOGO']?.toString(),
        displayItemBeneficiaries: json['displayItemBeneficiaries'] is bool
            ? json['displayItemBeneficiaries'] as bool
            : null,
        displayItemVehicles: json['displayItemVehicles'] is bool
            ? json['displayItemVehicles'] as bool
            : null,
        displayShoppingList: json['displayShoppingList'] is bool
            ? json['displayShoppingList'] as bool
            : null,
        displayItemProfile: json['displayItemProfile'] is bool
            ? json['displayItemProfile'] as bool
            : null,
        maxInactivityMinutes: json['maxInactivityMinutes'] is int
            ? json['maxInactivityMinutes'] as int
            : null,
      );

  static AppConfigurationDto? tryParse(dynamic body) {
    if (body is Map<String, dynamic>) return AppConfigurationDto.fromJson(body);
    if (body is String) {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>)
        return AppConfigurationDto.fromJson(decoded);
    }
    return null;
  }
}

class SettingsMapper {
  const SettingsMapper();

  AppConfiguration toEntity(AppConfigurationDto dto) => AppConfiguration(
    primaryColor: _parseColor(dto.primaryColor),
    accentColor: _parseColor(dto.accentColor),
    logoUrl: dto.logoUrl,
    displayItemBeneficiaries: dto.displayItemBeneficiaries ?? false,
    displayItemVehicles: dto.displayItemVehicles ?? false,
    displayShoppingList: dto.displayShoppingList ?? false,
    displayItemProfile: dto.displayItemProfile ?? true,
    maxInactivityMinutes: dto.maxInactivityMinutes,
  );

  int? _parseColor(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    var cleaned = raw.replaceAll('#', '');
    if (!cleaned.startsWith('0x')) {
      if (cleaned.length == 6) cleaned = 'FF$cleaned';
      cleaned = '0x$cleaned';
    }
    return int.tryParse(cleaned);
  }
}
