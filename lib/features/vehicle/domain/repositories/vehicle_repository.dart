/// `create-affiliate-vehicle`, `disable-affiliate-vehicle`, brands, models).
library;

import '../../../../core/error/result.dart';
import '../entities/vehicle_entities.dart';

abstract class VehicleRepository {
  Future<Result<List<Vehicle>>> list(String affKey);
  Future<Result<Vehicle>> create(String affKey, Vehicle vehicle);
  Future<Result<void>> disable(String vehicleId);
  Future<Result<List<Brand>>> brands();
  Future<Result<List<VehicleModel>>> models(String brandId);
}
