/// Payment UI state (AFILIADO `PlansShopActivity` / `UniqueServicesActivity` /
/// shopping list). The cart lives in memory until checkout.
library;

import '../../domain/entities/payment_entities.dart';

enum PaymentTab { plans, services, cart }
enum PaymentStatus { idle, loading, paying, success, failure }

class PaymentState {
  const PaymentState({
    this.tab = PaymentTab.plans,
    this.plans = const [],
    this.services = const [],
    this.cart = const [],
    this.purchases = const [],
    this.status = PaymentStatus.idle,
    this.errorMessage,
    this.paymentUrl,
  });

  final PaymentTab tab;
  final List<ShopPlan> plans;
  final List<ShopService> services;
  final List<Purchase> cart;
  final List<Purchase> purchases;
  final PaymentStatus status;
  final String? errorMessage;
  final String? paymentUrl;

  double get cartTotal => cart.fold(0, (sum, p) => sum + p.total);

  PaymentState copyWith({
    PaymentTab? tab,
    List<ShopPlan>? plans,
    List<ShopService>? services,
    List<Purchase>? cart,
    List<Purchase>? purchases,
    PaymentStatus? status,
    String? errorMessage,
    String? paymentUrl,
  }) {
    return PaymentState(
      tab: tab ?? this.tab,
      plans: plans ?? this.plans,
      services: services ?? this.services,
      cart: cart ?? this.cart,
      purchases: purchases ?? this.purchases,
      status: status ?? this.status,
      errorMessage: errorMessage,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }
}