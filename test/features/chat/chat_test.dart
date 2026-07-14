import 'dart:async';

import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/network/connectivity_service.dart';
import 'package:affiliate_app/core/network/dio_provider.dart';
import 'package:affiliate_app/core/socket/socket_event.dart';
import 'package:affiliate_app/core/socket/socket_manager.dart';
import 'package:affiliate_app/core/socket/socket_providers.dart';
import 'package:affiliate_app/core/storage/storage_providers.dart';
import 'package:affiliate_app/features/chat/data/models/chat_dtos.dart';
import 'package:affiliate_app/features/chat/domain/entities/chat_entities.dart';
import 'package:affiliate_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:affiliate_app/features/chat/presentation/providers/chat_providers.dart';
import 'package:drift/native.dart';
import 'package:affiliate_app/core/storage/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeChatRepository implements ChatRepository {
  List<String> sent = [];
  @override
  Future<Result<List<ChatMessage>>> history(String assistanceId, {int page = 1}) async =>
      const Success([ChatMessage(id: 'm1', assistanceId: 'a1', content: 'hi', username: 'prov', typeUser: 'prov')]);
  @override
  Future<Result<void>> send(String assistanceId, String content) async {
    sent.add(content);
    return Result<void>.guard(() {});
  }
  @override
  Future<Result<void>> flushOutbox(String assistanceId) async => Result<void>.guard(() {});
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

class _FakeConnectivity implements ConnectivityService {
  final StreamController<ConnectivityState> _controller =
      StreamController<ConnectivityState>.broadcast();
  @override
  ConnectivityState get current => ConnectivityState.online;
  @override
  Stream<ConnectivityState> get stream => _controller.stream;
  @override
  Future<bool> get isConnected async => true;
  void dispose() => _controller.close();
}

void main() {
  group('ChatMapper', () {
    const mapper = ChatMapper();
    test('maps a DTO and detects own message', () {
      final m = mapper.toEntity(const ChatMessageDto(
        id: '1', assistanceId: 'a1', content: 'x', username: 'me', typeUser: 'aff',
      ));
      expect(m.isOwn, isTrue);
    });
    test('parses an incoming socket payload, filtering own messages', () {
      final incoming = mapper.toEntityFromSocket(<String, dynamic>{
        '_id': '2', 'assistanceId': 'a1', 'msContent': 'hello', 'msTypeUser': 'prov',
      });
      expect(incoming, isNotNull);
      expect(incoming!.isOwn, isFalse);
      expect(mapper.toEntityFromSocket(<String, dynamic>{}), isNull);
    });
    test('builds a send body', () {
      expect(mapper.sendBody('a1', 'hi')['msContent'], 'hi');
    });
  });

  group('ChatNotifier', () {
    late _FakeChatRepository repo;
    late _FakeSocketManager socket;
    late _FakeConnectivity connectivity;
    late ProviderContainer container;

    setUp(() {
      repo = _FakeChatRepository();
      socket = _FakeSocketManager();
      connectivity = _FakeConnectivity();
      container = ProviderContainer(overrides: [
        chatRepositoryProvider.overrideWithValue(repo),
        socketManagerProvider.overrideWithValue(socket),
        connectivityProvider.overrideWithValue(connectivity),
        localDatabaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
      ]);
    });
    tearDown(() {
      container.dispose();
      socket.dispose();
      connectivity.dispose();
    });

    test('start loads history', () async {
      final notifier = container.read(chatProvider.notifier);
      await notifier.start('a1');
      final state = container.read(chatProvider);
      expect(state.messages, hasLength(1));
      expect(state.messages.first.content, 'hi');
    });

    test('appends an incoming socket message', () async {
      final notifier = container.read(chatProvider.notifier);
      await notifier.start('a1');
      socket.sink.add(const RawSocketEvent(
        channel: SocketChannel.chat,
        type: null,
        payload: {'_id': 's1', 'assistanceId': 'a1', 'msContent': 'yo', 'msTypeUser': 'prov'},
      ));
      await Future<void>.delayed(Duration.zero);
      expect(container.read(chatProvider).messages, hasLength(2));
    });

    test('sends optimistically and via the repository', () async {
      final notifier = container.read(chatProvider.notifier);
      await notifier.start('a1');
      await notifier.send('hello there');
      final state = container.read(chatProvider);
      expect(state.messages.any((m) => m.content == 'hello there'), isTrue);
      expect(repo.sent, contains('hello there'));
    });
  });
}