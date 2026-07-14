/// DTOs + mapper for survey (AFILIADO `GetQuestionsQuizResponse` /
/// `SendSurveyRequest`).
library;

import '../../domain/entities/survey_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

class SurveyQuestionDto {
  const SurveyQuestionDto({this.id, this.text, this.options = const <String>[]});
  final String? id;
  final String? text;
  final List<String> options;

  factory SurveyQuestionDto.fromJson(Map<String, dynamic> json) {
    final opts = json['options'];
    return SurveyQuestionDto(
      id: json['id']?.toString() ?? json['idPregunta']?.toString(),
      text: json['pregunta']?.toString() ?? json['text']?.toString(),
      options: opts is List ? opts.map((e) => e.toString()).toList() : <String>[],
    );
  }
}

class SurveyMapper {
  const SurveyMapper();

  SurveyQuestion toEntity(SurveyQuestionDto dto) => SurveyQuestion(
        id: dto.id ?? '',
        text: dto.text ?? '',
        options: dto.options,
      );

  Map<String, dynamic> answerToBody(SurveyAnswer answer) => {
        'id': answer.questionId,
        'answer': answer.answer,
      };
}

List<SurveyQuestionDto> parseQuestions(dynamic body) =>
    parseJsonList(body, SurveyQuestionDto.fromJson, 'questions');