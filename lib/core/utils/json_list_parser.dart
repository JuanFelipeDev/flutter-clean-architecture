/// Shared JSON list/object parsing helpers used by feature DTOs. Eliminates
/// the repeated `whereType<Map<dynamic, dynamic>>().map(...)` boilerplate
/// that was duplicated across every feature's data layer (DRY).
library;

/// Extracts a list of typed JSON objects from a response body, optionally
/// pulling it out of a wrapper map by [key].
List<Map<String, dynamic>> jsonObjectList(dynamic body, [String? key]) {
  List<Map<String, dynamic>> extract(List<dynamic> l) =>
      l.whereType<Map<dynamic, dynamic>>().map((e) => Map<String, dynamic>.from(e)).toList();

  if (body is List) return extract(body);
  if (body is Map<String, dynamic> && key != null && body[key] is List) {
    return extract(body[key] as List);
  }
  return const <Map<String, dynamic>>[];
}

/// Maps a response body into a list of DTOs via [fromJson], optionally reading
/// the list from a wrapper map by [key].
List<T> parseJsonList<T>(
  dynamic body,
  T Function(Map<String, dynamic>) fromJson, [
  String? key,
]) =>
    jsonObjectList(body, key).map(fromJson).toList();