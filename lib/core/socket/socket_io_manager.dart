/// Real `socket_io_client` implementation of [SocketManager]. Manages one
/// socket per [SocketChannel] against the configured server, with built-in
/// exponential-backoff reconnection and a typed event stream. Mirrors
/// PRESTADOR's `SocketManager` (three sockets + backoff) and AFILIADO's
/// per-screen socket lifecycle.
library;

import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';

import '../config/app_constants.dart';
import '../config/flavor_config.dart';
import 'socket_event.dart';
import 'socket_manager.dart';

class SocketIoSocketManager implements SocketManager {
  SocketIoSocketManager(this._flavor);

  final FlavorConfig _flavor;
  final Map<SocketChannel, Socket> _sockets = {};
  final StreamController<SocketEvent> _events =
      StreamController<SocketEvent>.broadcast();

  @override
  Stream<SocketEvent> get events => _events.stream;

  /// Path per channel (AFILIADO `PATH_*`).
  String _pathFor(SocketChannel channel) {
    switch (channel) {
      case SocketChannel.coordinates:
        return SocketPaths.coordinates;
      case SocketChannel.publisher:
        return SocketPaths.publisher;
      case SocketChannel.affiliate:
      case SocketChannel.tracking:
      case SocketChannel.chat:
      case SocketChannel.beneficiary:
      case SocketChannel.security:
      case SocketChannel.videoCall:
        return SocketPaths.notifier;
    }
  }

  @override
  Future<void> connect(SocketChannel channel, {Map<String, String>? auth}) async {
    if (_sockets.containsKey(channel)) return;

    final socket = io(
      _flavor.urlSocket,
      OptionBuilder()
          .setPath(_pathFor(channel))
          .setTransports(['websocket'])
          .enableForceNew()
          .enableReconnection()
          .setExtraHeaders(auth ?? const <String, String>{})
          .build(),
    );

    socket.on('connect', (_) {});
    socket.on('disconnect', (_) {});
    socket.on('connect_error', (_) {});

    // Catch-all: emit raw payloads for feature layers to interpret.
    socket.onAny((event, data) {
      _emit(channel, event, data);
    });

    socket.connect();
    _sockets[channel] = socket;
  }

  void _emit(SocketChannel channel, String? event, dynamic data) {
    Map<String, dynamic> payload;
    if (data is Map) {
      payload = Map<String, dynamic>.from(data);
    } else if (data is String) {
      final decoded = jsonDecode(data);
      payload = decoded is Map ? Map<String, dynamic>.from(decoded) : <String, dynamic>{};
    } else {
      payload = <String, dynamic>{};
    }

    _events.add(RawSocketEvent(channel: channel, type: event, payload: payload));
  }

  @override
  Future<void> disconnect(SocketChannel channel) async {
    final socket = _sockets.remove(channel);
    if (socket != null) {
      socket.clearListeners();
      socket.disconnect();
    }
  }

  @override
  Future<void> disconnectAll() async {
    for (final channel in List<SocketChannel>.from(_sockets.keys)) {
      await disconnect(channel);
    }
  }

  void dispose() {
    disconnectAll();
    _events.close();
  }
}