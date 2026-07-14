/// Survey UI state (AFILIADO `SurveyActivity`/`SurveyScreen`).
library;

import '../../domain/entities/survey_entities.dart';

enum SurveyStatus { idle, loading, submitting, success, failure }

class SurveyState {
  const SurveyState({
    this.questions = const [],
    this.answers = const {},
    this.status = SurveyStatus.idle,
    this.errorMessage,
  });

  final List<SurveyQuestion> questions;
  final Map<String, String> answers;
  final SurveyStatus status;
  final String? errorMessage;

  SurveyState copyWith({
    List<SurveyQuestion>? questions,
    Map<String, String>? answers,
    SurveyStatus? status,
    String? errorMessage,
  }) {
    return SurveyState(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}