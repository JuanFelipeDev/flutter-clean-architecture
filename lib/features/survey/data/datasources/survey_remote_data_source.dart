/// GET/PUT + `poll-assist-create`).
library;

import 'package:dio/dio.dart';

import '../models/survey_dtos.dart';

class SurveyRemoteDataSource {
  SurveyRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<SurveyQuestionDto>> fetchQuestions(String assistanceId) async {
    final res = await _dio.get<dynamic>(
      'soaang-quality-assurance/api/assistances-quality-questions/quality-survey/$assistanceId/',
    );
    return parseQuestions(res.data);
  }

  Future<void> submit(
    String assistanceId,
    List<Map<String, dynamic>> answers,
  ) async {
    await _dio.put<dynamic>(
      'soaang-quality-assurance/api/assistances-quality-questions/quality-survey/$assistanceId/',
      data: {'answers': answers},
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
