/// Vehicle UI state (AFILIADO `VehiclesActivity` + `AddVehicleActivity` +
/// `ListBrandsActivity` / `ListModelsActivity` cascade).
library;

import '../../domain/entities/vehicle_entities.dart';

enum VehicleStatus { idle, loading, saving, failure }

class VehicleState {
  const VehicleState({
    this.vehicles = const [],
    this.brands = const [],
    this.models = const [],
    this.status = VehicleStatus.idle,
    this.errorMessage,
  });

  final List<Vehicle> vehicles;
  final List<Brand> brands;
  final List<VehicleModel> models;
  final VehicleStatus status;
  final String? errorMessage;

  VehicleState copyWith({
    List<Vehicle>? vehicles,
    List<Brand>? brands,
    List<VehicleModel>? models,
    VehicleStatus? status,
    String? errorMessage,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      brands: brands ?? this.brands,
      models: models ?? this.models,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}