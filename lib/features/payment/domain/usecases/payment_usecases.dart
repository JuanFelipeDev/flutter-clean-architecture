/// Payment use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/payment_entities.dart';
import '../repositories/payment_repository.dart';

class GetPlansUseCase {
  GetPlansUseCase(this._repository);
  final PaymentRepository _repository;
  Future<Result<List<ShopPlan>>> call(String affKey) =>
      _repository.plans(affKey);
}

class GetUniqueServicesUseCase {
  GetUniqueServicesUseCase(this._repository);
  final PaymentRepository _repository;
  Future<Result<List<ShopService>>> call(String affKey) =>
      _repository.uniqueServices(affKey);
}

class GetPurchasesUseCase {
  GetPurchasesUseCase(this._repository);
  final PaymentRepository _repository;
  Future<Result<List<Purchase>>> call(String affKey) =>
      _repository.purchases(affKey);
}

class PayUseCase {
  PayUseCase(this._repository);
  final PaymentRepository _repository;
  Future<Result<PaymentResult>> call(List<Purchase> cart) =>
      _repository.pay(cart);
}

class CancelPurchaseUseCase {
  CancelPurchaseUseCase(this._repository);
  final PaymentRepository _repository;
  Future<Result<void>> call(String purchaseId) =>
      _repository.cancelPurchase(purchaseId);
}

class UpgradeAccountUseCase {
  UpgradeAccountUseCase(this._repository);
  final PaymentRepository _repository;
  Future<Result<void>> call(String affKey) =>
      _repository.upgradeAccount(affKey);
}
