/// Beneficiary screen — list with live coordinates/state + add/edit/delete
/// (AFILIADO `BeneficiaryFragment` + `MapsBeneficiariesActivity`). The full
/// map view (google_maps_flutter) is Phase 6 polish; live coordinates render
/// per beneficiary so the realtime behavior is verifiable.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../../domain/entities/beneficiary_entities.dart';
import '../providers/beneficiary_providers.dart';
import '../states/beneficiary_state.dart';
import '../widgets/beneficiary_form_sheet.dart';

class BeneficiaryPage extends ConsumerStatefulWidget {
  const BeneficiaryPage({super.key});

  @override
  ConsumerState<BeneficiaryPage> createState() => _BeneficiaryPageState();
}

class _BeneficiaryPageState extends ConsumerState<BeneficiaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(beneficiaryProvider, _onChanged);
      ref.read(beneficiaryProvider.notifier).load();
    });
  }

  void _onChanged(BeneficiaryState? previous, BeneficiaryState next) {
    if (next.status == BeneficiaryStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(beneficiaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Beneficiaries')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, null),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == BeneficiaryStatus.loading,
          child: state.beneficiaries.isEmpty
              ? const Center(child: Text('No beneficiaries'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.beneficiaries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final b = state.beneficiaries[i];
                    final coords = state.coordinates[b.id];
                    return ListTile(
                      title: Text(b.name),
                      subtitle: Text([
                        if (b.relationship != null) b.relationship!,
                        if (b.state != null) b.state!,
                        if (coords?.lat != null)
                          '📍 ${coords!.lat!.toStringAsFixed(4)}, ${coords.lng!.toStringAsFixed(4)}',
                      ].join(' · ')),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) {
                          if (action == 'edit') {
                            _openForm(context, b);
                          } else if (action == 'delete') {
                            ref.read(beneficiaryProvider.notifier).remove(b.id);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _openForm(BuildContext context, Beneficiary? existing) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BeneficiaryFormSheet(
        relationships: ref.read(beneficiaryProvider).relationships,
        existing: existing,
        onSubmit: (beneficiary) {
          final notifier = ref.read(beneficiaryProvider.notifier);
          if (existing == null) {
            notifier.add(beneficiary);
          } else {
            notifier.edit(Beneficiary(
              id: existing.id,
              name: beneficiary.name,
              relationship: beneficiary.relationship,
              documentNumber: beneficiary.documentNumber,
            ));
          }
        },
      ),
    );
  }
}