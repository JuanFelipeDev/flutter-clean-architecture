/// `soaang-notifier/notifications/affiliate/{username}/` list +
/// `obtener_numero_notificaciones/` counter).
library;

import 'package:dio/dio.dart';

import '../models/notification_dtos.dart';

class NotificationsRemoteDataSource {
  NotificationsRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<NotificationDto>> fetchList(String username) async {
    final res = await _dio.get<dynamic>(
      'soaang-notifier/notifications/affiliate/$username/',
    );
    return parseNotifications(res.data);
  }

  Future<int> fetchUnreadCount(String username) async {
    final res = await _dio.get<dynamic>(
      'obtener_numero_notificaciones/',
      queryParameters: {'username': username},
    );
    final data = res.data;
    if (data is Map) {
      final count =
          data['count'] ?? data['total'] ?? data['num_notificaciones'];
      if (count is num) return count.toInt();
    }
    if (data is num) return data.toInt();
    return 0;
  }
}
