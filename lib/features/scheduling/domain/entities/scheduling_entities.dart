/// `TimeZoneResponse`).
library;

class TimeSlot {
  const TimeSlot({
    required this.start,
    required this.end,
    this.available = true,
  });
  final String start;
  final String end;
  final bool available;
}

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

/// `ResponseValidateScheduleAssistance`).
class ScheduleValidation {
  const ScheduleValidation({required this.valid, this.message});
  final bool valid;
  final String? message;
}
