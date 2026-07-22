/// Riverpod wiring for the scheduling feature. [SchedulingNotifier] loads
/// time slots for a date, validates, and confirms a scheduled assistance
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/scheduling_remote_data_source.dart';
import '../../data/models/scheduling_dtos.dart';
import '../../data/repositories/scheduling_repository_impl.dart';
import '../../domain/entities/scheduling_entities.dart';
import '../../domain/repositories/scheduling_repository.dart';
import '../../domain/usecases/scheduling_usecases.dart';
import '../states/scheduling_state.dart';

final schedulingRemoteDataSourceProvider = Provider<SchedulingRemoteDataSource>(
  (ref) {
    return SchedulingRemoteDataSource(ref.watch(dioProvider));
  },
);

final schedulingRepositoryProvider = Provider<SchedulingRepository>((ref) {
  return SchedulingRepositoryImpl(
    remoteDataSource: ref.watch(schedulingRemoteDataSourceProvider),
    mapper: const SchedulingMapper(),
  );
});

final getTimeSlotsUseCaseProvider = Provider<GetTimeSlotsUseCase>((ref) {
  return GetTimeSlotsUseCase(ref.watch(schedulingRepositoryProvider));
});

final validateScheduleUseCaseProvider = Provider<ValidateScheduleUseCase>((
  ref,
) {
  return ValidateScheduleUseCase(ref.watch(schedulingRepositoryProvider));
});

final scheduleUseCaseProvider = Provider<ScheduleUseCase>((ref) {
  return ScheduleUseCase(ref.watch(schedulingRepositoryProvider));
});

class SchedulingNotifier extends Notifier<SchedulingState> {
  @override
  SchedulingState build() => const SchedulingState();

  void setService(String serviceId) =>
      state = state.copyWith(serviceId: serviceId);

  Future<void> pickDate(DateTime date) async {
    final serviceId = state.serviceId;
    if (serviceId == null) return;
    state = state.copyWith(
      selectedDate: date,
      selectedSlot: null,
      slots: const [],
      status: SchedulingStatus.loading,
    );
    final result = await ref
        .read(getTimeSlotsUseCaseProvider)
        .call(serviceId, date);
    state = state.copyWith(
      slots: result.getOrNull() ?? const [],
      status: SchedulingStatus.idle,
    );
  }

  void selectSlot(TimeSlot slot) => state = state.copyWith(selectedSlot: slot);

  void setAddress(String address) => state = state.copyWith(address: address);

  Future<bool> confirm() async {
    final date = state.selectedDate;
    final slot = state.selectedSlot;
    final serviceId = state.serviceId;
    if (date == null || slot == null || serviceId == null) return false;

    final request = ScheduleRequest(
      serviceId: serviceId,
      date: date,
      slot: slot,
      address: state.address.isEmpty ? null : state.address,
    );

    state = state.copyWith(
      status: SchedulingStatus.validating,
      errorMessage: '',
    );
    final validation = await ref
        .read(validateScheduleUseCaseProvider)
        .call(request);
    final valid = validation.fold(
      onSuccess: (v) => v.valid,
      onFailure: (_) => false,
    );
    if (!valid) {
      state = state.copyWith(
        status: SchedulingStatus.failure,
        errorMessage: validation.fold(
          onSuccess: (v) => v.message,
          onFailure: (f) => f.message,
        ),
      );
      return false;
    }

    final result = await ref.read(scheduleUseCaseProvider).call(request);
    return result.fold(
      onSuccess: (_) {
        state = state.copyWith(status: SchedulingStatus.success);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(
          status: SchedulingStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }
}

final schedulingProvider =
    NotifierProvider<SchedulingNotifier, SchedulingState>(
      SchedulingNotifier.new,
    );
