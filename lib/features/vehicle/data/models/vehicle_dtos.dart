/// DTOs + mapper for vehicle (AFILIADO `GetVehiclesResponseNew` /
/// `BrandsVehicleResponseNew` / `ModelsVehicleResponse` / `CreateVehicle`).
library;

import 'dart:convert';

import '../../domain/entities/vehicle_entities.dart';

class VehicleDto {
  const VehicleDto({this.id, this.plate, this.brandId, this.modelId, this.brand, this.model, this.color, this.type});
  final String? id;
  final String? plate;
  final String? brandId;
  final String? modelId;
  final String? brand;
  final String? model;
  final String? color;
  final String? type;

  factory VehicleDto.fromJson(Map<String, dynamic> json) => VehicleDto(
        id: json['id']?.toString() ?? json['avId']?.toString() ?? json['idVehicle']?.toString(),
        plate: json['plate']?.toString() ?? json['placa']?.toString(),
        brandId: json['brandId']?.toString() ?? json['vbId']?.toString() ?? json['id_marca']?.toString(),
        modelId: json['modelId']?.toString() ?? json['vmId']?.toString() ?? json['id_modelo']?.toString(),
        brand: json['brand']?.toString() ?? json['marca']?.toString(),
        model: json['model']?.toString() ?? json['modelo']?.toString(),
        color: json['color']?.toString() ?? json['color']?.toString(),
        type: json['type']?.toString() ?? json['tipo']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'plate': plate,
        'brandId': brandId,
        'modelId': modelId,
        'color': color,
        'type': type,
      };
}

class BrandDto {
  const BrandDto({this.id, this.name});
  final String? id;
  final String? name;
  factory BrandDto.fromJson(Map<String, dynamic> json) => BrandDto(
        id: json['vbId']?.toString() ?? json['id']?.toString() ?? json['id_marca']?.toString(),
        name: json['vbName']?.toString() ?? json['name']?.toString() ?? json['marca']?.toString(),
      );
}

class VehicleModelDto {
  const VehicleModelDto({this.id, this.brandId, this.name});
  final String? id;
  final String? brandId;
  final String? name;
  factory VehicleModelDto.fromJson(Map<String, dynamic> json) => VehicleModelDto(
        id: json['vmId']?.toString() ?? json['id']?.toString() ?? json['id_modelo']?.toString(),
        brandId: json['vbId']?.toString() ?? json['brandId']?.toString(),
        name: json['vmName']?.toString() ?? json['name']?.toString() ?? json['modelo']?.toString(),
      );
}

class VehicleMapper {
  const VehicleMapper();

  Vehicle toEntity(VehicleDto dto) => Vehicle(
        id: dto.id ?? '',
        plate: dto.plate,
        brandId: dto.brandId,
        modelId: dto.modelId,
        brand: dto.brand,
        model: dto.model,
        color: dto.color,
        type: dto.type,
      );

  VehicleDto toDto(Vehicle vehicle) => VehicleDto(
        id: vehicle.id,
        plate: vehicle.plate,
        brandId: vehicle.brandId,
        modelId: vehicle.modelId,
        brand: vehicle.brand,
        model: vehicle.model,
        color: vehicle.color,
        type: vehicle.type,
      );

  Brand toBrand(BrandDto dto) => Brand(id: dto.id ?? '', name: dto.name ?? '');
  VehicleModel toModel(VehicleModelDto dto) =>
      VehicleModel(id: dto.id ?? '', brandId: dto.brandId ?? '', name: dto.name ?? '');
}

List<T> _listFrom<T>(dynamic body, T Function(Map<String, dynamic>) fromJson, [String? key]) {
  List<Map<String, dynamic>> extract(List<dynamic> l) =>
      l.whereType<Map<dynamic, dynamic>>().map((e) => Map<String, dynamic>.from(e)).toList();
  if (body is List) return extract(body).map(fromJson).toList();
  if (body is Map<String, dynamic> && key != null && body[key] is List) {
    return extract(body[key] as List).map(fromJson).toList();
  }
  return <T>[];
}

T? _single<T>(dynamic body, T Function(Map<String, dynamic>) fromJson) {
  if (body is Map<String, dynamic>) return fromJson(body);
  if (body is String) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return fromJson(decoded);
  }
  return null;
}

List<VehicleDto> parseVehicles(dynamic body) => _listFrom(body, VehicleDto.fromJson, 'vehicles');
List<BrandDto> parseBrands(dynamic body) => _listFrom(body, BrandDto.fromJson, 'brands');
List<VehicleModelDto> parseModels(dynamic body) => _listFrom(body, VehicleModelDto.fromJson, 'models');
VehicleDto? parseVehicle(dynamic body) => _single(body, VehicleDto.fromJson);