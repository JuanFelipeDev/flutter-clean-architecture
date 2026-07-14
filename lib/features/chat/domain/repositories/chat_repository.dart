/// Chat repository contract (AFILIADO `soaang-historic/api/messages/` history
/// + `soaang-notifier/chat-messages/` send).
library;

import '../../../../core/error/result.dart';
import '../entities/chat_entities.dart';

abstract class ChatRepository {
  /// Paginated history (AFILIADO `addInitialMessage`).
  Future<Result<List<ChatMessage>>> history(String assistanceId, {int page = 1});

  /// Sends a message. On network failure the message is enqueued in the offline
  /// outbox and flushed on reconnect (Flutter improvement).
  Future<Result<void>> send(String assistanceId, String content);

  /// Flushes pending outbox messages for [assistanceId].
  Future<Result<void>> flushOutbox(String assistanceId);
}