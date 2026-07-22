/// [SurveyRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/survey_entities.dart';
import '../../domain/repositories/survey_repository.dart';
import '../datasources/survey_remote_data_source.dart';
import '../models/survey_dtos.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  SurveyRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final SurveyRemoteDataSource remoteDataSource;
  final SurveyMapper mapper;

  @override
  Future<Result<List<SurveyQuestion>>> questions(String assistanceId) async {
    try {
      final dtos = await remoteDataSource.fetchQuestions(assistanceId);
      return Success(dtos.map(mapper.toEntity).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> submit(
    String assistanceId,
    List<SurveyAnswer> answers,
  ) async {
    try {
      final body = answers.map(mapper.answerToBody).toList();
      await remoteDataSource.submit(assistanceId, body);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}
