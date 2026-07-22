/// `validar_servicio_programadas`, scheduled assistance creation).
library;

import 'package:dio/dio.dart';

import '../models/scheduling_dtos.dart';

class SchedulingRemoteDataSource {
  SchedulingRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<TimeSlotDto>> fetchSlots(String serviceId, String dateIso) async {
    final res = await _dio.get<dynamic>(
      'api-python/obtener_franja_horario_servicio/',
      queryParameters: {'service_id': serviceId, 'date': dateIso},
    );
    return parseSlots(res.data);
  }

  Future<ScheduleValidationDto> validate(Map<String, dynamic> body) async {
    final res = await _dio.post<dynamic>(
      'validar_servicio_programadas/',
      data: body,
      options: Options(contentType: Headers.jsonContentType),
    );
    final dto = ScheduleValidationDto.tryParse(res.data);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid schedule validation response',
      );
    }
    return dto;
  }

  Future<void> schedule(Map<String, dynamic> body) async {
    await _dio.post<dynamic>(
      'detalle_servicio_programada/',
      data: body,
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
