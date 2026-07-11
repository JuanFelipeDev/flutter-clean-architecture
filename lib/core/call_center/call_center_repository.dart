/// Call-center contact seam (AFILIADO `BaseActivity.consultWsPhoneAndAccount`).
/// Implemented in Phase 5.
library;

import '../error/result.dart';

class CallCenterPhone {
  const CallCenterPhone({required this.label, required this.number});
  final String label;
  final String number;
}

abstract class CallCenterRepository {
  Future<Result<List<CallCenterPhone>>> phones();
}