/// Notifications screen — list with the typed AFILIADO notification kinds + an
/// unread counter badge (AFILIADO `NotificationsActivity`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../domain/entities/notification_entities.dart';
import '../providers/notifications_providers.dart';
import '../states/notifications_state.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (state.unreadCount > 0)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Badge(label: Text('${state.unreadCount}')),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == NotificationsStatus.loading,
          child: state.notifications.isEmpty
              ? const Center(child: Text('No notifications'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final n = state.notifications[i];
                    return ListTile(
                      leading: Icon(_icon(n.type),
                          color: n.read ? null : Theme.of(context).colorScheme.primary),
                      title: Text(_title(n.type)),
                      subtitle: Text(n.message ?? ''),
                      trailing: n.read
                          ? null
                          : const Icon(Icons.circle, size: 10, color: Colors.red),
                    );
                  },
                ),
        ),
      ),
    );
  }

  IconData _icon(NotificationType type) => switch (type) {
        NotificationType.supplierArrivalConfirmation => Icons.pin_drop_outlined,
        NotificationType.supplierTermConfirmation => Icons.task_alt,
        NotificationType.excedentCost1 ||
        NotificationType.excedentCost2 ||
        NotificationType.excedentCostManeuvers ||
        NotificationType.excedentConnectionSoaang => Icons.attach_money,
        NotificationType.canceledAssistance => Icons.cancel_outlined,
        NotificationType.expiredSession => Icons.logout,
        NotificationType.informativeBeneficiary => Icons.groups_outlined,
        NotificationType.serviceWithoutCoverage => Icons.block,
        NotificationType.providerAssignment ||
        NotificationType.pendingProviderAssignment ||
        NotificationType.reassignmentOfTheProvider => Icons.engineering_outlined,
        NotificationType.unknown => Icons.notifications_outlined,
      };

  String _title(NotificationType type) => switch (type) {
        NotificationType.supplierArrivalConfirmation => 'Supplier arrival',
        NotificationType.supplierTermConfirmation => 'Service completed',
        NotificationType.excedentCost1 => 'Excedent cost',
        NotificationType.excedentCost2 => 'Excedent cost',
        NotificationType.excedentCostManeuvers => 'Maneuvers excedent',
        NotificationType.excedentConnectionSoaang => 'Connection excedent',
        NotificationType.canceledAssistance => 'Assistance canceled',
        NotificationType.expiredSession => 'Session expired',
        NotificationType.informativeBeneficiary => 'Beneficiary update',
        NotificationType.serviceWithoutCoverage => 'Without coverage',
        NotificationType.providerAssignment => 'Provider assigned',
        NotificationType.pendingProviderAssignment => 'Pending provider',
        NotificationType.reassignmentOfTheProvider => 'Provider reassigned',
        NotificationType.unknown => 'Notification',
      };
}