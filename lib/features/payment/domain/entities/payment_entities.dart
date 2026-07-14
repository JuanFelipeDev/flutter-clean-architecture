/// Payment entities (AFILIADO `payment/` plans shop, unique services, cart,
/// paymob + upgrade account).
library;

/// What a shop item can be (AFILIADO `PlanShopTypeActivity`).
enum PaymentItemType { plan, service }

/// A purchasable plan (AFILIADO `PlansShopActivity` / `PlanVIPActivity` /
/// `PlanPremiumActivity`).
class ShopPlan {
  const ShopPlan({required this.id, required this.name, required this.price, this.currency, this.type});
  final String id;
  final String name;
  final double price;
  final String? currency;
  final String? type; // normal / vip / premium
}

/// A purchasable unique service (AFILIADO `UniqueServicesActivity`).
class ShopService {
  const ShopService({required this.id, required this.name, required this.price, this.currency, this.description});
  final String id;
  final String name;
  final double price;
  final String? currency;
  final String? description;
}

/// A cart line (AFILIADO `payment/internal` `Purchase`).
class Purchase {
  const Purchase({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
  final String id;
  final PaymentItemType itemType;
  final String itemId;
  final String name;
  final double price;
  final int quantity;

  double get total => price * quantity;
}

/// Result of a paymob payment creation (AFILIADO
/// `soaang-payments/payment-with-provider/paymob` -> redirect URL).
class PaymentResult {
  const PaymentResult({required this.success, this.paymentUrl, this.referenceId, this.message});
  final bool success;
  final String? paymentUrl;
  final String? referenceId;
  final String? message;
}