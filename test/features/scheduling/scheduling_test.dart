import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/features/scheduling/data/models/scheduling_dtos.dart';
import 'package:affiliate_app/features/scheduling/domain/entities/scheduling_entities.dart';
import 'package:affiliate_app/features/scheduling/domain/repositories/scheduling_repository.dart';
import 'package:affiliate_app/features/scheduling/presentation/providers/scheduling_providers.dart';
import 'package:affiliate_app/features/scheduling/presentation/states/scheduling_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSchedulingRepository implements SchedulingRepository {
  final bool valid;
  _FakeSchedulingRepository(this.valid);

  @override
  Future<Result<List<TimeSlot>>> timeSlots(String serviceId, DateTime date) async => const Success([
        TimeSlot(start: '08:00', end: '12:00'),
        TimeSlot(start: '13:00', end: '17:00'),
      ]);
  @override
  Future<Result<ScheduleValidation>> validate(ScheduleRequest request) async =>
      Success(ScheduleValidation(valid: valid, message: valid ? null : 'Not allowed'));
  @override
  Future<Result<void>> schedule(ScheduleRequest request) async => Result<void>.guard(() {});
}

void main() {
  group('SchedulingMapper', () {
    const mapper = SchedulingMapper();
    test('maps a slot dto', () {
      final slot = mapper.toEntity(const TimeSlotDto(start: '08:00', end: '12:00'));
      expect(slot.start, '08:00');
    });
    test('maps a validation dto', () {
      final v = mapper.toValidation(const ScheduleValidationDto(valid: true));
      expect(v.valid, isTrue);
    });
    test('builds a request body with an ISO date', () {
      final body = mapper.requestToBody(ScheduleRequest(
        serviceId: 's1',
        date: DateTime(2026, 7, 13),
        slot: const TimeSlot(start: '08:00', end: '12:00'),
        address: 'Av 1',
      ));
      expect(body['date'], '2026-07-13');
      expect(body['start'], '08:00');
      expect(body['address'], 'Av 1');
    });
  });

  group('SchedulingNotifier', () {
    ProviderContainer makeContainer(bool valid) => ProviderContainer(overrides: [
          schedulingRepositoryProvider.overrideWithValue(_FakeSchedulingRepository(valid)),
        ]);

    test('pickDate loads slots', () async {
      final container = makeContainer(true);
      addTearDown(container.dispose);
      final notifier = container.read(schedulingProvider.notifier);
      notifier.setService('s1');
      await notifier.pickDate(DateTime(2026, 7, 13));
      expect(container.read(schedulingProvider).slots, hasLength(2));
    });

    test('confirm succeeds when valid', () async {
      final container = makeContainer(true);
      addTearDown(container.dispose);
      final notifier = container.read(schedulingProvider.notifier);
      notifier.setService('s1');
      await notifier.pickDate(DateTime(2026, 7, 13));
      notifier.selectSlot(container.read(schedulingProvider).slots.first);
      notifier.setAddress('Av 1');
      final ok = await notifier.confirm();
      expect(ok, isTrue);
      expect(container.read(schedulingProvider).status, SchedulingStatus.success);
    });

    test('confirm fails when validation rejects', () async {
      final container = makeContainer(false);
      addTearDown(container.dispose);
      final notifier = container.read(schedulingProvider.notifier);
      notifier.setService('s1');
      await notifier.pickDate(DateTime(2026, 7, 13));
      notifier.selectSlot(container.read(schedulingProvider).slots.first);
      final ok = await notifier.confirm();
      expect(ok, isFalse);
      expect(container.read(schedulingProvider).status, SchedulingStatus.failure);
    });
  });
}