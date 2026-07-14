/// Survey use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/survey_entities.dart';
import '../repositories/survey_repository.dart';

class GetSurveyQuestionsUseCase {
  GetSurveyQuestionsUseCase(this._repository);
  final SurveyRepository _repository;
  Future<Result<List<SurveyQuestion>>> call(String assistanceId) =>
      _repository.questions(assistanceId);
}

class SubmitSurveyUseCase {
  SubmitSurveyUseCase(this._repository);
  final SurveyRepository _repository;
  Future<Result<void>> call(String assistanceId, List<SurveyAnswer> answers) =>
      _repository.submit(assistanceId, answers);
}