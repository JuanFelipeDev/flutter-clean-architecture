/// this central model is the single source of truth for realtime events.
/// Phase 4 wires `socket_io_client` behind [SocketManager].
library;

enum SocketChannel {
  affiliate,
  tracking,
  coordinates,
  chat,
  beneficiary,
  publisher,
  security,
  videoCall,
}

/// Discriminated realtime event payload.
sealed class SocketEvent {
  const SocketEvent({required this.channel});
  final SocketChannel channel;
}

final class TrackingEvent extends SocketEvent {
  const TrackingEvent({required this.type, required this.assistanceId})
    : super(channel: SocketChannel.tracking);
  final String type;
  final String assistanceId;
}

final class CoordinatesEvent extends SocketEvent {
  const CoordinatesEvent({
    required this.assistanceId,
    required this.lat,
    required this.lng,
  }) : super(channel: SocketChannel.coordinates);
  final String assistanceId;
  final double lat;
  final double lng;
}

final class ChatMessageEvent extends SocketEvent {
  const ChatMessageEvent({
    required this.assistanceId,
    required this.username,
    required this.content,
  }) : super(channel: SocketChannel.chat);
  final String assistanceId;
  final String username;
  final String content;
}

final class AffiliateNotificationEvent extends SocketEvent {
  const AffiliateNotificationEvent({required this.type, this.payload})
    : super(channel: SocketChannel.affiliate);
  final String type;
  final Map<String, dynamic>? payload;
}

final class SessionExpiredEvent extends SocketEvent {
  const SessionExpiredEvent() : super(channel: SocketChannel.security);
}

final class ForceUpdateEvent extends SocketEvent {
  const ForceUpdateEvent({required this.latestVersion})
    : super(channel: SocketChannel.publisher);
  final String latestVersion;
}

/// Raw, unparsed payload for channels whose schema is feature-specific
/// (chat/tracking/beneficiary). Feature layers subscribe to the event stream
/// and interpret the payload.
final class RawSocketEvent extends SocketEvent {
  const RawSocketEvent({
    required super.channel,
    required this.type,
    required this.payload,
  });
  final String? type;
  final Map<String, dynamic> payload;
}
