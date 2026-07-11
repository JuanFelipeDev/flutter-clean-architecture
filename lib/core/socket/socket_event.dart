/// Typed Socket.IO events. AFILIADO/PRESTADOR scatter sockets across screens;
/// this central model is the single source of truth for realtime events.
/// Phase 4 wires `socket_io_client` behind [SocketManager].
library;

/// Socket channels (AFILIADO `REGEX_SOCKET_*` / PRESTADOR `SocketManager`).
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

/// Tracking lifecycle (AFILIADO `SocketTrackingEvents` types).
final class TrackingEvent extends SocketEvent {
  const TrackingEvent({required this.type, required this.assistanceId})
    : super(channel: SocketChannel.tracking);
  final String type; // e.g. monitoring, arrival_request, final_arrival, cancel_request
  final String assistanceId;
}

/// Live provider coordinates (AFILIADO `mSocketCoordinates`).
final class CoordinatesEvent extends SocketEvent {
  const CoordinatesEvent({required this.assistanceId, required this.lat, required this.lng})
    : super(channel: SocketChannel.coordinates);
  final String assistanceId;
  final double lat;
  final double lng;
}

/// Chat message (AFILIADO `ChatViewModel.onNewMessage`).
final class ChatMessageEvent extends SocketEvent {
  const ChatMessageEvent({required this.assistanceId, required this.username, required this.content})
    : super(channel: SocketChannel.chat);
  final String assistanceId;
  final String username;
  final String content;
}

/// Affiliate-channel notification (AFILIADO `BaseActivity.onNewMessage`).
final class AffiliateNotificationEvent extends SocketEvent {
  const AffiliateNotificationEvent({required this.type, this.payload})
    : super(channel: SocketChannel.affiliate);
  final String type;
  final Map<String, dynamic>? payload;
}

/// Session expired (AFILIADO `session_expired`).
final class SessionExpiredEvent extends SocketEvent {
  const SessionExpiredEvent() : super(channel: SocketChannel.security);
}

/// Force-update (AFILIADO publisher channel `onUpdateApp`).
final class ForceUpdateEvent extends SocketEvent {
  const ForceUpdateEvent({required this.latestVersion})
    : super(channel: SocketChannel.publisher);
  final String latestVersion;
}