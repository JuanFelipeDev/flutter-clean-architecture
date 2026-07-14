import 'package:affiliate_app/core/error/result.dart';
import 'package:affiliate_app/core/session/session_data.dart';
import 'package:affiliate_app/core/session/session_providers.dart';
import 'package:affiliate_app/features/payment/data/models/payment_dtos.dart';
import 'package:affiliate_app/features/payment/domain/entities/payment_entities.dart';
import 'package:affiliate_app/features/payment/domain/repositories/payment_repository.dart';
import 'package:affiliate_app/features/payment/presentation/providers/payment_providers.dart';
import 'package:affiliate_app/features/payment/presentation/states/payment_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePaymentRepository implements PaymentRepository {
  _FakePaymentRepository({this.paymentSuccess = true});
  final bool paymentSuccess;

  @override
  Future<Result<List<ShopPlan>>> plans(String affKey) async =>
      const Success([ShopPlan(id: 'p1', name: 'Plan 1', price: 10, currency: 'USD')]);
  @override
  Future<Result<List<ShopService>>> uniqueServices(String affKey) async =>
      const Success([ShopService(id: 's1', name: 'Service 1', price: 5, currency: 'USD')]);
  @override
  Future<Result<List<Purchase>>> purchases(String affKey) async =>
      const Success([Purchase(id: 'old1', itemType: PaymentItemType.plan, itemId: 'p1', name: 'Old', price: 10)]);
  @override
  Future<Result<PaymentResult>> pay(List<Purchase> cart) async =>
      Success(PaymentResult(success: paymentSuccess, paymentUrl: paymentSuccess ? 'https://pay' : null));
  @override
  Future<Result<void>> cancelPurchase(String purchaseId) async => Result<void>.guard(() {});
  @override
  Future<Result<void>> upgradeAccount(String affKey) async => Result<void>.guard(() {});
}

void main() {
  const session = SessionData(accessToken: 'tok', affKey: 'aff-1');

  group('PaymentMapper', () {
    const mapper = PaymentMapper();
    test('maps plan, service, purchase, result', () {
      expect(mapper.toPlan(const ShopPlanDto(id: '1', name: 'P', price: 9)).price, 9);
      expect(mapper.toService(const ShopServiceDto(id: 's', name: 'S', price: 3)).name, 'S');
      final purchase = mapper.toPurchase(const PurchaseDto(id: 'x', itemType: 'service', itemId: 's', name: 'S', price: 3));
      expect(purchase.itemType, PaymentItemType.service);
      final result = mapper.toResult(const PaymentResultDto(success: true, paymentUrl: 'https://pay'));
      expect(result.paymentUrl, 'https://pay');
    });
  });

  group('PaymentNotifier', () {
    ProviderContainer makeContainer({bool paymentSuccess = true}) {
      return ProviderContainer(overrides: [
        cachedSessionProvider.overrideWith((_) => session),
        paymentRepositoryProvider.overrideWithValue(_FakePaymentRepository(paymentSuccess: paymentSuccess)),
      ]);
    }

    test('loads plans, services and purchases', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(paymentProvider.notifier);
      await notifier.load();
      final state = container.read(paymentProvider);
      expect(state.plans, hasLength(1));
      expect(state.services, hasLength(1));
      expect(state.purchases, hasLength(1));
    });

    test('cart add/remove and total', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(paymentProvider.notifier);
      await notifier.load();
      notifier.addPlan(container.read(paymentProvider).plans.first);
      notifier.addService(container.read(paymentProvider).services.first);
      expect(container.read(paymentProvider).cart, hasLength(2));
      expect(container.read(paymentProvider).cartTotal, 15);
      notifier.removeFromCart('plan-p1');
      expect(container.read(paymentProvider).cart, hasLength(1));
    });

    test('checkout succeeds and clears the cart', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(paymentProvider.notifier);
      await notifier.load();
      notifier.addPlan(container.read(paymentProvider).plans.first);
      await notifier.checkout();
      final state = container.read(paymentProvider);
      expect(state.status, PaymentStatus.success);
      expect(state.cart, isEmpty);
      expect(state.paymentUrl, 'https://pay');
    });

    test('checkout fails when payment rejected', () async {
      final container = makeContainer(paymentSuccess: false);
      addTearDown(container.dispose);
      final notifier = container.read(paymentProvider.notifier);
      await notifier.load();
      notifier.addPlan(container.read(paymentProvider).plans.first);
      await notifier.checkout();
      expect(container.read(paymentProvider).status, PaymentStatus.failure);
    });

    test('cancelPurchase removes the past purchase', () async {
      final container = makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(paymentProvider.notifier);
      await notifier.load();
      await notifier.cancelPurchase('old1');
      expect(container.read(paymentProvider).purchases, isEmpty);
    });
  });
}