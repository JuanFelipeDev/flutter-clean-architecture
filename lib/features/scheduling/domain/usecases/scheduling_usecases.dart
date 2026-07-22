/// Scheduling use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/scheduling_entities.dart';
import '../repositories/scheduling_repository.dart';

class GetTimeSlotsUseCase {
  GetTimeSlotsUseCase(this._repository);
  final SchedulingRepository _repository;
  Future<Result<List<TimeSlot>>> call(String serviceId, DateTime date) =>
      _repository.timeSlots(serviceId, date);
}

class ValidateScheduleUseCase {
  ValidateScheduleUseCase(this._repository);
  final SchedulingRepository _repository;
  Future<Result<ScheduleValidation>> call(ScheduleRequest request) =>
      _repository.validate(request);
}

class ScheduleUseCase {
  ScheduleUseCase(this._repository);
  final SchedulingRepository _repository;
  Future<Result<void>> call(ScheduleRequest request) =>
      _repository.schedule(request);
}
