import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/features/history/data/models/history_dtos.dart';
import 'package:affiliate_app/features/history/domain/entities/history_entities.dart';
import 'package:affiliate_app/features/history/domain/repositories/history_repository.dart';
import 'package:affiliate_app/features/history/presentation/providers/history_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHistoryRepository implements HistoryRepository {
  final int pages;
  _FakeHistoryRepository(this.pages);

  @override
  Future<Result<List<HistoryItem>>> list(String affKey, {int page = 1}) async {
    if (page > pages) return const Success([]);
    return Success([
      HistoryItem(id: 'p$page-1', serviceId: 's', serviceName: 'Service $page'),
      HistoryItem(id: 'p$page-2', serviceId: 's', serviceName: 'Service $page'),
    ]);
  }
}

void main() {
  const session = SessionData(accessToken: 'tok', affKey: 'aff-1');

  group('HistoryMapper', () {
    const mapper = HistoryMapper();
    test('maps a DTO', () {
      final item = mapper.toEntity(
        const HistoryItemDto(
          id: '1',
          serviceId: 's',
          serviceName: 'Tow',
          status: 'done',
        ),
      );
      expect(item.serviceName, 'Tow');
      expect(item.status, 'done');
    });
  });

  group('HistoryNotifier', () {
    ProviderContainer makeContainer(int pages) => ProviderContainer(
      overrides: [
        cachedSessionProvider.overrideWith((_) => session),
        historyRepositoryProvider.overrideWithValue(
          _FakeHistoryRepository(pages),
        ),
      ],
    );

    test('load first page', () async {
      final container = makeContainer(2);
      addTearDown(container.dispose);
      final notifier = container.read(historyProvider.notifier);
      await notifier.load();
      final state = container.read(historyProvider);
      expect(state.items, hasLength(2));
      expect(state.hasMore, isTrue);
    });

    test('loadMore appends next pages and stops at the end', () async {
      final container = makeContainer(2);
      addTearDown(container.dispose);
      final notifier = container.read(historyProvider.notifier);
      await notifier.load();
      await notifier.loadMore();
      expect(container.read(historyProvider).items, hasLength(4));
      await notifier.loadMore();
      expect(container.read(historyProvider).items, hasLength(4));
      expect(container.read(historyProvider).hasMore, isFalse);
    });

    test('loadMore is a no-op when hasMore is false', () async {
      final container = makeContainer(1);
      addTearDown(container.dispose);
      final notifier = container.read(historyProvider.notifier);
      await notifier.load();
      await notifier.loadMore();
      expect(container.read(historyProvider).hasMore, isFalse);
    });
  });
}
