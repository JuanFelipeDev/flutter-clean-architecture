import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/features/survey/data/models/survey_dtos.dart';
import 'package:affiliate_app/features/survey/domain/entities/survey_entities.dart';
import 'package:affiliate_app/features/survey/domain/repositories/survey_repository.dart';
import 'package:affiliate_app/features/survey/presentation/providers/survey_providers.dart';
import 'package:affiliate_app/features/survey/presentation/states/survey_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSurveyRepository implements SurveyRepository {
  @override
  Future<Result<List<SurveyQuestion>>> questions(String assistanceId) async => const Success([
        SurveyQuestion(id: 'q1', text: 'Rate the service', options: ['Good', 'Bad']),
        SurveyQuestion(id: 'q2', text: 'On time?', options: ['Yes', 'No']),
      ]);
  @override
  Future<Result<void>> submit(String assistanceId, List<SurveyAnswer> answers) async =>
      Result<void>.guard(() {});
}

void main() {
  group('SurveyMapper', () {
    const mapper = SurveyMapper();
    test('maps a question dto', () {
      final q = mapper.toEntity(const SurveyQuestionDto(
        id: 'q1', text: 'Rate', options: ['Good', 'Bad'],
      ));
      expect(q.options, ['Good', 'Bad']);
    });
    test('builds an answer body', () {
      final body = mapper.answerToBody(const SurveyAnswer(questionId: 'q1', answer: 'Good'));
      expect(body['answer'], 'Good');
    });
  });

  group('SurveyNotifier', () {
    ProviderContainer makeContainer() => ProviderContainer(overrides: [
          surveyRepositoryProvider.overrideWithValue(_FakeSurveyRepository()),
        ]);

    test('load fetches questions', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(surveyProvider.notifier);
      await notifier.load('a1');
      expect(container.read(surveyProvider).questions, hasLength(2));
    });

    test('submit blocks when not all answered', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(surveyProvider.notifier);
      await notifier.load('a1');
      notifier.setAnswer('q1', 'Good');
      final ok = await notifier.submit();
      expect(ok, isFalse);
      expect(container.read(surveyProvider).status, SurveyStatus.failure);
    });

    test('submit succeeds when all answered', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(surveyProvider.notifier);
      await notifier.load('a1');
      notifier.setAnswer('q1', 'Good');
      notifier.setAnswer('q2', 'Yes');
      final ok = await notifier.submit();
      expect(ok, isTrue);
      expect(container.read(surveyProvider).status, SurveyStatus.success);
    });
  });
}