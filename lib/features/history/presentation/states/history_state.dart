library;

import '../../domain/entities/history_entities.dart';

enum HistoryStatus { idle, loading, failure }

class HistoryState {
  const HistoryState({
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
    this.status = HistoryStatus.idle,
    this.errorMessage,
  });

  final List<HistoryItem> items;
  final int page;
  final bool hasMore;
  final HistoryStatus status;
  final String? errorMessage;

  HistoryState copyWith({
    List<HistoryItem>? items,
    int? page,
    bool? hasMore,
    HistoryStatus? status,
    String? errorMessage,
  }) {
    return HistoryState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
