/// Riverpod wiring for the video call feature. [VideoCallNotifier] checks
/// schedule, joins via the [VideoCallService] seam, and manages recording
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/videocall_remote_data_source.dart';
import '../../data/models/videocall_dtos.dart';
import '../../data/repositories/videocall_repository_impl.dart';
import '../../domain/entities/videocall_entities.dart';
import '../../domain/repositories/videocall_repository.dart';
import '../../domain/services/video_call_service.dart';
import '../../domain/usecases/videocall_usecases.dart';
import '../states/videocall_state.dart';

final videoCallRemoteDataSourceProvider = Provider<VideoCallRemoteDataSource>((
  ref,
) {
  return VideoCallRemoteDataSource(ref.watch(dioProvider));
});

final videoCallRepositoryProvider = Provider<VideoCallRepository>((ref) {
  return VideoCallRepositoryImpl(
    remoteDataSource: ref.watch(videoCallRemoteDataSourceProvider),
    mapper: const VideoCallMapper(),
  );
});

/// Phase 5 no-op seam; a real `zoom_videosdk`-backed service lands with the
/// native plugin + SDK credentials.
final videoCallServiceProvider = Provider<VideoCallService>((ref) {
  return NoopVideoCallService();
});

final checkScheduleUseCaseProvider = Provider<CheckScheduleUseCase>((ref) {
  return CheckScheduleUseCase(ref.watch(videoCallRepositoryProvider));
});

final startRecordingUseCaseProvider = Provider<StartRecordingUseCase>((ref) {
  return StartRecordingUseCase(ref.watch(videoCallRepositoryProvider));
});

final stopRecordingUseCaseProvider = Provider<StopRecordingUseCase>((ref) {
  return StopRecordingUseCase(ref.watch(videoCallRepositoryProvider));
});

final requestRecordingPermissionUseCaseProvider =
    Provider<RequestRecordingPermissionUseCase>((ref) {
      return RequestRecordingPermissionUseCase(
        ref.watch(videoCallRepositoryProvider),
      );
    });

class VideoCallNotifier extends Notifier<VideoCallState> {
  VideoCallSession? _session;

  @override
  VideoCallState build() => const VideoCallState();

  /// Joins a call for [assistanceId] after a schedule check.
  Future<void> join({
    required String assistanceId,
    required String sessionName,
    String? userName,
  }) async {
    state = state.copyWith(callStatus: CallStatus.joining, errorMessage: '');

    final schedule = await ref
        .read(checkScheduleUseCaseProvider)
        .call(assistanceId);
    final allowed = schedule.fold(
      onSuccess: (s) => s.allowed,
      onFailure: (_) => false,
    );
    if (!allowed) {
      final message = schedule.fold(
        onSuccess: (s) => s.message,
        onFailure: (_) => null,
      );
      state = state.copyWith(
        callStatus: CallStatus.error,
        errorMessage: message ?? 'Call not available now',
      );
      return;
    }

    _session = VideoCallSession(
      assistanceId: assistanceId,
      sessionName: sessionName,
      userName: userName,
    );
    final status = await ref.read(videoCallServiceProvider).join(_session!);
    state = state.copyWith(callStatus: status);
  }

  Future<void> leave() async {
    await ref.read(videoCallServiceProvider).leave();
    state = state.copyWith(callStatus: CallStatus.ended);
  }

  Future<void> toggleAudio() async {
    final next = !state.audioEnabled;
    await ref.read(videoCallServiceProvider).toggleAudio(next);
    state = state.copyWith(audioEnabled: next);
  }

  Future<void> toggleVideo() async {
    final next = !state.videoEnabled;
    await ref.read(videoCallServiceProvider).toggleVideo(next);
    state = state.copyWith(videoEnabled: next);
  }

  Future<void> toggleRecording() async {
    if (state.recording == RecordingStatus.recording) {
      state = state.copyWith(recording: RecordingStatus.requesting);
      final result = await ref.read(stopRecordingUseCaseProvider).call();
      result.fold(
        onSuccess: (_) =>
            state = state.copyWith(recording: RecordingStatus.stopped),
        onFailure: (failure) => state = state.copyWith(
          recording: RecordingStatus.recording,
          errorMessage: failure.message,
        ),
      );
    } else {
      final permission = await ref
          .read(requestRecordingPermissionUseCaseProvider)
          .call();
      final granted = permission.fold(
        onSuccess: (g) => g,
        onFailure: (_) => false,
      );
      if (!granted) {
        state = state.copyWith(recording: RecordingStatus.denied);
        return;
      }
      state = state.copyWith(recording: RecordingStatus.requesting);
      final result = await ref.read(startRecordingUseCaseProvider).call();
      result.fold(
        onSuccess: (_) =>
            state = state.copyWith(recording: RecordingStatus.recording),
        onFailure: (failure) => state = state.copyWith(
          recording: RecordingStatus.idle,
          errorMessage: failure.message,
        ),
      );
    }
  }
}

final videoCallProvider = NotifierProvider<VideoCallNotifier, VideoCallState>(
  VideoCallNotifier.new,
);
