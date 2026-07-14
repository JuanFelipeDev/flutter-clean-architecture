/// DTOs + mapper for chat (AFILIADO `MessageChat` / `HistoryChat` /
/// `SendMessageContent`).
library;

import 'dart:convert';

import '../../domain/entities/chat_entities.dart';
import '../../../../core/utils/json_list_parser.dart';

class ChatMessageDto {
  const ChatMessageDto({
    this.id,
    this.assistanceId,
    this.content,
    this.username,
    this.typeUser,
    this.createdAt,
  });

  final String? id;
  final String? assistanceId;
  final String? content;
  final String? username;
  final String? typeUser;
  final String? createdAt;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) => ChatMessageDto(
        id: json['_id']?.toString() ?? json['id']?.toString(),
        assistanceId: json['assistanceId']?.toString() ?? json['idasistencia']?.toString(),
        content: json['msContent']?.toString() ?? json['content']?.toString(),
        username: json['username']?.toString(),
        typeUser: json['msTypeUser']?.toString() ?? json['typeUser']?.toString(),
        createdAt: json['msCreatedAt']?.toString() ?? json['createdAt']?.toString(),
      );
}

class ChatMapper {
  const ChatMapper();

  ChatMessage toEntity(ChatMessageDto dto) => ChatMessage(
        id: dto.id ?? '',
        assistanceId: dto.assistanceId ?? '',
        content: dto.content ?? '',
        username: dto.username ?? '',
        typeUser: dto.typeUser ?? 'aff',
        createdAt: _parseDate(dto.createdAt),
      );

  /// Parses an incoming socket payload (AFILIADO `onNewMessage` JSON) into a
  /// [ChatMessage]. Returns null when the payload has no content.
  ChatMessage? toEntityFromSocket(Map<String, dynamic> payload) {
    final content = payload['msContent']?.toString() ?? payload['content']?.toString();
    if (content == null || content.isEmpty) return null;
    return ChatMessage(
      id: payload['_id']?.toString() ?? payload['id']?.toString() ?? '',
      assistanceId:
          payload['assistanceId']?.toString() ?? payload['idasistencia']?.toString() ?? '',
      content: content,
      username: payload['username']?.toString() ?? '',
      typeUser: payload['msTypeUser']?.toString() ?? payload['typeUser']?.toString() ?? 'prov',
      createdAt: _parseDate(payload['msCreatedAt']?.toString() ?? payload['createdAt']?.toString()),
    );
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Map<String, dynamic> sendBody(String assistanceId, String content) => {
        'assistanceId': assistanceId,
        'msContent': content,
      };
}

List<ChatMessageDto> parseMessages(dynamic body) {
  var list = jsonObjectList(body);
  if (list.isEmpty && body is Map<String, dynamic>) {
    final msgs = body['messages'] ?? body['results'];
    if (msgs is List) list = jsonObjectList(msgs);
  }
  return list.map(ChatMessageDto.fromJson).toList();
}

// Unused but kept for parity with other features' json helpers.
// ignore: unused_element
Map<String, dynamic>? tryParseJson(String raw) {
  final decoded = jsonDecode(raw);
  return decoded is Map<String, dynamic> ? decoded : null;
}