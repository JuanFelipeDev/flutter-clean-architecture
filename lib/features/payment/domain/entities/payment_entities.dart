/// paymob + upgrade account).
library;

enum PaymentItemType { plan, service }

/// `PlanPremiumActivity`).
class ShopPlan {
  const ShopPlan({
    required this.id,
    required this.name,
    required this.price,
    this.currency,
    this.type,
  });
  final String id;
  final String name;
  final double price;
  final String? currency;
  final String? type;
}

class ShopService {
  const ShopService({
    required this.id,
    required this.name,
    required this.price,
    this.currency,
    this.description,
  });
  final String id;
  final String name;
  final double price;
  final String? currency;
  final String? description;
}

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

/// `soaang-payments/payment-with-provider/paymob` -> redirect URL).
class PaymentResult {
  const PaymentResult({
    required this.success,
    this.paymentUrl,
    this.referenceId,
    this.message,
  });
  final bool success;
  final String? paymentUrl;
  final String? referenceId;
  final String? message;
}
