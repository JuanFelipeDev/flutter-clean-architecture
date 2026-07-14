/// Video call UI state (AFILIADO `VideoCallViewModel`).
library;

import '../../domain/entities/videocall_entities.dart';
import '../../domain/services/video_call_service.dart';

class VideoCallState {
  const VideoCallState({
    this.callStatus = CallStatus.idle,
    this.recording = RecordingStatus.idle,
    this.audioEnabled = true,
    this.videoEnabled = true,
    this.errorMessage,
  });

  final CallStatus callStatus;
  final RecordingStatus recording;
  final bool audioEnabled;
  final bool videoEnabled;
  final String? errorMessage;

  VideoCallState copyWith({
    CallStatus? callStatus,
    RecordingStatus? recording,
    bool? audioEnabled,
    bool? videoEnabled,
    String? errorMessage,
  }) {
    return VideoCallState(
      callStatus: callStatus ?? this.callStatus,
      recording: recording ?? this.recording,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      errorMessage: errorMessage,
    );
  }
}