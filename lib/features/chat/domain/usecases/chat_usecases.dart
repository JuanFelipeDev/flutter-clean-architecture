/// Chat use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/chat_entities.dart';
import '../repositories/chat_repository.dart';

class GetHistoryUseCase {
  GetHistoryUseCase(this._repository);
  final ChatRepository _repository;
  Future<Result<List<ChatMessage>>> call(String assistanceId, {int page = 1}) =>
      _repository.history(assistanceId, page: page);
}

class SendMessageUseCase {
  SendMessageUseCase(this._repository);
  final ChatRepository _repository;
  Future<Result<void>> call(String assistanceId, String content) =>
      _repository.send(assistanceId, content);
}
