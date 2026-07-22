/// [RegistrationRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/registration_entities.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_remote_data_source.dart';
import '../models/registration_dtos.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  RegistrationRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  final RegistrationRemoteDataSource remoteDataSource;
  final RegistrationMapper mapper;

  @override
  Future<Result<RegisterResult>> register({
    required String affkey,
    required Map<String, String> fields,
    required String clientId,
  }) async {
    try {
      final dto = await remoteDataSource.register(
        affkey: affkey,
        fields: fields,
        clientId: clientId,
      );
      return Success(mapper.toRegisterResult(dto));
    } on DioException catch (error) {
      return Err(mapDioError(error));
    } on Object catch (error, stackTrace) {
      return Err(Failure.unknown(error, stackTrace));
    }
  }
}
