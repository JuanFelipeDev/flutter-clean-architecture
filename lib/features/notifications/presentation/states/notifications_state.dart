/// Notifications UI state (AFILIADO `NotificationsActivity` + counter badge).
library;

import '../../domain/entities/notification_entities.dart';

enum NotificationsStatus { idle, loading, failure }

class NotificationsState {
  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.status = NotificationsStatus.idle,
    this.errorMessage,
  });

  final List<AffiliateNotification> notifications;
  final int unreadCount;
  final NotificationsStatus status;
  final String? errorMessage;

  NotificationsState copyWith({
    List<AffiliateNotification>? notifications,
    int? unreadCount,
    NotificationsStatus? status,
    String? errorMessage,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}