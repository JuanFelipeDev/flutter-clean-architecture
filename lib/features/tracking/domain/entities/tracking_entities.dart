/// `TrackingMapResponse` + socket payloads).
library;

/// `list-afiliate-active-assistances`).
class ActiveAssistance {
  const ActiveAssistance({
    required this.id,
    required this.serviceId,
    this.status,
    this.stage,
    this.providerName,
  });
  final String id;
  final String serviceId;
  final String? status;
  final String? stage;
  final String? providerName;
}

/// / `REGEX_SOCKET_CORDINATES`).
class ProviderCoordinates {
  const ProviderCoordinates({
    required this.assistanceId,
    required this.lat,
    required this.lng,
  });
  final String assistanceId;
  final double lat;
  final double lng;
}

/// Tracking lifecycle event types received on the tracking socket channel
enum TrackingEventType {
  cancelRequest,
  updateRequest,
  arrivalRequest,
  finalArrival,
  monitoring,
  pollRequest,
  acceptRequest,
  updateApp,
  sessionExpired,
  unknown;

  static TrackingEventType fromName(String? name) {
    switch (name) {
      case 'cancel_request':
        return TrackingEventType.cancelRequest;
      case 'update_request':
        return TrackingEventType.updateRequest;
      case 'arrival_request':
        return TrackingEventType.arrivalRequest;
      case 'final_arrival':
        return TrackingEventType.finalArrival;
      case 'monitoring':
        return TrackingEventType.monitoring;
      case 'poll_request':
        return TrackingEventType.pollRequest;
      case 'accept_request':
        return TrackingEventType.acceptRequest;
      case 'update_app':
        return TrackingEventType.updateApp;
      case 'session_expired':
        return TrackingEventType.sessionExpired;
      default:
        return TrackingEventType.unknown;
    }
  }
}
