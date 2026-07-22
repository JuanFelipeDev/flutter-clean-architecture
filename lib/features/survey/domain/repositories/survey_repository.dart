/// `quality-survey/{idAssistance}/` GET/PUT + `poll-assist-create`).
library;

import '../../../../core/error/result.dart';
import '../entities/survey_entities.dart';

abstract class SurveyRepository {
  /// `quality-survey/{idAssistance}/` GET).
  Future<Result<List<SurveyQuestion>>> questions(String assistanceId);

  /// / `poll-assist-create`).
  Future<Result<void>> submit(String assistanceId, List<SurveyAnswer> answers);
}
