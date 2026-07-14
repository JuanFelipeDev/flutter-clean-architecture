/// History entities (AFILIADO `history/model/AssistanceHistoryResponse`).
library;

/// A past assistance in the history (AFILIADO `list-afiliate-assistances`).
class HistoryItem {
  const HistoryItem({
    required this.id,
    required this.serviceId,
    this.serviceName,
    this.status,
    this.createdAt,
    this.address,
    this.providerName,
  });
  final String id;
  final String serviceId;
  final String? serviceName;
  final String? status;
  final DateTime? createdAt;
  final String? address;
  final String? providerName;
}