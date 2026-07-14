/// Riverpod wiring for the survey feature. [SurveyNotifier] loads the
/// questions for an assistance and submits the answers (AFILIADO
/// `SurveyActivity`).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/survey_remote_data_source.dart';
import '../../data/models/survey_dtos.dart';
import '../../data/repositories/survey_repository_impl.dart';
import '../../domain/entities/survey_entities.dart';
import '../../domain/repositories/survey_repository.dart';
import '../../domain/usecases/survey_usecases.dart';
import '../states/survey_state.dart';

final surveyRemoteDataSourceProvider = Provider<SurveyRemoteDataSource>((ref) {
  return SurveyRemoteDataSource(ref.watch(dioProvider));
});

final surveyRepositoryProvider = Provider<SurveyRepository>((ref) {
  return SurveyRepositoryImpl(
    remoteDataSource: ref.watch(surveyRemoteDataSourceProvider),
    mapper: const SurveyMapper(),
  );
});

final getSurveyQuestionsUseCaseProvider = Provider<GetSurveyQuestionsUseCase>((ref) {
  return GetSurveyQuestionsUseCase(ref.watch(surveyRepositoryProvider));
});

final submitSurveyUseCaseProvider = Provider<SubmitSurveyUseCase>((ref) {
  return SubmitSurveyUseCase(ref.watch(surveyRepositoryProvider));
});

class SurveyNotifier extends Notifier<SurveyState> {
  @override
  SurveyState build() => const SurveyState(status: SurveyStatus.loading);

  String? _assistanceId;

  /// Loads the survey for [assistanceId].
  Future<void> load(String assistanceId) async {
    _assistanceId = assistanceId;
    state = state.copyWith(status: SurveyStatus.loading, errorMessage: '');
    final result = await ref.read(getSurveyQuestionsUseCaseProvider).call(assistanceId);
    state = state.copyWith(
      questions: result.getOrNull() ?? const [],
      status: SurveyStatus.idle,
    );
  }

  void setAnswer(String questionId, String answer) {
    final answers = Map<String, String>.from(state.answers)..[questionId] = answer;
    state = state.copyWith(answers: answers);
  }

  Future<bool> submit() async {
    final assistanceId = _assistanceId;
    if (assistanceId == null) return false;
    if (state.answers.length < state.questions.length) {
      state = state.copyWith(status: SurveyStatus.failure, errorMessage: 'Answer all questions');
      return false;
    }
    state = state.copyWith(status: SurveyStatus.submitting, errorMessage: '');
    final answers = state.answers.entries
        .map((e) => SurveyAnswer(questionId: e.key, answer: e.value))
        .toList();
    final result = await ref.read(submitSurveyUseCaseProvider).call(assistanceId, answers);
    return result.fold(
      onSuccess: (_) {
        state = state.copyWith(status: SurveyStatus.success);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(status: SurveyStatus.failure, errorMessage: failure.message);
        return false;
      },
    );
  }
}

final surveyProvider =
    NotifierProvider<SurveyNotifier, SurveyState>(SurveyNotifier.new);