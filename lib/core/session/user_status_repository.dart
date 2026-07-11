/// Affiliate status check (AFILIADO `UserStatusRepository.getStateAffiliate`).
/// Implemented in Phase 5; `core/` depends only on the abstraction.
library;

import '../error/result.dart';

enum AffiliateStatus { active, expired, unknown }

abstract class UserStatusRepository {
  Future<Result<AffiliateStatus>> current();
}