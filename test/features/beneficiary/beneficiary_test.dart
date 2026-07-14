import 'dart:async';

import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/core/socket/socket_event.dart';
import 'package:affiliate_app/core/socket/socket_manager.dart';
import 'package:affiliate_app/core/socket/socket_providers.dart';
import 'package:affiliate_app/features/beneficiary/data/models/beneficiary_dtos.dart';
import 'package:affiliate_app/features/beneficiary/domain/entities/beneficiary_entities.dart';
import 'package:affiliate_app/features/beneficiary/domain/repositories/beneficiary_repository.dart';
import 'package:affiliate_app/features/beneficiary/presentation/providers/beneficiary_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements BeneficiaryRepository {
  List<Beneficiary> store = [];

  @override
  Future<Result<List<Beneficiary>>> list(String affKey) async => Success(List.of(store));
  @override
  Future<Result<Beneficiary>> detail(String affKey, String beneficiaryId) async =>
      const Success(Beneficiary(id: 'b1', name: 'Bob'));
  @override
  Future<Result<Beneficiary>> create(String affKey, Beneficiary beneficiary) async {
    final created = Beneficiary(id: 'new-${store.length}', name: beneficiary.name, relationship: beneficiary.relationship);
    store.add(created);
    return Success(created);
  }
  @override
  Future<Result<Beneficiary>> update(Beneficiary beneficiary) async {
    store = store.map((b) => b.id == beneficiary.id ? beneficiary : b).toList();
    return Success(beneficiary);
  }
  @override
  Future<Result<void>> delete(String beneficiaryId) async {
    store = store.where((b) => b.id != beneficiaryId).toList();
    return Result<void>.guard(() {});
  }
  @override
  Future<Result<List<Relationship>>> relationships() async =>
      const Success([Relationship(id: 'r1', name: 'Son'), Relationship(id: 'r2', name: 'Spouse')]);
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
  void dispose() => _controller.close();
}

void main() {
  const session = SessionData(accessToken: 'tok', affKey: 'aff-1');

  group('BeneficiaryMapper', () {
    const mapper = BeneficiaryMapper();
    test('round-trips entity <-> dto', () {
      const b = Beneficiary(id: '1', name: 'Bob', relationship: 'Son', documentNumber: '123');
      final back = mapper.toEntity(mapper.toDto(b));
      expect(back.name, 'Bob');
      expect(back.relationship, 'Son');
    });
    test('parses coordinates payload (state when tipo present)', () {
      final coords = mapper.parseCoordinates(<String, dynamic>{
        'idBeneficiario': 'b1', 'lat': 4.0, 'lng': -74.0, 'tipo': 'online',
      });
      expect(coords.beneficiaryId, 'b1');
      expect(coords.state, 'online');
      expect(coords.lat, 4.0);
    });
  });

  group('BeneficiaryNotifier', () {
    late _FakeSocketManager socket;
    late _FakeRepository repo;

    ProviderContainer makeContainer() {
      repo = _FakeRepository();
      socket = _FakeSocketManager();
      repo.store.add(const Beneficiary(id: 'b1', name: 'Bob'));
      return ProviderContainer(overrides: [
        cachedSessionProvider.overrideWith((_) => session),
        beneficiaryRepositoryProvider.overrideWithValue(repo),
        socketManagerProvider.overrideWithValue(socket),
      ]);
    }

    test('loads beneficiaries + relationships', () async {
      final container = makeContainer();
      addTearDown(() { container.dispose(); socket.dispose(); });
      final notifier = container.read(beneficiaryProvider.notifier);
      await notifier.load();
      final state = container.read(beneficiaryProvider);
      expect(state.beneficiaries, hasLength(1));
      expect(state.relationships, hasLength(2));
    });

    test('add creates and appends', () async {
      final container = makeContainer();
      addTearDown(() { container.dispose(); socket.dispose(); });
      final notifier = container.read(beneficiaryProvider.notifier);
      await notifier.load();
      await notifier.add(const Beneficiary(id: '', name: 'Ana', relationship: 'r1'));
      expect(container.read(beneficiaryProvider).beneficiaries, hasLength(2));
    });

    test('remove deletes from state', () async {
      final container = makeContainer();
      addTearDown(() { container.dispose(); socket.dispose(); });
      final notifier = container.read(beneficiaryProvider.notifier);
      await notifier.load();
      await notifier.remove('b1');
      expect(container.read(beneficiaryProvider).beneficiaries, isEmpty);
    });

    test('socket coordinates update state', () async {
      final container = makeContainer();
      addTearDown(() { container.dispose(); socket.dispose(); });
      final notifier = container.read(beneficiaryProvider.notifier);
      await notifier.load();
      socket.sink.add(const RawSocketEvent(
        channel: SocketChannel.beneficiary,
        type: null,
        payload: {'idBeneficiario': 'b1', 'lat': 1.1, 'lng': 2.2},
      ));
      await Future<void>.delayed(Duration.zero);
      final coords = container.read(beneficiaryProvider).coordinates['b1'];
      expect(coords, isNotNull);
      expect(coords!.lat, 1.1);
    });
  });
}