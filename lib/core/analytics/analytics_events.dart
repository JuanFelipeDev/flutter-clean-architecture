/// Typed analytics event names. Centralized so callers don't pass magic
library;

class AnalyticsEvents {
  const AnalyticsEvents._();

  static const String loginSubmitted = 'login_submitted';
  static const String loginSuccess = 'login_success';
  static const String loginFailed = 'login_failed';
  static const String assistanceRequested = 'assistance_requested';
  static const String trackingOpened = 'tracking_opened';
  static const String chatOpened = 'chat_opened';
  static const String paymentStarted = 'payment_started';
  static const String surveySubmitted = 'survey_submitted';
}
