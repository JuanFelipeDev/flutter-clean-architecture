/// Survey entities (AFILIADO `quiz/` `QuestionQuiz` /
/// `GetQuestionsQuizResponse` / `SendSurveyRequest`).
library;

/// A quality-survey question (AFILIADO `quality-survey`).
class SurveyQuestion {
  const SurveyQuestion({required this.id, required this.text, required this.options});
  final String id;
  final String text;
  final List<String> options;
}

/// A single answer (AFILIADO `SendSurveyRequest` items).
class SurveyAnswer {
  const SurveyAnswer({required this.questionId, required this.answer});
  final String questionId;
  final String answer;
}