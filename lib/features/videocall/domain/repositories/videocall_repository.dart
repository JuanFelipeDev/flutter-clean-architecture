/// Video call repository contract (AFILIADO `VideoCallApi` recording +
/// schedule endpoints).
library;

import '../../../../core/error/result.dart';
import '../entities/videocall_entities.dart';

abstract class VideoCallRepository {
  /// Checks whether a call is allowed now (AFILIADO `api/schedule/check_quote/`).
  Future<Result<ScheduleAvailability>> checkSchedule(String assistanceId);

  /// Asks the backend for recording permission (AFILIADO
  /// `api/schedule/check_permission_recording/`).
  Future<Result<bool>> requestRecordingPermission();

  /// Updates the user's recording consent (AFILIADO
  /// `api/schedule/update_permission_recording/`).
  Future<Result<void>> updateRecordingPermission(bool granted);

  /// Starts the recording (AFILIADO `recorder/v1/start/`).
  Future<Result<void>> startRecording();

  /// Stops the recording (AFILIADO `recorder/v1/stop/`).
  Future<Result<void>> stopRecording();
}