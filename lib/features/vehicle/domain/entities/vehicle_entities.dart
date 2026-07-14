/// Vehicle entities (AFILIADO `vehicle/` `VehicleRegister` / `CreateVehicle` /
/// `BrandsVehicleResponse` / `ModelsVehicleResponse`).
library;

/// An affiliate vehicle (AFILIADO `GetVehiclesResponseNew`).
class Vehicle {
  const Vehicle({
    required this.id,
    this.plate,
    this.brandId,
    this.modelId,
    this.brand,
    this.model,
    this.color,
    this.type,
  });
  final String id;
  final String? plate;
  final String? brandId;
  final String? modelId;
  final String? brand;
  final String? model;
  final String? color;
  final String? type;
}

/// A vehicle brand (AFILIADO `soaang-catalogs/api/parameters/brands/`).
class Brand {
  const Brand({required this.id, required this.name});
  final String id;
  final String name;
}

/// A vehicle model under a brand (AFILIADO `soaang-catalogs/api/parameters/models`).
class VehicleModel {
  const VehicleModel({required this.id, required this.brandId, required this.name});
  final String id;
  final String brandId;
  final String name;
}