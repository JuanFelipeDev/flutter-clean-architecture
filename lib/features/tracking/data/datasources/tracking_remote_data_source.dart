/// `stage-update/{assId}/` PATCH, `assistance-app-panic/`).
library;

import 'package:dio/dio.dart';

import '../models/tracking_dtos.dart';

class TrackingRemoteDataSource {
  TrackingRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<ActiveAssistanceDto>> fetchActive(String affKey) async {
    final res = await _dio.get<dynamic>(
      'soaang-assistances/api/assistances/list-afiliate-active-assistances',
      queryParameters: {'affkey': affKey},
    );
    final data = res.data;
    if (data is List) {
      return data
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (e) => ActiveAssistanceDto.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }
    if (data is Map<String, dynamic> && data['assistances'] is List) {
      return (data['assistances'] as List)
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (e) => ActiveAssistanceDto.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }
    return <ActiveAssistanceDto>[];
  }

  Future<void> stageUpdate(String assistanceId, String stage) async {
    await _dio.patch<dynamic>(
      'soaang-assistances/api/assistances/stage-update/$assistanceId/',
      data: {'stage': stage},
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> panic(String assistanceId, double lat, double lng) async {
    await _dio.post<dynamic>(
      'soaang-assistances/api/assistances/assistance-app-panic/',
      data: {'assistanceId': assistanceId, 'lat': lat, 'lng': lng},
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
