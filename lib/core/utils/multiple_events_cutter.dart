/// `MultipleEventsCutter`).
library;

class MultipleEventsCutter {
  DateTime? _lastTime;

  /// Returns true the first time and false until [interval] elapses.
  bool process({Duration interval = const Duration(milliseconds: 500)}) {
    final now = DateTime.now();
    if (_lastTime == null || now.difference(_lastTime!) > interval) {
      _lastTime = now;
      return true;
    }
    return false;
  }

  void reset() => _lastTime = null;
}
