/// Non-sensitive preferences (theme mode, locale, UI visibility flags from
library;

import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_constants.dart';

class PrefsService {
  PrefsService(this._prefs);

  final SharedPreferences _prefs;

  static Future<PrefsService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsService(prefs);
  }

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
  Future<void> remove(String key) => _prefs.remove(key);

  String? get locale => getString(PrefsKeys.locale);
  Future<void> setLocale(String tag) => setString(PrefsKeys.locale, tag);

  String? get themeMode => getString(PrefsKeys.themeMode);
  Future<void> setThemeMode(String mode) =>
      setString(PrefsKeys.themeMode, mode);

  bool get displayItemBeneficiaries =>
      getBool(PrefsKeys.displayItemBeneficiaries) ?? false;
  bool get displayItemVehicles =>
      getBool(PrefsKeys.displayItemVehicles) ?? false;
  bool get displayShoppingList =>
      getBool(PrefsKeys.displayShoppingList) ?? false;
  bool get displayItemProfile => getBool(PrefsKeys.displayItemProfile) ?? true;
}
