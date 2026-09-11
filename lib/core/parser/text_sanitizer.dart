/// Strips zero-width and directional Unicode markers and normalizes spaces in WhatsApp chat exports.
class TextSanitizer {
  const TextSanitizer._();

  /// Zero-width and directional Unicode characters to strip:
  /// - \u200E: Left-to-Right Mark (LRM)
  /// - \u200F: Right-to-Left Mark (RLM)
  /// - \uFEFF: Zero-Width No-Break Space (BOM)
  /// - \u200B: Zero-Width Space (ZWSP)
  /// - \u200C: Zero-Width Non-Joiner (ZWNJ)
  ///
  /// Non-standard spaces to convert to regular space (' '):
  /// - \u00A0: Non-Breaking Space (NBSP)
  /// - \u202F: Narrow Non-Breaking Space (NNBSP)
  /// - \u2007: Figure Space
  /// - \u2009: Thin Space
  static String sanitizeLine(String line) {
    return line
        .replaceAll('\u200E', '') // LRM
        .replaceAll('\u200F', '') // RLM
        .replaceAll('\uFEFF', '') // BOM
        .replaceAll('\u200B', '') // ZWSP
        .replaceAll('\u200C', '') // ZWNJ
        .replaceAll('\u00A0', ' ') // NBSP
        .replaceAll('\u202F', ' ') // NNBSP
        .replaceAll('\u2007', ' ') // Figure space
        .replaceAll('\u2009', ' '); // Thin space
  }

  /// Sanitizes an entire text content.
  static String sanitize(String text) {
    return sanitizeLine(text);
  }
}
