/// Remote data source for video call (AFILIADO `VideoCallApi` recording +
/// schedule endpoints).
library;

import 'package:dio/dio.dart';

import '../models/videocall_dtos.dart';

class VideoCallRemoteDataSource {
  VideoCallRemoteDataSource(this._dio);
  final Dio _dio;

  Future<ScheduleAvailabilityDto> checkSchedule(String assistanceId) async {
    final res = await _dio.post<dynamic>(
      'api/schedule/check_quote/',
      data: {'assistanceId': assistanceId},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    final dto = ScheduleAvailabilityDto.tryParse(res.data);
    if (dto == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        message: 'Invalid schedule response',
      );
    }
    return dto;
  }

  Future<bool> requestRecordingPermission() async {
    final res = await _dio.get<dynamic>('api/schedule/check_permission_recording/');
    final data = res.data;
    if (data is Map) {
      return data['allowed'] is bool ? data['allowed'] as bool : true;
    }
    return true;
  }

  Future<void> updateRecordingPermission(bool granted) async {
    await _dio.post<dynamic>(
      'api/schedule/update_permission_recording/',
      data: {'granted': granted},
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> startRecording() async {
    await _dio.post<dynamic>(
      'recorder/v1/start/',
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<void> stopRecording() async {
    await _dio.post<dynamic>(
      'recorder/v1/stop/',
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}