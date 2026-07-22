/// Tracking use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/tracking_entities.dart';
import '../repositories/tracking_repository.dart';

class GetActiveAssistancesUseCase {
  GetActiveAssistancesUseCase(this._repository);
  final TrackingRepository _repository;
  Future<Result<List<ActiveAssistance>>> call(String affKey) =>
      _repository.activeAssistances(affKey);
}

class ConfirmArrivalUseCase {
  ConfirmArrivalUseCase(this._repository);
  final TrackingRepository _repository;
  Future<Result<void>> call(String assistanceId) =>
      _repository.confirmArrival(assistanceId);
}

class ConfirmFinalUseCase {
  ConfirmFinalUseCase(this._repository);
  final TrackingRepository _repository;
  Future<Result<void>> call(String assistanceId) =>
      _repository.confirmFinal(assistanceId);
}

class SendPanicUseCase {
  SendPanicUseCase(this._repository);
  final TrackingRepository _repository;
  Future<Result<void>> call(String assistanceId, double lat, double lng) =>
      _repository.sendPanic(assistanceId, lat, lng);
}
