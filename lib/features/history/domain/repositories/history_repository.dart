/// `soaang-assistances/api/assistances/list-afiliate-assistances`).
library;

import '../../../../core/error/result.dart';
import '../entities/history_entities.dart';

abstract class HistoryRepository {
  /// Paginated history; [page] is 1-based. Returns the page's items + whether
  /// more pages are likely available.
  Future<Result<List<HistoryItem>>> list(String affKey, {int page = 1});
}
