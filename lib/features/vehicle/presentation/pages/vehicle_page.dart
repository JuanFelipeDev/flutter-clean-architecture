/// Vehicle screen — list + add (brand -> model cascade) + disable (AFILIADO
/// `VehiclesActivity` / `AddVehicleActivity` / `ListBrandsActivity`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/toast.dart';
import '../providers/vehicle_providers.dart';
import '../states/vehicle_state.dart';
import '../widgets/vehicle_form_sheet.dart';

class VehiclePage extends ConsumerStatefulWidget {
  const VehiclePage({super.key});

  @override
  ConsumerState<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends ConsumerState<VehiclePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(vehicleProvider, _onChanged);
      ref.read(vehicleProvider.notifier).load();
    });
  }

  void _onChanged(VehicleState? previous, VehicleState next) {
    if (next.status == VehicleStatus.failure) {
      context.showToast(next.errorMessage ?? 'Error', kind: ToastKind.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicles')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.status == VehicleStatus.loading,
          child: state.vehicles.isEmpty
              ? const Center(child: Text('No vehicles'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.vehicles.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final v = state.vehicles[i];
                    return ListTile(
                      leading: const Icon(Icons.directions_car_outlined),
                      title: Text(v.brand ?? 'Vehicle ${v.id}'),
                      subtitle: Text([
                        if (v.model != null) v.model!,
                        if (v.plate != null) v.plate!,
                        if (v.color != null) v.color!,
                      ].join(' · ')),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref.read(vehicleProvider.notifier).remove(v.id),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _openForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => VehicleFormSheet(
        brands: ref.read(vehicleProvider).brands,
        onModelsForBrand: (brandId) => ref.read(vehicleProvider.notifier).selectBrand(brandId),
        models: ref.read(vehicleProvider).models,
        onSubmit: (vehicle) => ref.read(vehicleProvider.notifier).add(vehicle),
      ),
    );
  }
}