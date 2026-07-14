/// Payment screen — plans / unique services / cart with checkout via paymob,
/// plus past purchases and account upgrade (AFILIADO `PlansShopActivity` /
/// `UniqueServicesActivity` / shopping list). The paymob webview handoff is a
/// Phase 6 polish; here checkout returns a redirect URL surfaced to the user.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/payment_entities.dart';
import '../providers/payment_providers.dart';
import '../states/payment_state.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(paymentProvider, _onChanged);
      ref.read(paymentProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _onChanged(PaymentState? previous, PaymentState next) {
    if (next.status == PaymentStatus.success) {
      context.showToast(next.paymentUrl ?? 'Payment successful', kind: ToastKind.success);
    } else if (next.status == PaymentStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        bottom: TabBar(
          controller: _tab,
          onTap: (i) => ref.read(paymentProvider.notifier).setTab(PaymentTab.values[i]),
          tabs: const [
            Tab(text: 'Plans'),
            Tab(text: 'Services'),
            Tab(text: 'Cart'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => ref.read(paymentProvider.notifier).upgrade(),
            child: const Text('Upgrade'),
          ),
        ],
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == PaymentStatus.loading,
          child: TabBarView(
            controller: _tab,
            children: [
              _PlansTab(plans: state.plans, onAdd: ref.read(paymentProvider.notifier).addPlan),
              _ServicesTab(
                services: state.services,
                onAdd: ref.read(paymentProvider.notifier).addService,
              ),
              _CartTab(
                state: state,
                onRemove: ref.read(paymentProvider.notifier).removeFromCart,
                onCheckout: ref.read(paymentProvider.notifier).checkout,
                onCancel: ref.read(paymentProvider.notifier).cancelPurchase,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlansTab extends StatelessWidget {
  const _PlansTab({required this.plans, required this.onAdd});
  final List<ShopPlan> plans;
  final void Function(ShopPlan) onAdd;

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) return const Center(child: Text('No plans'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, i) {
        final p = plans[i];
        return ListTile(
          title: Text(p.name),
          subtitle: Text('${p.currency ?? ''} ${p.price.toStringAsFixed(2)}'),
          trailing: IconButton.filled(icon: const Icon(Icons.add), onPressed: () => onAdd(p)),
        );
      },
    );
  }
}

class _ServicesTab extends StatelessWidget {
  const _ServicesTab({required this.services, required this.onAdd});
  final List<ShopService> services;
  final void Function(ShopService) onAdd;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return const Center(child: Text('No services'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, i) {
        final s = services[i];
        return ListTile(
          title: Text(s.name),
          subtitle: Text('${s.currency ?? ''} ${s.price.toStringAsFixed(2)}'),
          trailing: IconButton.filled(icon: const Icon(Icons.add), onPressed: () => onAdd(s)),
        );
      },
    );
  }
}

class _CartTab extends StatelessWidget {
  const _CartTab({
    required this.state,
    required this.onRemove,
    required this.onCheckout,
    required this.onCancel,
  });
  final PaymentState state;
  final void Function(String) onRemove;
  final Future<void> Function() onCheckout;
  final Future<void> Function(String) onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: ${state.cartTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium),
              FilledButton(
                onPressed: state.cart.isEmpty || state.status == PaymentStatus.paying
                    ? null
                    : () => onCheckout(),
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: state.cart.isEmpty && state.purchases.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView(
                  children: [
                    for (final p in state.cart)
                      ListTile(
                        title: Text(p.name),
                        subtitle: Text('${p.total.toStringAsFixed(2)} x${p.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => onRemove(p.id),
                        ),
                      ),
                    if (state.purchases.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Past purchases'),
                      ),
                      for (final p in state.purchases)
                        ListTile(
                          title: Text(p.name),
                          trailing: TextButton(
                            onPressed: () => onCancel(p.id),
                            child: const Text('Cancel'),
                          ),
                        ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}