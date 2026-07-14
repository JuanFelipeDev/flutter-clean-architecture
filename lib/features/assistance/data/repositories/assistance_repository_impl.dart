/// [AssistanceRepository] + [PlacesRepository] implementations.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/assistance_entities.dart';
import '../../domain/repositories/assistance_repository.dart';
import '../datasources/assistance_remote_data_source.dart';
import '../models/assistance_dtos.dart';

class AssistanceRepositoryImpl implements AssistanceRepository {
  AssistanceRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final AssistanceRemoteDataSource remoteDataSource;
  final AssistanceMapper mapper;

  @override
  Future<Result<List<Account>>> accounts(String affKey) async {
    try {
      final dtos = await remoteDataSource.fetchAccounts(affKey);
      return Success(dtos.map(mapper.toAccount).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<Plan>>> plans(String affKey, String accountId) async {
    try {
      final dtos = await remoteDataSource.fetchPlans(affKey, accountId);
      return Success(dtos.map(mapper.toPlan).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<ServiceFamily>>> families(String affKey, String planId) async {
    try {
      final dtos = await remoteDataSource.fetchFamilies(affKey, planId);
      return Success(dtos.map(mapper.toFamily).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<Service>>> services(String affKey, String planId, String familyId) async {
    try {
      final dtos = await remoteDataSource.fetchServices(affKey, planId, familyId);
      return Success(dtos.map(mapper.toService).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<CoverageQuestion>>> coverageQuestions(String serviceId) async {
    try {
      final dtos = await remoteDataSource.fetchCoverageQuestions(serviceId);
      return Success(dtos.map(mapper.toQuestion).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<Assistance>> createAssistance({
    required String affKey,
    required String serviceId,
    required String accountId,
    required String address,
    required List<CoverageAnswer> answers,
  }) async {
    try {
      final answerJson = answers
          .map((a) => <String, String>{'id': a.questionId, 'answer': a.answer})
          .toList();
      final dto = await remoteDataSource.createAssistance(
        affKey: affKey,
        serviceId: serviceId,
        accountId: accountId,
        address: address,
        answers: answerJson,
      );
      return Success(mapper.toAssistance(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}

class PlacesRepositoryImpl implements PlacesRepository {
  PlacesRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final PlacesRemoteDataSource remoteDataSource;
  final AssistanceMapper mapper;

  @override
  Future<Result<List<PlaceSuggestion>>> autocomplete(String query) async {
    try {
      final dtos = await remoteDataSource.autocomplete(query);
      return Success(dtos.map(mapper.toSuggestion).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<PlaceLocation>> placeDetails(String placeId) async {
    try {
      final dto = await remoteDataSource.placeDetails(placeId);
      return Success(mapper.toPlace(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}