/// History use case.
library;

import '../../../../core/error/result.dart';
import '../entities/history_entities.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase {
  GetHistoryUseCase(this._repository);
  final HistoryRepository _repository;
  Future<Result<List<HistoryItem>>> call(String affKey, {int page = 1}) =>
      _repository.list(affKey, page: page);
}