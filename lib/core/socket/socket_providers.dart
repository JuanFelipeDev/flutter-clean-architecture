/// Riverpod providers for the socket manager. Phase 4 wires the real
/// `socket_io_client` implementation.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_providers.dart';
import 'socket_io_manager.dart';
import 'socket_manager.dart';

final socketManagerProvider = Provider<SocketManager>((ref) {
  final flavor = ref.watch(flavorConfigProvider);
  final manager = SocketIoSocketManager(flavor);
  ref.onDispose(manager.dispose);
  return manager;
});
