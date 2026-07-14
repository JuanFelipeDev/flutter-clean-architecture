/// Scheduling screen — pick a date, choose a time slot, enter an address, then
/// validate + confirm a scheduled assistance (AFILIADO `ProgramarActivity`).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../providers/scheduling_providers.dart';
import '../states/scheduling_state.dart';

class SchedulingPage extends ConsumerStatefulWidget {
  const SchedulingPage({required this.serviceId, super.key});
  final String serviceId;

  @override
  ConsumerState<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends ConsumerState<SchedulingPage> {
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(schedulingProvider, _onChanged);
      ref.read(schedulingProvider.notifier).setService(widget.serviceId);
    });
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  void _onChanged(SchedulingState? previous, SchedulingState next) {
    if (next.status == SchedulingStatus.success) {
      context.showToast('Scheduled', kind: ToastKind.success);
      Navigator.of(context).pop();
    } else if (next.status == SchedulingStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(schedulingProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading:
              state.status == SchedulingStatus.loading || state.status == SchedulingStatus.validating,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: const Text('Date'),
                  subtitle: Text(state.selectedDate == null
                      ? 'Pick a date'
                      : '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) {
                      unawaited(ref.read(schedulingProvider.notifier).pickDate(picked));
                    }
                  },
                ),
                const SizedBox(height: 8),
                if (state.slots.isNotEmpty) ...[
                  Text('Time slots', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final slot in state.slots)
                        FilterChip(
                          label: Text('${slot.start} - ${slot.end}'),
                          selected: state.selectedSlot == slot,
                          onSelected: slot.available
                              ? (_) => ref.read(schedulingProvider.notifier).selectSlot(slot)
                              : null,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _address,
                    decoration: const InputDecoration(labelText: 'Address'),
                    onChanged: (v) => ref.read(schedulingProvider.notifier).setAddress(v),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state.selectedSlot != null
                        ? () {
                            unawaited(ref.read(schedulingProvider.notifier).confirm());
                          }
                        : null,
                    child: const Text('Confirm'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}