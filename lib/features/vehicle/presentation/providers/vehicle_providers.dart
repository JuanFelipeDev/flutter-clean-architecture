/// Riverpod wiring for the vehicle feature. [VehicleNotifier] loads the
/// affiliate vehicles + brands; selecting a brand loads its models (AFILIADO
/// brand->model cascade). Supports create + disable.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/vehicle_remote_data_source.dart';
import '../../data/models/vehicle_dtos.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../domain/entities/vehicle_entities.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/usecases/vehicle_usecases.dart';
import '../states/vehicle_state.dart';

final vehicleRemoteDataSourceProvider = Provider<VehicleRemoteDataSource>((ref) {
  return VehicleRemoteDataSource(ref.watch(dioProvider));
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(
    remoteDataSource: ref.watch(vehicleRemoteDataSourceProvider),
    mapper: const VehicleMapper(),
  );
});

final getVehiclesUseCaseProvider = Provider<GetVehiclesUseCase>((ref) {
  return GetVehiclesUseCase(ref.watch(vehicleRepositoryProvider));
});

final createVehicleUseCaseProvider = Provider<CreateVehicleUseCase>((ref) {
  return CreateVehicleUseCase(ref.watch(vehicleRepositoryProvider));
});

final disableVehicleUseCaseProvider = Provider<DisableVehicleUseCase>((ref) {
  return DisableVehicleUseCase(ref.watch(vehicleRepositoryProvider));
});

final getBrandsUseCaseProvider = Provider<GetBrandsUseCase>((ref) {
  return GetBrandsUseCase(ref.watch(vehicleRepositoryProvider));
});

final getModelsUseCaseProvider = Provider<GetModelsUseCase>((ref) {
  return GetModelsUseCase(ref.watch(vehicleRepositoryProvider));
});

class VehicleNotifier extends Notifier<VehicleState> {
  @override
  VehicleState build() => const VehicleState(status: VehicleStatus.loading);

  String? get _affKey => ref.read(cachedSessionProvider)?.affKey;

  Future<void> load() async {
    final affKey = _affKey;
    if (affKey == null) {
      state = state.copyWith(status: VehicleStatus.failure, errorMessage: 'No session');
      return;
    }
    state = state.copyWith(status: VehicleStatus.loading, errorMessage: '');
    final vehicles = await ref.read(getVehiclesUseCaseProvider).call(affKey);
    final brands = await ref.read(getBrandsUseCaseProvider).call();
    state = state.copyWith(
      vehicles: vehicles.getOrNull() ?? const [],
      brands: brands.getOrNull() ?? const [],
      status: VehicleStatus.idle,
    );
  }

  /// Loads models for [brandId] (AFILIADO `info_modelos` / parameters/models).
  Future<void> selectBrand(String brandId) async {
    final models = await ref.read(getModelsUseCaseProvider).call(brandId);
    state = state.copyWith(models: models.getOrNull() ?? const []);
  }

  Future<void> add(Vehicle vehicle) async {
    final affKey = _affKey;
    if (affKey == null) return;
    state = state.copyWith(status: VehicleStatus.saving, errorMessage: '');
    final result = await ref.read(createVehicleUseCaseProvider).call(affKey, vehicle);
    result.fold(
      onSuccess: (created) => state = state.copyWith(
        vehicles: [...state.vehicles, created],
        status: VehicleStatus.idle,
      ),
      onFailure: (failure) => state = state.copyWith(
        status: VehicleStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> remove(String vehicleId) async {
    final result = await ref.read(disableVehicleUseCaseProvider).call(vehicleId);
    result.fold(
      onSuccess: (_) => state = state.copyWith(
        vehicles: state.vehicles.where((v) => v.id != vehicleId).toList(),
      ),
      onFailure: (failure) => state = state.copyWith(
        status: VehicleStatus.failure,
        errorMessage: failure.message,
      ),
    );
  }
}

final vehicleProvider =
    NotifierProvider<VehicleNotifier, VehicleState>(VehicleNotifier.new);