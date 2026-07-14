import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/features/videocall/data/models/videocall_dtos.dart';
import 'package:affiliate_app/features/videocall/domain/entities/videocall_entities.dart';
import 'package:affiliate_app/features/videocall/domain/repositories/videocall_repository.dart';
import 'package:affiliate_app/features/videocall/domain/services/video_call_service.dart';
import 'package:affiliate_app/features/videocall/presentation/providers/videocall_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeVideoCallRepository implements VideoCallRepository {
  _FakeVideoCallRepository({this.allowed = true});
  final bool allowed;

  @override
  Future<Result<ScheduleAvailability>> checkSchedule(String assistanceId) async =>
      Success(ScheduleAvailability(allowed: allowed, message: allowed ? null : 'No quote'));
  @override
  Future<Result<bool>> requestRecordingPermission() async => const Success(true);
  @override
  Future<Result<void>> updateRecordingPermission(bool granted) async => Result<void>.guard(() {});
  @override
  Future<Result<void>> startRecording() async => Result<void>.guard(() {});
  @override
  Future<Result<void>> stopRecording() async => Result<void>.guard(() {});
}

class _JoinSpy implements VideoCallService {
  bool joined = false;
  bool left = false;
  @override
  Future<CallStatus> join(VideoCallSession session) async {
    joined = true;
    return CallStatus.joined;
  }
  @override
  Future<void> leave() async => left = true;
  @override
  Future<void> toggleAudio(bool enabled) async {}
  @override
  Future<void> toggleVideo(bool enabled) async {}
}

void main() {
  group('VideoCallMapper', () {
    const mapper = VideoCallMapper();
    test('maps allowed schedule', () {
      final e = mapper.toEntity(const ScheduleAvailabilityDto(allowed: true));
      expect(e.allowed, isTrue);
    });
    test('degrades to not allowed when missing', () {
      final e = mapper.toEntity(const ScheduleAvailabilityDto());
      expect(e.allowed, isFalse);
    });
  });

  group('VideoCallNotifier', () {
    test('join blocked by schedule sets error', () async {
      final container = ProviderContainer(overrides: [
        videoCallRepositoryProvider.overrideWithValue(_FakeVideoCallRepository(allowed: false)),
      ]);
      addTearDown(container.dispose);
      final notifier = container.read(videoCallProvider.notifier);
      await notifier.join(assistanceId: 'a1', sessionName: 's');
      expect(container.read(videoCallProvider).callStatus, CallStatus.error);
    });

    test('join proceeds when allowed and reaches joined', () async {
      final spy = _JoinSpy();
      final container = ProviderContainer(overrides: [
        videoCallRepositoryProvider.overrideWithValue(_FakeVideoCallRepository(allowed: true)),
        videoCallServiceProvider.overrideWithValue(spy),
      ]);
      addTearDown(container.dispose);
      final notifier = container.read(videoCallProvider.notifier);
      await notifier.join(assistanceId: 'a1', sessionName: 's', userName: 'u');
      expect(spy.joined, isTrue);
      expect(container.read(videoCallProvider).callStatus, CallStatus.joined);
    });

    test('toggleRecording starts then stops', () async {
      final container = ProviderContainer(overrides: [
        videoCallRepositoryProvider.overrideWithValue(_FakeVideoCallRepository(allowed: true)),
      ]);
      addTearDown(container.dispose);
      final notifier = container.read(videoCallProvider.notifier);
      await notifier.toggleRecording();
      expect(container.read(videoCallProvider).recording, RecordingStatus.recording);
      await notifier.toggleRecording();
      expect(container.read(videoCallProvider).recording, RecordingStatus.stopped);
    });

    test('leave sets ended', () async {
      final spy = _JoinSpy();
      final container = ProviderContainer(overrides: [
        videoCallRepositoryProvider.overrideWithValue(_FakeVideoCallRepository(allowed: true)),
        videoCallServiceProvider.overrideWithValue(spy),
      ]);
      addTearDown(container.dispose);
      final notifier = container.read(videoCallProvider.notifier);
      await notifier.join(assistanceId: 'a1', sessionName: 's');
      await notifier.leave();
      expect(container.read(videoCallProvider).callStatus, CallStatus.ended);
      expect(spy.left, isTrue);
    });
  });
}