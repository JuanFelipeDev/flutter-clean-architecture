/// Scheduling repository contract (AFILIADO `obtener_franja_horario_servicio`,
/// `validar_servicio_programadas`, scheduled assistance creation).
library;

import '../../../../core/error/result.dart';
import '../entities/scheduling_entities.dart';

abstract class SchedulingRepository {
  /// Available time slots for a service on a given date (AFILIADO
  /// `obtener_franja_horario_servicio/`).
  Future<Result<List<TimeSlot>>> timeSlots(String serviceId, DateTime date);

  /// Validates a scheduled assistance (AFILIADO `validar_servicio_programadas`).
  Future<Result<ScheduleValidation>> validate(ScheduleRequest request);

  /// Confirms the scheduled assistance (creates it server-side).
  Future<Result<void>> schedule(ScheduleRequest request);
}