/// Vehicle use cases.
library;

import '../../../../core/error/result.dart';
import '../entities/vehicle_entities.dart';
import '../repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  GetVehiclesUseCase(this._repository);
  final VehicleRepository _repository;
  Future<Result<List<Vehicle>>> call(String affKey) => _repository.list(affKey);
}

class CreateVehicleUseCase {
  CreateVehicleUseCase(this._repository);
  final VehicleRepository _repository;
  Future<Result<Vehicle>> call(String affKey, Vehicle vehicle) => _repository.create(affKey, vehicle);
}

class DisableVehicleUseCase {
  DisableVehicleUseCase(this._repository);
  final VehicleRepository _repository;
  Future<Result<void>> call(String vehicleId) => _repository.disable(vehicleId);
}

class GetBrandsUseCase {
  GetBrandsUseCase(this._repository);
  final VehicleRepository _repository;
  Future<Result<List<Brand>>> call() => _repository.brands();
}

class GetModelsUseCase {
  GetModelsUseCase(this._repository);
  final VehicleRepository _repository;
  Future<Result<List<VehicleModel>>> call(String brandId) => _repository.models(brandId);
}