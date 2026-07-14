/// Chat entities (AFILIADO `MessageChat` / `HistoryChat`).
library;

/// One chat message between affiliate and provider (AFILIADO `MessageChat`).
/// `typeUser` is `"aff"` (sent by the affiliate) or `"prov"` (provider).
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.assistanceId,
    required this.content,
    required this.username,
    required this.typeUser,
    this.createdAt,
  });

  final String id;
  final String assistanceId;
  final String content;
  final String username;
  final String typeUser;
  final DateTime? createdAt;

  /// AFILIADO `ChatViewModel.onNewMessage` filters own messages
  /// (`msTypeUser == "aff"`).
  bool get isOwn => typeUser == 'aff';
}