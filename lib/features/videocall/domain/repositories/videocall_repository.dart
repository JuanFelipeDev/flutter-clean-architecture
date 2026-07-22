/// schedule endpoints).
library;

import '../../../../core/error/result.dart';
import '../entities/videocall_entities.dart';

abstract class VideoCallRepository {
  Future<Result<ScheduleAvailability>> checkSchedule(String assistanceId);

  /// `api/schedule/check_permission_recording/`).
  Future<Result<bool>> requestRecordingPermission();

  /// `api/schedule/update_permission_recording/`).
  Future<Result<void>> updateRecordingPermission(bool granted);

  Future<Result<void>> startRecording();

  Future<Result<void>> stopRecording();
}
