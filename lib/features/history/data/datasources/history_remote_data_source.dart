/// `soaang-assistances/api/assistances/list-afiliate-assistances`).
library;

import 'package:dio/dio.dart';

import '../models/history_dtos.dart';

class HistoryRemoteDataSource {
  HistoryRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<HistoryItemDto>> fetchPage(String affKey, {int page = 1}) async {
    final res = await _dio.get<dynamic>(
      'soaang-assistances/api/assistances/list-afiliate-assistances',
      queryParameters: {'affkey': affKey, 'page': page},
    );
    return parseHistory(res.data);
  }
}
