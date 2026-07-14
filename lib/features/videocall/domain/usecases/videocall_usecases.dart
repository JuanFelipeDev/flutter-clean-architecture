/// Video call use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/videocall_entities.dart';
import '../repositories/videocall_repository.dart';

class CheckScheduleUseCase {
  CheckScheduleUseCase(this._repository);
  final VideoCallRepository _repository;
  Future<Result<ScheduleAvailability>> call(String assistanceId) =>
      _repository.checkSchedule(assistanceId);
}

class StartRecordingUseCase {
  StartRecordingUseCase(this._repository);
  final VideoCallRepository _repository;
  Future<Result<void>> call() => _repository.startRecording();
}

class StopRecordingUseCase {
  StopRecordingUseCase(this._repository);
  final VideoCallRepository _repository;
  Future<Result<void>> call() => _repository.stopRecording();
}

class RequestRecordingPermissionUseCase {
  RequestRecordingPermissionUseCase(this._repository);
  final VideoCallRepository _repository;
  Future<Result<bool>> call() => _repository.requestRecordingPermission();
}