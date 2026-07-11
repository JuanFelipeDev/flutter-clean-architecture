/// App-wide constants sourced from AFILIADO/PRESTADOR socket paths and
/// notification channels. Pure constants — no behavior.
library;

/// Socket.IO paths (AFILIADO `ConfigUtils` PATH_* / PRESTADOR `SocketManager`).
class SocketPaths {
  const SocketPaths();

  static const String notifier = '/soaang-notifier/wss/';
  static const String coordinates = '/soaang-coordinates/wss/';
  static const String publisher = '/soaang-publisher/wss/';

  /// Global publisher event name (AFILIADO `EVENT_GLOBAL`).
  static const String publisherEvent = 'soaang-application-alerts';
}

/// Notification channels (AFILIADO `NotificationPushServices`).
class NotificationChannels {
  const NotificationChannels();

  static const String general = 'CHANNEL_ID_FIREBASE';
  static const String chat = 'IMPORTANTES2';
  static const String security = 'SecurityChannel';
}

/// Shared HTTP headers injected by the network interceptors.
class HttpHeaders {
  const HttpHeaders();

  static const String authorization = 'Authorization';
  static const String acceptLanguage = 'Accept-Language';
  static const String clientId = 'client-id';
  static const String username = 'username';
}

/// Network grace period before an offline call is cancelled (PRESTADOR
/// `NETWORK_GRACE_PERIOD_MS`).
class NetworkLimits {
  const NetworkLimits();

  static const Duration defaultTimeout = Duration(seconds: 60);
  static const Duration questionnaireTimeout = Duration(minutes: 10);
  static const Duration videoCallTimeout = Duration(seconds: 40);
  static const Duration googleTimeout = Duration(seconds: 40);
  static const Duration offlineGracePeriod = Duration(seconds: 10);
}

/// Synthetic codes used by the error mapper (PRESTADOR `RetrofitUtils`).
class ApiCodes {
  const ApiCodes();

  static const int timeout = 9999;
  static const int noInternet = 900;
}

/// Secure storage keys (AFILIADO `EncryptedPreferences`).
class StorageKeys {
  const StorageKeys();

  static const String accessToken = 'TOKEN';
  static const String refreshToken = 'REFRESH_TOKEN';
  static const String loginData = 'login_data';
  static const String profileData = 'profile_data';
  static const String biometricEnabled = 'BIOMETRIC_ENABLED';
  static const String biometricData = 'BIOMETRIC_DATA';
  static const String biometricIv = 'BIOMETRIC_IV';
  static const String biometricUser = 'BIOMETRIC_USER';
  static const String biometricPassword = 'BIOMETRIC_PASSWORD';
  static const String environment = 'TYPE_ENVIROMENT';
  static const String language = 'LANGUAGE';
}

/// Shared (non-sensitive) preference keys.
class PrefsKeys {
  const PrefsKeys();

  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String displayItemBeneficiaries = 'displayItemBeneficiaries';
  static const String displayItemVehicles = 'displayItemVehicles';
  static const String displayShoppingList = 'displayShoppingList';
  static const String displayItemProfile = 'displayItemProfile';
}