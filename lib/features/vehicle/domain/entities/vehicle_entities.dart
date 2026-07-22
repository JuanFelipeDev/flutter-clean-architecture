/// `BrandsVehicleResponse` / `ModelsVehicleResponse`).
library;

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

class Brand {
  const Brand({required this.id, required this.name});
  final String id;
  final String name;
}

class VehicleModel {
  const VehicleModel({
    required this.id,
    required this.brandId,
    required this.name,
  });
  final String id;
  final String brandId;
  final String name;
}
