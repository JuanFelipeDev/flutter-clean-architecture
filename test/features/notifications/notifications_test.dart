import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/features/notifications/data/models/notification_dtos.dart';
import 'package:affiliate_app/features/notifications/domain/entities/notification_entities.dart';
import 'package:affiliate_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:affiliate_app/features/notifications/presentation/providers/notifications_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements NotificationsRepository {
  final int unread;
  _FakeRepository(this.unread);

  @override
  Future<Result<List<AffiliateNotification>>> list(String username) async => const Success([
        AffiliateNotification(id: 'n1', type: NotificationType.providerAssignment, message: 'hi'),
        AffiliateNotification(id: 'n2', type: NotificationType.canceledAssistance, read: true),
      ]);
  @override
  Future<Result<int>> unreadCount(String username) async => Success(unread);
}

void main() {
  const session = SessionData(accessToken: 'tok', username: 'bob');

  group('NotificationsMapper', () {
    const mapper = NotificationsMapper();
    test('maps a DTO into a typed notification', () {
      final n = mapper.toEntity(const NotificationDto(
        id: '1',
        type: 'PROVIDER_ASSIGNMENT',
        message: 'hi',
      ));
      expect(n.type, NotificationType.providerAssignment);
      expect(n.message, 'hi');
    });
    test('unknown type falls back to unknown', () {
      final n = mapper.toEntity(const NotificationDto(id: '2', type: 'WHATEVER'));
      expect(n.type, NotificationType.unknown);
    });
  });

  group('NotificationsNotifier', () {
    ProviderContainer makeContainer(int unread) => ProviderContainer(overrides: [
          cachedSessionProvider.overrideWith((_) => session),
          notificationsRepositoryProvider.overrideWithValue(_FakeRepository(unread)),
        ]);

    test('loads list + unread count', () async {
      final container = makeContainer(3);
      addTearDown(container.dispose);
      final notifier = container.read(notificationsProvider.notifier);
      await notifier.load();
      final state = container.read(notificationsProvider);
      expect(state.notifications, hasLength(2));
      expect(state.unreadCount, 3);
    });

    test('failure when no session', () async {
      final container = ProviderContainer(overrides: [
        cachedSessionProvider.overrideWith((_) => const SessionData(accessToken: 'tok')),
        notificationsRepositoryProvider.overrideWithValue(_FakeRepository(0)),
      ]);
      addTearDown(container.dispose);
      final notifier = container.read(notificationsProvider.notifier);
      await notifier.load();
      final state = container.read(notificationsProvider);
      expect(state.notifications, isEmpty);
    });
  });
}