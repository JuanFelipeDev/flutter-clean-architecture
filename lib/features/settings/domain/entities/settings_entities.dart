/// Settings entities (AFILIADO `configurationapp/` `ResponseApplicationSetting`
/// + language + logout).
library;

/// Per-client app configuration pulled from the backend (AFILIADO
/// `api-python/affiliate/application_settings/` / `configuraciones_app_afiliado/`).
class AppConfiguration {
  const AppConfiguration({
    this.primaryColor,
    this.accentColor,
    this.logoUrl,
    this.displayItemBeneficiaries = false,
    this.displayItemVehicles = false,
    this.displayShoppingList = false,
    this.displayItemProfile = true,
    this.maxInactivityMinutes,
  });
  final int? primaryColor;
  final int? accentColor;
  final String? logoUrl;
  final bool displayItemBeneficiaries;
  final bool displayItemVehicles;
  final bool displayShoppingList;
  final bool displayItemProfile;
  final int? maxInactivityMinutes;
}

/// A selectable language (AFILIADO `dialogs/language`).
class LanguageOption {
  const LanguageOption({required this.code, required this.name});
  final String code;
  final String name;
}