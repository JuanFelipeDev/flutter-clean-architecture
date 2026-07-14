/// Scheduling UI state (AFILIADO `ProgramarActivity` +
/// `ScheduleAssistanceDialog`).
library;

import '../../domain/entities/scheduling_entities.dart';

enum SchedulingStatus { idle, loading, validating, success, failure }

class SchedulingState {
  const SchedulingState({
    this.serviceId,
    this.slots = const [],
    this.selectedDate,
    this.selectedSlot,
    this.address = '',
    this.status = SchedulingStatus.idle,
    this.errorMessage,
  });

  final String? serviceId;
  final List<TimeSlot> slots;
  final DateTime? selectedDate;
  final TimeSlot? selectedSlot;
  final String address;
  final SchedulingStatus status;
  final String? errorMessage;

  SchedulingState copyWith({
    String? serviceId,
    List<TimeSlot>? slots,
    DateTime? selectedDate,
    TimeSlot? selectedSlot,
    String? address,
    SchedulingStatus? status,
    String? errorMessage,
  }) {
    return SchedulingState(
      serviceId: serviceId ?? this.serviceId,
      slots: slots ?? this.slots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      address: address ?? this.address,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}