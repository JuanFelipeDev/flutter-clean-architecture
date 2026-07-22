/// `validar_servicio_programadas`, scheduled assistance creation).
library;

import '../../../../core/error/result.dart';
import '../entities/scheduling_entities.dart';

abstract class SchedulingRepository {
  /// `obtener_franja_horario_servicio/`).
  Future<Result<List<TimeSlot>>> timeSlots(String serviceId, DateTime date);

  Future<Result<ScheduleValidation>> validate(ScheduleRequest request);

  /// Confirms the scheduled assistance (creates it server-side).
  Future<Result<void>> schedule(ScheduleRequest request);
}
