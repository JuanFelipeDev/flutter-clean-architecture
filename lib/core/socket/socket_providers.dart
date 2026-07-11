/// Riverpod providers for the socket manager. Phase 3 no-op; Phase 4 overrides
/// with the `socket_io_client` implementation.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'socket_manager.dart';

final socketManagerProvider = Provider<SocketManager>((ref) {
  final manager = NoopSocketManager();
  ref.onDispose(manager.disconnectAll);
  return manager;
});