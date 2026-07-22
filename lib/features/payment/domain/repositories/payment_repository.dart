/// `listar_compras_afiliado/`, `cancelar_pago_afiliado`, paymob, upgrade).
library;

import '../../../../core/error/result.dart';
import '../entities/payment_entities.dart';

abstract class PaymentRepository {
  Future<Result<List<ShopPlan>>> plans(String affKey);
  Future<Result<List<ShopService>>> uniqueServices(String affKey);
  Future<Result<List<Purchase>>> purchases(String affKey);
  Future<Result<PaymentResult>> pay(List<Purchase> cart);
  Future<Result<void>> cancelPurchase(String purchaseId);
  Future<Result<void>> upgradeAccount(String affKey);
}
