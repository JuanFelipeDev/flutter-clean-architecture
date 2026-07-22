/// Session repository contract. Implemented in Phase 4/5 by the authentication
/// feature's data layer; `core/` depends only on this abstraction.
library;

import '../error/result.dart';

/// Minimal session operations needed by `core/` (guards, inactivity, telemetry
/// user id). The full auth flow lives in `features/authentication`.
abstract class SessionRepository {
  Future<bool> hasSession();
  Future<void> clear();
  Future<String?> accessToken();
  Future<Result<void>> refresh();
}
