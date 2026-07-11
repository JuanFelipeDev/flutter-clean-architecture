/// Local relational database seam. The real implementation (drift, with the
/// offline outbox + cached assists/coordinates) lands in Phase 4, where
/// `drift_dev` codegen is introduced. This interface keeps the storage layer
/// consumable now and lets tests inject a no-op.
library;

/// Minimal contract the rest of `core/` depends on. Extended in Phase 4.
abstract class LocalDatabase {
  Future<void> init();
  Future<void> close();
}

/// Phase 3 placeholder. Phase 4 replaces it with the drift `AppDatabase`.
class NoopLocalDatabase implements LocalDatabase {
  @override
  Future<void> init() async {}
  @override
  Future<void> close() async {}
}