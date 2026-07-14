/// [PaymentRepository] implementation backed by the remote data source.
library;

import 'package:dio/dio.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/payment_entities.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';
import '../models/payment_dtos.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required this.remoteDataSource, required this.mapper});

  final PaymentRemoteDataSource remoteDataSource;
  final PaymentMapper mapper;

  @override
  Future<Result<List<ShopPlan>>> plans(String affKey) async {
    try {
      final dtos = await remoteDataSource.fetchPlans(affKey);
      return Success(dtos.map(mapper.toPlan).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<ShopService>>> uniqueServices(String affKey) async {
    try {
      final dtos = await remoteDataSource.fetchUniqueServices(affKey);
      return Success(dtos.map(mapper.toService).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<List<Purchase>>> purchases(String affKey) async {
    try {
      final dtos = await remoteDataSource.fetchPurchases(affKey);
      return Success(dtos.map(mapper.toPurchase).toList());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<PaymentResult>> pay(List<Purchase> cart) async {
    try {
      final items = cart
          .map((p) => <String, dynamic>{
                'item_type': p.itemType.name,
                'item_id': p.itemId,
                'quantity': p.quantity,
              })
          .toList();
      final dto = await remoteDataSource.pay(items);
      return Success(mapper.toResult(dto));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> cancelPurchase(String purchaseId) async {
    try {
      await remoteDataSource.cancel(purchaseId);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }

  @override
  Future<Result<void>> upgradeAccount(String affKey) async {
    try {
      await remoteDataSource.upgradeAccount(affKey);
      return Result<void>.guard(() {});
    } on DioException catch (e) {
      return Err(mapDioError(e));
    } on Object catch (e, st) {
      return Err(Failure.unknown(e, st));
    }
  }
}