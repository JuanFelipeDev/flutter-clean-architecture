/// `GetQuestionsQuizResponse` / `SendSurveyRequest`).
library;

class SurveyQuestion {
  const SurveyQuestion({
    required this.id,
    required this.text,
    required this.options,
  });
  final String id;
  final String text;
  final List<String> options;
}

class SurveyAnswer {
  const SurveyAnswer({required this.questionId, required this.answer});
  final String questionId;
  final String answer;
}
