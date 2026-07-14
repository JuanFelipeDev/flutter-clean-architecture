/// Video call service seam for the native video SDK (AFILIADO Zoom Video SDK
/// `joinSession`/`leaveSession`). A real `zoom_videosdk`-backed implementation
/// lands once a compatible plugin + SDK credentials are provisioned; the
/// default [NoopVideoCallService] keeps the app building and the rest of the
/// feature (recording, schedule) testable.
library;

import '../entities/videocall_entities.dart';

enum CallStatus { idle, joining, joined, ended, error }

abstract class VideoCallService {
  Future<CallStatus> join(VideoCallSession session);
  Future<void> leave();
  Future<void> toggleAudio(bool enabled);
  Future<void> toggleVideo(bool enabled);
}

class NoopVideoCallService implements VideoCallService {
  @override
  Future<CallStatus> join(VideoCallSession session) async => CallStatus.joined;
  @override
  Future<void> leave() async {}
  @override
  Future<void> toggleAudio(bool enabled) async {}
  @override
  Future<void> toggleVideo(bool enabled) async {}
}