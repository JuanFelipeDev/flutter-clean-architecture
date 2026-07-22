/// Riverpod wiring for the history feature. [HistoryNotifier] loads the
/// `ServiceHistoryFragment` + `list-afiliate-assistances`).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/history_remote_data_source.dart';
import '../../data/models/history_dtos.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/history_usecases.dart';
import '../states/history_state.dart';

final historyRemoteDataSourceProvider = Provider<HistoryRemoteDataSource>((
  ref,
) {
  return HistoryRemoteDataSource(ref.watch(dioProvider));
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(
    remoteDataSource: ref.watch(historyRemoteDataSourceProvider),
    mapper: const HistoryMapper(),
  );
});

final getHistoryUseCaseProvider = Provider<GetHistoryUseCase>((ref) {
  return GetHistoryUseCase(ref.watch(historyRepositoryProvider));
});

class HistoryNotifier extends Notifier<HistoryState> {
  @override
  HistoryState build() => const HistoryState(status: HistoryStatus.loading);

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  Future<void> load() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: 'No session',
      );
      return;
    }
    state = state.copyWith(
      status: HistoryStatus.loading,
      page: 1,
      errorMessage: '',
    );
    final result = await ref
        .read(getHistoryUseCaseProvider)
        .call(affKey, page: 1);
    final items = result.getOrNull() ?? const [];
    state = state.copyWith(
      items: items,
      page: 1,
      hasMore: items.isNotEmpty,
      status: HistoryStatus.idle,
      errorMessage: result.failureOrNull()?.message,
    );
  }

  Future<void> loadMore() async {
    final affKey = _affKey;
    if (affKey == null ||
        !state.hasMore ||
        state.status == HistoryStatus.loading)
      return;
    final nextPage = state.page + 1;
    state = state.copyWith(status: HistoryStatus.loading, errorMessage: '');
    final result = await ref
        .read(getHistoryUseCaseProvider)
        .call(affKey, page: nextPage);
    final newItems = result.getOrNull() ?? const [];
    state = state.copyWith(
      items: [...state.items, ...newItems],
      page: nextPage,
      hasMore: newItems.isNotEmpty,
      status: HistoryStatus.idle,
      errorMessage: result.failureOrNull()?.message,
    );
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, HistoryState>(
  HistoryNotifier.new,
);
