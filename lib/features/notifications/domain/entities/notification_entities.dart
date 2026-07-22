/// `NotificationsEvents` types).
library;

enum NotificationType {
  supplierArrivalConfirmation,
  supplierTermConfirmation,
  excedentCost1,
  excedentCost2,
  excedentCostManeuvers,
  excedentConnectionSoaang,
  canceledAssistance,
  expiredSession,
  informativeBeneficiary,
  serviceWithoutCoverage,
  providerAssignment,
  pendingProviderAssignment,
  reassignmentOfTheProvider,
  unknown;

  static NotificationType fromName(String? name) {
    switch (name) {
      case 'SUPPLIER_ARRIVAL_CONFIRMATION':
        return NotificationType.supplierArrivalConfirmation;
      case 'SUPPLIER_TERM_CONFIRMATION':
        return NotificationType.supplierTermConfirmation;
      case 'EXCEDENT_COST_1':
        return NotificationType.excedentCost1;
      case 'EXCEDENT_COST_2':
        return NotificationType.excedentCost2;
      case 'EXCEDENT_COST_MANEUVERS':
        return NotificationType.excedentCostManeuvers;
      case 'EXCEDENT_CONNECTION_SOAANG':
        return NotificationType.excedentConnectionSoaang;
      case 'CANCELED_ASSISTANCE':
        return NotificationType.canceledAssistance;
      case 'EXPIRED_SESSION':
        return NotificationType.expiredSession;
      case 'INFORMATIVE_BENEFICIARY':
        return NotificationType.informativeBeneficiary;
      case 'SERVICE_WITHOUT_COVERAGE':
        return NotificationType.serviceWithoutCoverage;
      case 'PROVIDER_ASSIGNMENT':
        return NotificationType.providerAssignment;
      case 'PENDING_PROVIDER_ASSIGNMENT':
        return NotificationType.pendingProviderAssignment;
      case 'REASSIGNMENT_OF_THE_PROVIDER':
        return NotificationType.reassignmentOfTheProvider;
      default:
        return NotificationType.unknown;
    }
  }
}

class AffiliateNotification {
  const AffiliateNotification({
    required this.id,
    required this.type,
    this.message,
    this.assistanceId,
    this.createdAt,
    this.read = false,
  });
  final String id;
  final NotificationType type;
  final String? message;
  final String? assistanceId;
  final DateTime? createdAt;
  final bool read;
}
