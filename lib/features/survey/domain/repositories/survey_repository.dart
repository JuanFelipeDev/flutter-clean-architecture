/// Survey repository contract (AFILIADO
/// `quality-survey/{idAssistance}/` GET/PUT + `poll-assist-create`).
library;

import '../../../../core/error/result.dart';
import '../entities/survey_entities.dart';

abstract class SurveyRepository {
  /// Fetches the survey questions for an assistance (AFILIADO
  /// `quality-survey/{idAssistance}/` GET).
  Future<Result<List<SurveyQuestion>>> questions(String assistanceId);

  /// Submits the survey answers (AFILIADO `quality-survey/{idAssistance}/` PUT
  /// / `poll-assist-create`).
  Future<Result<void>> submit(String assistanceId, List<SurveyAnswer> answers);
}