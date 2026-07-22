/// Tracking screen — list of active assistances with live provider
/// coordinates (from the coordinates socket) and the tracking lifecycle event
/// `TrackingFragment` + `TrackingMapActivity` confirmation dialogs).
///
/// The full Google Maps view (google_maps_flutter) lands in Phase 6 polish;
/// here the live coordinates render per assistance so the realtime behavior is
/// verifiable without the maps native dep.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/tracking_entities.dart';
import '../providers/tracking_providers.dart';
import '../states/tracking_state.dart';

class TrackingPage extends ConsumerStatefulWidget {
  const TrackingPage({super.key});

  @override
  ConsumerState<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends ConsumerState<TrackingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(trackingProvider, _onStateChanged);
      ref.read(trackingProvider.notifier).start();
    });
  }

  void _onStateChanged(TrackingState? previous, TrackingState next) {
    if (next.status == TrackingStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    } else if (next.lastEvent != previous?.lastEvent) {
      context.showToast('Event: ${next.lastEvent?.name}', kind: ToastKind.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(trackingProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoute.history.path),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(trackingProvider.notifier).refresh(),
          ),
        ],
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == TrackingStatus.loading,
          child: state.assistances.isEmpty
              ? const Center(child: Text('No active assistances'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.assistances.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => _AssistanceTile(
                    assistance: state.assistances[i],
                    coordinates: state.coordinates[state.assistances[i].id],
                  ),
                ),
        ),
      ),
    );
  }
}

class _AssistanceTile extends ConsumerWidget {
  const _AssistanceTile({required this.assistance, this.coordinates});
  final ActiveAssistance assistance;
  final ProviderCoordinates? coordinates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(trackingProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Assistance ${assistance.id}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (assistance.status != null)
                Chip(label: Text(assistance.status!)),
            ],
          ),
          if (assistance.providerName != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Provider: ${assistance.providerName}'),
            ),
          if (coordinates != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '📍 ${coordinates!.lat.toStringAsFixed(5)}, ${coordinates!.lng.toStringAsFixed(5)}',
                style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: () => notifier.confirmArrival(assistance.id),
                child: const Text('Confirm arrival'),
              ),
              FilledButton.tonal(
                onPressed: () => notifier.confirmFinal(assistance.id),
                child: const Text('Confirm end'),
              ),
              FilledButton(
                onPressed: () =>
                    context.push(AppRoute.chat.path, extra: assistance.id),
                child: const Text('Chat'),
              ),
              FilledButton.tonal(
                onPressed: () =>
                    context.push(AppRoute.videoCall.path, extra: assistance.id),
                child: const Text('Video'),
              ),
              OutlinedButton(
                onPressed: () => notifier.panic(assistance.id, 0, 0),
                child: const Text('Panic'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
