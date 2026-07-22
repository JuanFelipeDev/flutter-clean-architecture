/// `VideoCallApi`).
library;

/// `api/schedule/check_quote/` -> `CallAvailabilityResponse`).
class ScheduleAvailability {
  const ScheduleAvailability({
    required this.allowed,
    this.message,
    this.requiresOtp,
  });
  final bool allowed;
  final String? message;
  final bool? requiresOtp;
}

enum RecordingStatus { idle, requesting, recording, stopped, denied }

/// `assistanceId`; Zoom uses a token).
class VideoCallSession {
  const VideoCallSession({
    required this.assistanceId,
    required this.sessionName,
    this.token,
    this.userName,
  });
  final String assistanceId;
  final String sessionName;
  final String? token;
  final String? userName;
}
