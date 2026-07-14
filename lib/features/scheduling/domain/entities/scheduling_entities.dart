/// Scheduling entities (AFILIADO `schedules/` `ResponseValidateScheduleAssistance` /
/// `TimeZoneResponse`).
library;

/// A service time slot for a date (AFILIADO `obtener_franja_horario_servicio`).
class TimeSlot {
  const TimeSlot({required this.start, required this.end, this.available = true});
  final String start; // e.g. "08:00"
  final String end; // e.g. "12:00"
  final bool available;
}

/// A scheduling request (AFILIADO `validar_servicio_programadas` +
/// scheduled assistance).
class ScheduleRequest {
  const ScheduleRequest({
    required this.serviceId,
    required this.date,
    required this.slot,
    this.address,
  });
  final String serviceId;
  final DateTime date;
  final TimeSlot slot;
  final String? address;
}

/// Result of validating a scheduled assistance (AFILIADO
/// `ResponseValidateScheduleAssistance`).
class ScheduleValidation {
  const ScheduleValidation({required this.valid, this.message});
  final bool valid;
  final String? message;
}