/// `cltTimeLogoutApp`). Auto-logs-out after [timeout] of user inactivity,
/// dispatching a session-expired event. Full wiring lands in Phase 4.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';

typedef SessionExpiredCallback = void Function();

/// Watches global pointer activity and fires [onExpired] after [timeout].
class InactivityController {
  InactivityController({required this.timeout, required this.onExpired});

  final Duration timeout;
  final SessionExpiredCallback onExpired;

  Timer? _timer;
  bool _armed = false;

  void arm() {
    if (_armed) return;
    _armed = true;
    _reset();
  }

  void disarm() {
    _timer?.cancel();
    _timer = null;
    _armed = false;
  }

  /// Call from a top-level [Listener] on the app's pointer router.
  void onUserActivity() {
    if (_armed) _reset();
  }

  void _reset() {
    _timer?.cancel();
    _timer = Timer(timeout, () {
      _armed = false;
      onExpired();
    });
  }

  void dispose() => disarm();
}

/// Wraps the app so any pointer event resets the inactivity timer.
class InactivityListener extends StatelessWidget {
  const InactivityListener({
    required this.controller,
    required this.child,
    super.key,
  });

  final InactivityController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => controller.onUserActivity(),
      onPointerMove: (_) => controller.onUserActivity(),
      onPointerUp: (_) => controller.onUserActivity(),
      child: child,
    );
  }
}
