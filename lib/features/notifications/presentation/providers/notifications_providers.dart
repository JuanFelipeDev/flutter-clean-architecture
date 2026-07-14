/// Riverpod wiring for the notifications feature. [NotificationsNotifier]
/// loads the list + unread counter (AFILIADO `NotificationsActivity` +
/// `BaseActivity.fillNumberNotifications`).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/notifications_remote_data_source.dart';
import '../../data/models/notification_dtos.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/usecases/notifications_usecases.dart';
import '../states/notifications_state.dart';

final notificationsRemoteDataSourceProvider = Provider<NotificationsRemoteDataSource>((ref) {
  return NotificationsRemoteDataSource(ref.watch(dioProvider));
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl(
    remoteDataSource: ref.watch(notificationsRemoteDataSourceProvider),
    mapper: const NotificationsMapper(),
  );
});

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  return GetNotificationsUseCase(ref.watch(notificationsRepositoryProvider));
});

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  return GetUnreadCountUseCase(ref.watch(notificationsRepositoryProvider));
});

class NotificationsNotifier extends Notifier<NotificationsState> {
  @override
  NotificationsState build() => const NotificationsState(status: NotificationsStatus.loading);

  String? get _username => ref.read(cachedSessionProvider)?.username;

  Future<void> load() async {
    final username = _username;
    if (username == null) {
      state = state.copyWith(status: NotificationsStatus.failure, errorMessage: 'No session');
      return;
    }
    state = state.copyWith(status: NotificationsStatus.loading, errorMessage: '');
    final list = await ref.read(getNotificationsUseCaseProvider).call(username);
    final count = await ref.read(getUnreadCountUseCaseProvider).call(username);
    state = state.copyWith(
      notifications: list.getOrNull() ?? const [],
      unreadCount: count.getOrNull() ?? 0,
      status: NotificationsStatus.idle,
    );
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, NotificationsState>(NotificationsNotifier.new);