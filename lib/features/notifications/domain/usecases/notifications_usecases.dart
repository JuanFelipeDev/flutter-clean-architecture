/// Notifications use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/notification_entities.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  GetNotificationsUseCase(this._repository);
  final NotificationsRepository _repository;
  Future<Result<List<AffiliateNotification>>> call(String username) =>
      _repository.list(username);
}

class GetUnreadCountUseCase {
  GetUnreadCountUseCase(this._repository);
  final NotificationsRepository _repository;
  Future<Result<int>> call(String username) => _repository.unreadCount(username);
}