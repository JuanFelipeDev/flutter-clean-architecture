/// Video call screen — call controls + recording (AFILIADO `VideoCallScreen`).
/// The native video surface (`zoom_videosdk`) is a Phase 6 polish; this renders
/// the join/leave + audio/video/recording controls that drive the
/// [VideoCallNotifier] regardless of the underlying SDK.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/videocall_entities.dart';
import '../../domain/services/video_call_service.dart';
import '../providers/videocall_providers.dart';
import '../states/videocall_state.dart';

class VideoCallPage extends ConsumerStatefulWidget {
  const VideoCallPage({required this.assistanceId, this.sessionName, this.userName, super.key});
  final String assistanceId;
  final String? sessionName;
  final String? userName;

  @override
  ConsumerState<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends ConsumerState<VideoCallPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(videoCallProvider, _onChanged);
      ref.read(videoCallProvider.notifier).join(
            assistanceId: widget.assistanceId,
            sessionName: widget.sessionName ?? 'assist-${widget.assistanceId}',
            userName: widget.userName,
          );
    });
  }

  void _onChanged(VideoCallState? previous, VideoCallState next) {
    if (next.callStatus == CallStatus.error || next.errorMessage != null) {
      context.showToast(next.errorMessage ?? 'Call error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(videoCallProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Video call')),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.callStatus == CallStatus.joining,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: _Surface(status: state.callStatus, recording: state.recording),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.filled(
                      icon: Icon(state.audioEnabled ? Icons.mic : Icons.mic_off),
                      onPressed: state.callStatus == CallStatus.joined
                          ? () => ref.read(videoCallProvider.notifier).toggleAudio()
                          : null,
                    ),
                    IconButton.filled(
                      icon: Icon(state.videoEnabled ? Icons.videocam : Icons.videocam_off),
                      onPressed: state.callStatus == CallStatus.joined
                          ? () => ref.read(videoCallProvider.notifier).toggleVideo()
                          : null,
                    ),
                    IconButton.filled(
                      icon: Icon(state.recording == RecordingStatus.recording
                          ? Icons.stop_circle
                          : Icons.fiber_manual_record),
                      onPressed: state.callStatus == CallStatus.joined &&
                              state.recording != RecordingStatus.requesting
                          ? () => ref.read(videoCallProvider.notifier).toggleRecording()
                          : null,
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.call_end),
                      style: IconButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: state.callStatus == CallStatus.joined
                          ? () {
                              ref.read(videoCallProvider.notifier).leave();
                              context.pop();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.status, required this.recording});
  final CallStatus status;
  final RecordingStatus recording;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          status == CallStatus.joined ? Icons.videocam : Icons.videocam_off_outlined,
          size: 72,
        ),
        const SizedBox(height: 12),
        Text(status.name, style: Theme.of(context).textTheme.titleMedium),
        if (recording == RecordingStatus.recording) ...[
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
              SizedBox(width: 4),
              Text('Recording'),
            ],
          ),
        ],
      ],
    );
  }
}