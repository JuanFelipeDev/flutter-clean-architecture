/// Notifications repository contract (AFILIADO `soaang-notifier/notifications/
/// affiliate/{username}/` list + `obtener_numero_notificaciones/` counter).
library;

import '../../../../core/error/result.dart';
import '../entities/notification_entities.dart';

abstract class NotificationsRepository {
  Future<Result<List<AffiliateNotification>>> list(String username);
  Future<Result<int>> unreadCount(String username);
}