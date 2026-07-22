/// history + `soaang-notifier/chat-messages/` send).
library;

import 'package:dio/dio.dart';

import '../models/chat_dtos.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<ChatMessageDto>> fetchHistory(
    String assistanceId, {
    int page = 1,
  }) async {
    final res = await _dio.get<dynamic>(
      'soaang-historic/api/messages/',
      queryParameters: {'assistanceId': assistanceId, 'page': page},
    );
    return parseMessages(res.data);
  }

  Future<void> send(String assistanceId, String content) async {
    await _dio.post<dynamic>(
      'soaang-notifier/chat-messages/',
      data: <String, dynamic>{
        'assistanceId': assistanceId,
        'msContent': content,
      },
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
