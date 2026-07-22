/// String conveniences used by validators / mappers.
library;

extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank;

  /// Parses a hex color (`#RRGGBB`, `0xFFRRGGBB`, `RRGGBB`) to an [int].
  int? toColorInt() {
    final cleaned = replaceAll('#', '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned.startsWith('0x') ? cleaned : '0x$cleaned');
  }
}
