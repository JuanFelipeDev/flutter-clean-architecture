/// Central Socket.IO manager seam. Phase 4 implements this with
/// `socket_io_client`, managing the channels defined in [SocketChannel] with
/// exponential-backoff reconnection (PRESTADOR `SocketManager` parity).
library;

import 'dart:async';

import 'socket_event.dart';

abstract class SocketManager {
  /// Stream of typed events across all connected channels.
  Stream<SocketEvent> get events;

  Future<void> connect(SocketChannel channel, {Map<String, String>? auth});
  Future<void> disconnect(SocketChannel channel);
  Future<void> disconnectAll();
}

/// Phase 3 placeholder that emits nothing. Phase 4 replaces it.
class NoopSocketManager implements SocketManager {
  @override
  Stream<SocketEvent> get events => const Stream<SocketEvent>.empty();

  @override
  Future<void> connect(SocketChannel channel, {Map<String, dynamic>? auth}) async {}

  @override
  Future<void> disconnect(SocketChannel channel) async {}

  @override
  Future<void> disconnectAll() async {}
}