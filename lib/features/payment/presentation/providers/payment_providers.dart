/// Riverpod wiring for the payment feature. [PaymentNotifier] loads the
/// plans / unique services / past purchases, maintains an in-memory cart, and
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/payment_remote_data_source.dart';
import '../../data/models/payment_dtos.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/entities/payment_entities.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/payment_usecases.dart';
import '../states/payment_state.dart';

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((
  ref,
) {
  return PaymentRemoteDataSource(ref.watch(dioProvider));
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    remoteDataSource: ref.watch(paymentRemoteDataSourceProvider),
    mapper: const PaymentMapper(),
  );
});

final getPlansUseCaseProvider = Provider<GetPlansUseCase>((ref) {
  return GetPlansUseCase(ref.watch(paymentRepositoryProvider));
});

final getUniqueServicesUseCaseProvider = Provider<GetUniqueServicesUseCase>((
  ref,
) {
  return GetUniqueServicesUseCase(ref.watch(paymentRepositoryProvider));
});

final getPurchasesUseCaseProvider = Provider<GetPurchasesUseCase>((ref) {
  return GetPurchasesUseCase(ref.watch(paymentRepositoryProvider));
});

final payUseCaseProvider = Provider<PayUseCase>((ref) {
  return PayUseCase(ref.watch(paymentRepositoryProvider));
});

final cancelPurchaseUseCaseProvider = Provider<CancelPurchaseUseCase>((ref) {
  return CancelPurchaseUseCase(ref.watch(paymentRepositoryProvider));
});

final upgradeAccountUseCaseProvider = Provider<UpgradeAccountUseCase>((ref) {
  return UpgradeAccountUseCase(ref.watch(paymentRepositoryProvider));
});

class PaymentNotifier extends Notifier<PaymentState> {
  @override
  PaymentState build() => const PaymentState(status: PaymentStatus.loading);

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  Future<void> load() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(
        status: PaymentStatus.failure,
        errorMessage: 'No session',
      );
      return;
    }
    state = state.copyWith(status: PaymentStatus.loading, errorMessage: '');
    final plans = await ref.read(getPlansUseCaseProvider).call(affKey);
    final services = await ref
        .read(getUniqueServicesUseCaseProvider)
        .call(affKey);
    final purchases = await ref.read(getPurchasesUseCaseProvider).call(affKey);

    state = state.copyWith(
      plans: plans.getOrNull() ?? const [],
      services: services.getOrNull() ?? const [],
      purchases: purchases.getOrNull() ?? const [],
      status: PaymentStatus.idle,
    );
  }

  void setTab(PaymentTab tab) => state = state.copyWith(tab: tab);

  void addPlan(ShopPlan plan) {
    final cart = List<Purchase>.from(state.cart);
    cart.add(
      Purchase(
        id: 'plan-${plan.id}',
        itemType: PaymentItemType.plan,
        itemId: plan.id,
        name: plan.name,
        price: plan.price,
      ),
    );
    state = state.copyWith(cart: cart);
  }

  void addService(ShopService service) {
    final cart = List<Purchase>.from(state.cart);
    cart.add(
      Purchase(
        id: 'svc-${service.id}',
        itemType: PaymentItemType.service,
        itemId: service.id,
        name: service.name,
        price: service.price,
      ),
    );
    state = state.copyWith(cart: cart);
  }

  void removeFromCart(String purchaseId) {
    state = state.copyWith(
      cart: state.cart.where((p) => p.id != purchaseId).toList(),
    );
  }

  Future<void> checkout() async {
    if (state.cart.isEmpty) return;
    state = state.copyWith(status: PaymentStatus.paying, errorMessage: '');
    final result = await ref.read(payUseCaseProvider).call(state.cart);
    result.fold(
      onSuccess: (payment) {
        if (payment.success) {
          state = state.copyWith(
            status: PaymentStatus.success,
            cart: const [],
            paymentUrl: payment.paymentUrl,
          );
        } else {
          state = state.copyWith(
            status: PaymentStatus.failure,
            errorMessage: payment.message ?? 'Payment failed',
          );
        }
      },
      onFailure: (failure) => state = state.copyWith(
        status: PaymentStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> cancelPurchase(String purchaseId) async {
    final result = await ref
        .read(cancelPurchaseUseCaseProvider)
        .call(purchaseId);
    result.fold(
      onSuccess: (_) => state = state.copyWith(
        purchases: state.purchases.where((p) => p.id != purchaseId).toList(),
      ),
      onFailure: (failure) => state = state.copyWith(
        status: PaymentStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> upgrade() async {
    final affKey = _affKey;
    if (affKey == null) return;
    state = state.copyWith(status: PaymentStatus.loading, errorMessage: '');
    final result = await ref.read(upgradeAccountUseCaseProvider).call(affKey);
    result.fold(
      onSuccess: (_) => state = state.copyWith(status: PaymentStatus.success),
      onFailure: (failure) => state = state.copyWith(
        status: PaymentStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }
}

final paymentProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  PaymentNotifier.new,
);
