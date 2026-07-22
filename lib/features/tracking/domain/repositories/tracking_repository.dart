/// `stage-update`, `assistance-app-panic`).
library;

import '../../../../core/error/result.dart';
import '../entities/tracking_entities.dart';

abstract class TrackingRepository {
  Future<Result<List<ActiveAssistance>>> activeAssistances(String affKey);
  Future<Result<void>> confirmArrival(String assistanceId);
  Future<Result<void>> confirmFinal(String assistanceId);
  Future<Result<void>> sendPanic(String assistanceId, double lat, double lng);
}
