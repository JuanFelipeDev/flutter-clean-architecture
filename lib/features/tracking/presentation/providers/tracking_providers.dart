/// Riverpod wiring for the tracking feature. The [TrackingNotifier] loads the
/// active-assistance list and subscribes to the [SocketManager] event stream,
/// `TrackingFragment`/`TrackingMapActivity` sockets).
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../../../core/socket/socket_event.dart';
import '../../../../core/socket/socket_providers.dart';
import '../../data/datasources/tracking_remote_data_source.dart';
import '../../data/models/tracking_dtos.dart';
import '../../data/repositories/tracking_repository_impl.dart';
import '../../domain/entities/tracking_entities.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../domain/usecases/tracking_usecases.dart';
import '../states/tracking_state.dart';

final trackingRemoteDataSourceProvider = Provider<TrackingRemoteDataSource>((
  ref,
) {
  return TrackingRemoteDataSource(ref.watch(dioProvider));
});

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepositoryImpl(
    remoteDataSource: ref.watch(trackingRemoteDataSourceProvider),
    mapper: const TrackingMapper(),
  );
});

final getActiveAssistancesUseCaseProvider =
    Provider<GetActiveAssistancesUseCase>((ref) {
      return GetActiveAssistancesUseCase(ref.watch(trackingRepositoryProvider));
    });

final confirmArrivalUseCaseProvider = Provider<ConfirmArrivalUseCase>((ref) {
  return ConfirmArrivalUseCase(ref.watch(trackingRepositoryProvider));
});

final confirmFinalUseCaseProvider = Provider<ConfirmFinalUseCase>((ref) {
  return ConfirmFinalUseCase(ref.watch(trackingRepositoryProvider));
});

final sendPanicUseCaseProvider = Provider<SendPanicUseCase>((ref) {
  return SendPanicUseCase(ref.watch(trackingRepositoryProvider));
});

class TrackingNotifier extends Notifier<TrackingState> {
  StreamSubscription<SocketEvent>? _subscription;

  @override
  TrackingState build() {
    ref.onDispose(() => _subscription?.cancel());
    return const TrackingState();
  }

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  /// Loads the active list and starts listening to socket events.
  Future<void> start() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(
        status: TrackingStatus.failure,
        errorMessage: 'No session',
      );
      return;
    }
    state = state.copyWith(status: TrackingStatus.loading, errorMessage: '');
    final result = await ref
        .read(getActiveAssistancesUseCaseProvider)
        .call(affKey);
    result.fold(
      onSuccess: (assistances) {
        state = state.copyWith(
          assistances: assistances,
          status: TrackingStatus.idle,
        );
        _connectSockets(affKey);
      },
      onFailure: (failure) => state = state.copyWith(
        status: TrackingStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  void _connectSockets(String affKey) {
    final socketManager = ref.read(socketManagerProvider);
    socketManager.connect(SocketChannel.tracking, auth: {'affkey': affKey});
    socketManager.connect(SocketChannel.coordinates, auth: {'affkey': affKey});

    const mapper = TrackingMapper();
    _subscription = socketManager.events.listen((event) {
      if (event is! RawSocketEvent) return;
      final payload = event.payload;

      switch (event.channel) {
        case SocketChannel.tracking:
          final parsed = mapper.parseTrackingEvent(payload);
          if (parsed.type == TrackingEventType.sessionExpired) {
            state = state.copyWith(lastEvent: parsed.type);
            return;
          }
          if (parsed.type != TrackingEventType.unknown) {
            state = state.copyWith(lastEvent: parsed.type);
          }
        case SocketChannel.coordinates:
          final assistanceId =
              payload['assistance_id']?.toString() ??
              payload['idasistencia']?.toString() ??
              payload['assistanceId']?.toString();
          if (assistanceId != null && assistanceId.isNotEmpty) {
            final coords = mapper.parseCoordinates(assistanceId, payload);
            if (coords != null) {
              final next = Map<String, ProviderCoordinates>.from(
                state.coordinates,
              );
              next[assistanceId] = coords;
              state = state.copyWith(coordinates: next);
            }
          }
        default:
          break;
      }
    });
  }

  Future<void> confirmArrival(String assistanceId) async {
    await ref.read(confirmArrivalUseCaseProvider).call(assistanceId);
  }

  Future<void> confirmFinal(String assistanceId) async {
    await ref.read(confirmFinalUseCaseProvider).call(assistanceId);
  }

  Future<void> panic(String assistanceId, double lat, double lng) async {
    await ref.read(sendPanicUseCaseProvider).call(assistanceId, lat, lng);
  }

  Future<void> refresh() async => start();
}

final trackingProvider = NotifierProvider<TrackingNotifier, TrackingState>(
  TrackingNotifier.new,
);
