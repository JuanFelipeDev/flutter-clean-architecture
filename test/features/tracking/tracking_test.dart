import 'dart:async';

import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/core/socket/socket_event.dart';
import 'package:affiliate_app/core/socket/socket_manager.dart';
import 'package:affiliate_app/core/socket/socket_providers.dart';
import 'package:affiliate_app/features/tracking/data/models/tracking_dtos.dart';
import 'package:affiliate_app/features/tracking/domain/entities/tracking_entities.dart';
import 'package:affiliate_app/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:affiliate_app/features/tracking/presentation/providers/tracking_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTrackingRepository implements TrackingRepository {
  @override
  Future<Result<List<ActiveAssistance>>> activeAssistances(String affKey) async =>
      const Success([ActiveAssistance(id: 'a1', serviceId: 's1', status: 'active')]);
  @override
  Future<Result<void>> confirmArrival(String assistanceId) async => Result<void>.guard(() {});
  @override
  Future<Result<void>> confirmFinal(String assistanceId) async => Result<void>.guard(() {});
  @override
  Future<Result<void>> sendPanic(String assistanceId, double lat, double lng) async =>
      Result<void>.guard(() {});
}

class _FakeSocketManager implements SocketManager {
  final StreamController<SocketEvent> _controller = StreamController<SocketEvent>.broadcast();
  StreamSink<SocketEvent> get sink => _controller.sink;

  @override
  Stream<SocketEvent> get events => _controller.stream;
  @override
  Future<void> connect(SocketChannel channel, {Map<String, String>? auth}) async {}
  @override
  Future<void> disconnect(SocketChannel channel) async {}
  @override
  Future<void> disconnectAll() async => _controller.close();
}

void main() {
  const session = SessionData(accessToken: 'tok', affKey: 'aff-1');

  group('TrackingMapper', () {
    const mapper = TrackingMapper();
    test('parses a tracking event by Type', () {
      final parsed = mapper.parseTrackingEvent(<String, dynamic>{'Type': 'arrival_request'});
      expect(parsed.type, TrackingEventType.arrivalRequest);
    });
    test('parses coordinates payload', () {
      final coords = mapper.parseCoordinates('a1', <String, dynamic>{'lat': 1.1, 'lng': 2.2});
      expect(coords, isNotNull);
      expect(coords!.lng, 2.2);
    });
    test('returns null when no coordinates', () {
      expect(mapper.parseCoordinates('a1', <String, dynamic>{}), isNull);
    });
  });

  group('TrackingNotifier', () {
    late _FakeSocketManager socket;

    ProviderContainer makeContainer() {
      socket = _FakeSocketManager();
      final container = ProviderContainer(overrides: [
        cachedSessionProvider.overrideWith((_) => session),
        trackingRepositoryProvider.overrideWithValue(_FakeTrackingRepository()),
        socketManagerProvider.overrideWithValue(socket),
      ]);
      return container;
    }

    test('loads active assistances on start', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(trackingProvider.notifier);
      await notifier.start();
      expect(container.read(trackingProvider).assistances, hasLength(1));
    });

    test('updates coordinates on a coordinates socket event', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(trackingProvider.notifier);
      await notifier.start();
      socket.sink.add(const RawSocketEvent(
        channel: SocketChannel.coordinates,
        type: null,
        payload: {'assistance_id': 'a1', 'lat': 4.5, 'lng': -74.0},
      ));
      // Give the broadcast stream a microtask to deliver.
      await Future<void>.delayed(Duration.zero);
      final coords = container.read(trackingProvider).coordinates['a1'];
      expect(coords, isNotNull);
      expect(coords!.lat, 4.5);
    });

    test('records last tracking event', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(trackingProvider.notifier);
      await notifier.start();
      socket.sink.add(const RawSocketEvent(
        channel: SocketChannel.tracking,
        type: null,
        payload: {'Type': 'monitoring'},
      ));
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(trackingProvider).lastEvent,
        TrackingEventType.monitoring,
      );
    });
  });
}