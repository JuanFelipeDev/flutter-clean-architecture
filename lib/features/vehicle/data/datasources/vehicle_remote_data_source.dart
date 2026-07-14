/// Remote data source for vehicle (AFILIADO `list-affiliate-vehicles`,
/// `create-affiliate-vehicle`, `disable-affiliate-vehicle`, brands, models).
library;

import 'package:dio/dio.dart';

import '../models/vehicle_dtos.dart';

class VehicleRemoteDataSource {
  VehicleRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<VehicleDto>> fetchList(String affKey) async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/affiliate/list-affiliate-vehicles/$affKey/',
    );
    return parseVehicles(res.data);
  }

  Future<VehicleDto> create(String affKey, VehicleDto dto) async {
    final res = await _dio.post<dynamic>(
      'soaang-catalogs/api/affiliate/create-affiliate-vehicle/$affKey/',
      data: dto.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return parseVehicle(res.data) ?? dto;
  }

  Future<void> disable(String vehicleId) async {
    await _dio.delete<dynamic>('soaang-catalogs/api/affiliate/disable-affiliate-vehicle/$vehicleId/');
  }

  Future<List<BrandDto>> fetchBrands() async {
    final res = await _dio.get<dynamic>('soaang-catalogs/api/parameters/brands/');
    return parseBrands(res.data);
  }

  Future<List<VehicleModelDto>> fetchModels(String brandId) async {
    final res = await _dio.get<dynamic>(
      'soaang-catalogs/api/parameters/models',
      queryParameters: {'vbId': brandId},
    );
    return parseModels(res.data);
  }
}