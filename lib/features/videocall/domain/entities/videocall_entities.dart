/// Video call entities (AFILIADO `VideoCallActivity`/`VideoCallViewModel` +
/// `VideoCallApi`).
library;

/// Schedule availability before starting a call (AFILIADO
/// `api/schedule/check_quote/` -> `CallAvailabilityResponse`).
class ScheduleAvailability {
  const ScheduleAvailability({required this.allowed, this.message, this.requiresOtp});
  final bool allowed;
  final String? message;
  final bool? requiresOtp;
}

/// Recording status (AFILIADO `recorder/v1/start` + `stop`).
enum RecordingStatus { idle, requesting, recording, stopped, denied }

/// The session to join (AFILIADO `VideoCallActivity` carries `nameChanel` +
/// `assistanceId`; Zoom uses a token).
class VideoCallSession {
  const VideoCallSession({required this.assistanceId, required this.sessionName, this.token, this.userName});
  final String assistanceId;
  final String sessionName;
  final String? token;
  final String? userName;
}