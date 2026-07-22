/// Riverpod wiring for the chat feature. [ChatNotifier] is an
/// [AutoDisposeNotifier] keyed to the current assistance id via [start] (only
/// one chat is open at a time from tracking). It loads the paginated history,
/// subscribes to the chat socket channel for incoming messages, sends via the
/// repository (with offline outbox fallback), and flushes the outbox when
/// connectivity is restored. AutoDispose cancels the socket subscriptions when
/// the chat screen leaves.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/socket/socket_event.dart';
import '../../../../core/socket/socket_providers.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/models/chat_dtos.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/chat_usecases.dart';
import '../states/chat_state.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(ref.watch(dioProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    remoteDataSource: ref.watch(chatRemoteDataSourceProvider),
    mapper: const ChatMapper(),
    database: ref.watch(localDatabaseProvider),
    connectivity: ref.watch(connectivityProvider),
  );
});

final getHistoryUseCaseProvider = Provider<GetHistoryUseCase>((ref) {
  return GetHistoryUseCase(ref.watch(chatRepositoryProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(chatRepositoryProvider));
});

class ChatNotifier extends Notifier<ChatState> {
  StreamSubscription<SocketEvent>? _socketSub;
  StreamSubscription<ConnectivityState>? _connectivitySub;
  String? _assistanceId;

  @override
  ChatState build() {
    ref.onDispose(() {
      _socketSub?.cancel();
      _connectivitySub?.cancel();
    });
    return const ChatState(status: ChatStatus.idle);
  }

  /// Binds the notifier to [assistanceId], loads history, and opens the chat
  /// socket + connectivity listeners.
  Future<void> start(String assistanceId) async {
    if (assistanceId.isEmpty) return;
    stop();
    _assistanceId = assistanceId;
    state = state.copyWith(messages: const [], status: ChatStatus.loading);

    final socketManager = ref.read(socketManagerProvider);
    await socketManager.connect(
      SocketChannel.chat,
      auth: {'assistanceId': assistanceId},
    );
    _socketSub = socketManager.events.listen((event) {
      if (event is! RawSocketEvent || event.channel != SocketChannel.chat)
        return;
      final message = const ChatMapper().toEntityFromSocket(event.payload);
      if (message != null &&
          message.assistanceId == assistanceId &&
          !message.isOwn) {
        state = state.copyWith(messages: [...state.messages, message]);
      }
    });

    final connectivity = ref.read(connectivityProvider);
    _connectivitySub = connectivity.stream.listen((c) {
      if (c == ConnectivityState.online) {
        ref.read(chatRepositoryProvider).flushOutbox(assistanceId);
      }
    });

    final result = await ref.read(getHistoryUseCaseProvider).call(assistanceId);
    result.fold(
      onSuccess: (messages) {
        state = state.copyWith(
          messages: _dedupe(messages),
          status: ChatStatus.idle,
        );
      },
      onFailure: (failure) => state = state.copyWith(
        status: ChatStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  /// Cancels socket + connectivity listeners (call when the chat screen
  /// leaves).
  void stop() {
    _socketSub?.cancel();
    _socketSub = null;
    _connectivitySub?.cancel();
    _connectivitySub = null;
    _assistanceId = null;
  }

  Future<void> send(String content) async {
    final assistanceId = _assistanceId;
    if (assistanceId == null || content.trim().isEmpty) return;
    final optimistic = ChatMessage(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      assistanceId: assistanceId,
      content: content,
      username: '',
      typeUser: 'aff',
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, optimistic],
      status: ChatStatus.sending,
    );

    final result = await ref
        .read(sendMessageUseCaseProvider)
        .call(assistanceId, content);
    result.fold(
      onSuccess: (_) => state = state.copyWith(status: ChatStatus.idle),
      onFailure: (failure) => state = state.copyWith(
        status: ChatStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  List<ChatMessage> _dedupe(List<ChatMessage> messages) {
    final seen = <String>{};
    return messages.where((m) => seen.add(m.id)).toList();
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
