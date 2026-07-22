/// Tracking UI state. Holds the active assistance list, per-assistance live
/// coordinates, the last socket event, and connection/loading status.
library;

import '../../domain/entities/tracking_entities.dart';

enum TrackingStatus { idle, loading, failure }

class TrackingState {
  const TrackingState({
    this.assistances = const [],
    this.coordinates = const {},
    this.lastEvent,
    this.status = TrackingStatus.idle,
    this.errorMessage,
  });

  final List<ActiveAssistance> assistances;
  final Map<String, ProviderCoordinates> coordinates;
  final TrackingEventType? lastEvent;
  final TrackingStatus status;
  final String? errorMessage;

  TrackingState copyWith({
    List<ActiveAssistance>? assistances,
    Map<String, ProviderCoordinates>? coordinates,
    TrackingEventType? lastEvent,
    TrackingStatus? status,
    String? errorMessage,
  }) {
    return TrackingState(
      assistances: assistances ?? this.assistances,
      coordinates: coordinates ?? this.coordinates,
      lastEvent: lastEvent ?? this.lastEvent,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
