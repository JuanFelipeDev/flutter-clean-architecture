/// Connectivity observation. Wraps `connectivity_plus` and adds active
/// reachability semantics used by the offline-first logic (PRESTADOR
/// `NetworkUtils` — `isReachable`, `isLowConnection`, `shouldSaveInDb`).
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityState { online, offline }

/// Observable network state. Exposes a current value + a stream of changes.
abstract class ConnectivityService {
  ConnectivityState get current;
  Stream<ConnectivityState> get stream;

  /// True when the device currently has any usable transport.
  Future<bool> get isConnected;
}

class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl(this._connectivity) {
    _connectivity.onConnectivityChanged.listen(_apply);
  }

  final Connectivity _connectivity;
  ConnectivityState _current = ConnectivityState.offline;
  final StreamController<ConnectivityState> _controller =
      StreamController<ConnectivityState>.broadcast();

  @override
  ConnectivityState get current => _current;

  @override
  Stream<ConnectivityState> get stream => _controller.stream;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void _apply(List<ConnectivityResult> result) {
    final next = result.contains(ConnectivityResult.none)
        ? ConnectivityState.offline
        : ConnectivityState.online;
    if (next != _current) {
      _current = next;
      _controller.add(next);
    }
  }

  void dispose() => _controller.close();
}