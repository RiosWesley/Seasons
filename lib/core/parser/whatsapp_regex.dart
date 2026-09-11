import 'text_sanitizer.dart';

/// Parsed message header metadata.
class ParsedHeader {
  final DateTime timestamp;
  final String author;
  final String content;

  const ParsedHeader({
    required this.timestamp,
    required this.author,
    required this.content,
  });

  @override
  String toString() =>
      'ParsedHeader(timestamp: $timestamp, author: "$author", content: "$content")';
}

/// Regular expressions and detection logic for multi-format WhatsApp exports.
class WhatsAppRegex {
  const WhatsAppRegex._();

  /// Regex for Brazilian/International Dash Format:
  /// dd/MM/yyyy HH:mm - Author: message
  /// dd/MM/yyyy, HH:mm - Author: message
  /// dd/MM/yy, HH:mm - Author: message
  /// dd/MM/yyyy, hh:mm a - Author: message
  /// dd/MM/yyyy, HH:mm:ss - Author: message
  static final RegExp dateTimeDashRegex = RegExp(
    r'^(\d{1,2})[\/\.-](\d{1,2})[\/\.-](\d{2,4})(?:,\s*|\s+)(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*([aApP]\.?[mM]\.?))?\s*[-\u2013\u2014]\s*([^:]+?):\s*(.*)$',
  );

  /// Regex for iOS Bracketed Format:
  /// [dd/MM/yyyy, HH:mm:ss] Author: message
  /// [dd/MM/yyyy, HH:mm] Author: message
  /// [dd/MM/yy, HH:mm:ss] Author: message
  /// [dd/MM/yyyy, hh:mm:ss a] Author: message
  static final RegExp dateTimeBracketRegex = RegExp(
    r'^\[(\d{1,2})[\/\.-](\d{1,2})[\/\.-](\d{2,4})(?:,\s*|\s+)(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*([aApP]\.?[mM]\.?))?\]\s*([^:]+?):\s*(.*)$',
  );

  /// System message with timestamp and dash:
  /// e.g. 24/04/2023 14:56 - As mensagens e ligações são protegidas...
  static final RegExp systemDashRegex = RegExp(
    r'^(\d{1,2})[\/\.-](\d{1,2})[\/\.-](\d{2,4})(?:,\s*|\s+)(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*([aApP]\.?[mM]\.?))?\s*[-\u2013\u2014]\s*(.*)$',
  );

  /// Bracketed system message:
  /// e.g. [24/04/2023, 14:56:00] As mensagens e ligações são protegidas...
  static final RegExp systemBracketRegex = RegExp(
    r'^\[(\d{1,2})[\/\.-](\d{1,2})[\/\.-](\d{2,4})(?:,\s*|\s+)(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*([aApP]\.?[mM]\.?))?\]\s*(.*)$',
  );

  /// Regex to detect if a line begins with a timestamp prefix (date and time)
  static final RegExp timestampPrefixRegex = RegExp(
    r'^(?:\[?\d{1,2}[\/\.-]\d{1,2}[\/\.-]\d{2,4}(?:,\s*|\s+)\d{1,2}:\d{2})',
  );

  /// Checks whether a line begins with a timestamp prefix (e.g. `dd/MM/yyyy HH:mm`).
  static bool hasTimestampPrefix(String line) {
    final sanitized = TextSanitizer.sanitizeLine(line).trim();
    return timestampPrefixRegex.hasMatch(sanitized);
  }

  /// Phrases identifying deleted message notices or missed calls
  static final List<String> _deletedMessagePhrases = [
    'esta mensagem foi apagada',
    'mensagem apagada',
    'você apagou esta mensagem',
    'voce apagou esta mensagem',
    'this message was deleted',
    'you deleted this message',
    'chamada de voz perdida',
    'chamada de vídeo perdida',
    'chamada de video perdida',
    'missed voice call',
    'missed video call',
  ];

  /// Checks whether text strictly represents a deleted message notice or missed call.
  static bool isDeletedMessage(String text) {
    final sanitized = TextSanitizer.sanitizeLine(text).trim().toLowerCase();
    if (sanitized.isEmpty) return false;

    final cleaned = sanitized.endsWith('.')
        ? sanitized.substring(0, sanitized.length - 1).trim()
        : sanitized;

    for (final phrase in _deletedMessagePhrases) {
      if (cleaned == phrase || cleaned.startsWith(phrase)) {
        return true;
      }
    }
    return false;
  }

  /// Encryption and security announcements that can occur with or without timestamps
  static final List<String> _encryptionAndSecurityPrefixes = [
    'criptografia de ponta a ponta',
    'end-to-end encrypt',
    'as mensagens e ligações são protegidas',
    'as mensagens e as chamadas são protegidas',
    'as mensagens para esta conversa',
    'messages and calls are end-to-end encrypted',
    'código de segurança',
    'security code',
    'mensagens temporárias',
    'disappearing messages',
  ];

  /// Patterns that, if matched in a header author field, indicate a system notification with colons
  static final List<String> _systemAuthorPatterns = [
    'criptografia de ponta a ponta',
    'end-to-end encrypt',
    'as mensagens e ligações são protegidas',
    'as mensagens e as chamadas são protegidas',
    'as mensagens para esta conversa',
    'messages and calls are end-to-end encrypted',
    'código de segurança',
    'security code',
    'mensagens temporárias',
    'disappearing messages',
    'adicionou você',
    'adicionou',
    'added',
    'removeu você',
    'removeu',
    'removed',
    'saiu do grupo',
    'left the group',
    'mudou de número',
    'mudou seu número',
    'changed their phone number',
    'entrou usando o link',
    'joined using this group',
    'criou o grupo',
    'created group',
    'mudou o nome do grupo',
    'mudou o tema',
    'mudou a imagem',
    'changed the group',
    'iniciou uma chamada',
    'chamada de voz perdida',
    'chamada de vídeo perdida',
    'missed voice call',
    'missed video call',
  ];

  static bool _isSystemAuthor(String author) {
    final lower = author.toLowerCase();
    for (final pattern in _systemAuthorPatterns) {
      if (lower.contains(pattern)) {
        return true;
      }
    }
    return false;
  }


  /// Media indicator exact phrases & markers
  static final List<String> _exactMediaMarkers = [
    '<mídia oculta>',
    '<midia oculta>',
    '<arquivo de mídia oculto>',
    '<arquivo de midia oculto>',
    '<media omitted>',
    '(arquivo anexado)',
    'arquivo anexado',
    'image omitted',
    'audio omitted',
    'video omitted',
    'sticker omitted',
    'gif omitted',
    'document omitted',
    'contact card omitted',
  ];

  /// Attempts to parse a line as a message header. Returns [ParsedHeader] or null.
  static ParsedHeader? parseHeader(String line) {
    final sanitized = TextSanitizer.sanitizeLine(line).trim();
    if (sanitized.isEmpty) return null;

    // Test dash format
    var match = dateTimeDashRegex.firstMatch(sanitized);
    if (match != null) {
      return _buildHeaderFromMatch(match);
    }

    // Test bracketed format
    match = dateTimeBracketRegex.firstMatch(sanitized);
    if (match != null) {
      return _buildHeaderFromMatch(match);
    }

    return null;
  }

  static DateTime? _buildDateFromMatch(Match match) {
    final dayStr = match.group(1);
    final monthStr = match.group(2);
    final yearStr = match.group(3);
    final hourStr = match.group(4);
    final minuteStr = match.group(5);
    final secondStr = match.group(6);
    final ampm = match.group(7);

    if (dayStr == null ||
        monthStr == null ||
        yearStr == null ||
        hourStr == null ||
        minuteStr == null) {
      return null;
    }

    int day = int.tryParse(dayStr) ?? 1;
    int month = int.tryParse(monthStr) ?? 1;
    int year = int.tryParse(yearStr) ?? 2000;
    int hour = int.tryParse(hourStr) ?? 0;
    int minute = int.tryParse(minuteStr) ?? 0;
    int second = secondStr != null ? (int.tryParse(secondStr) ?? 0) : 0;

    // Normalize 2-digit years
    if (year < 100) {
      year += 2000;
    }

    // Tolerance swap for mm/dd/yyyy if month > 12 and day <= 12
    if (month > 12 && day <= 12) {
      final temp = day;
      day = month;
      month = temp;
    }

    // Handle 12-hour AM/PM
    if (ampm != null && ampm.isNotEmpty) {
      final normalizedAmPm = ampm.toLowerCase().replaceAll('.', '').trim();
      if (normalizedAmPm == 'pm' || normalizedAmPm == 'p') {
        if (hour < 12) hour += 12;
      } else if (normalizedAmPm == 'am' || normalizedAmPm == 'a') {
        if (hour == 12) hour = 0;
      }
    }

    // Date range bounds check
    if (month < 1 ||
        month > 12 ||
        day < 1 ||
        day > 31 ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        second < 0 ||
        second > 59) {
      return null;
    }

    try {
      return DateTime(year, month, day, hour, minute, second);
    } catch (_) {
      return null;
    }
  }

  static ParsedHeader? _buildHeaderFromMatch(Match match) {
    final timestamp = _buildDateFromMatch(match);
    if (timestamp == null) return null;

    final rawAuthor = match.group(8);
    final content = match.group(9) ?? '';

    if (rawAuthor == null) return null;

    // Clean author (strip leading '~' sometimes inserted by WhatsApp)
    var author = rawAuthor.trim();
    if (author.startsWith('~')) {
      author = author.substring(1).trim();
    }

    // Reject empty author headers
    if (author.isEmpty) {
      return null;
    }

    // Reject system notifications that masquerade as authors due to colons
    if (_isSystemAuthor(author)) {
      return null;
    }

    return ParsedHeader(
      timestamp: timestamp,
      author: author,
      content: content,
    );
  }

  /// Extracts timestamp from a system message if present.
  static DateTime? extractTimestamp(String line) {
    final sanitized = TextSanitizer.sanitizeLine(line).trim();
    final dashMatch = systemDashRegex.firstMatch(sanitized);
    if (dashMatch != null) {
      return _buildDateFromMatch(dashMatch);
    }
    final bracketMatch = systemBracketRegex.firstMatch(sanitized);
    if (bracketMatch != null) {
      return _buildDateFromMatch(bracketMatch);
    }
    return null;
  }

  /// Checks whether a line represents a system notification.
  static bool isSystemMessage(String line) {
    final sanitized = TextSanitizer.sanitizeLine(line).trim();
    if (sanitized.isEmpty) return false;
    final lower = sanitized.toLowerCase();

    // 1. If line is an authored user message, only flag as system if it's a deleted message.
    // Authored messages must NEVER be classified as system messages due to conversational keywords.
    final header = parseHeader(sanitized);
    if (header != null) {
      return isDeletedMessage(header.content);
    }

    // 2. Check encryption and security notices (can occur with or without timestamp)
    for (final prefix in _encryptionAndSecurityPrefixes) {
      if (lower.contains(prefix)) {
        return true;
      }
    }

    // 3. Standalone deleted message / missed call notices (without timestamp)
    if (isDeletedMessage(sanitized)) {
      return true;
    }

    // 4. Timestamped system events (group addition, removal, exit, name change, etc.)
    final dashMatch = systemDashRegex.firstMatch(sanitized);
    if (dashMatch != null) {
      if (_buildDateFromMatch(dashMatch) != null) {
        final afterDash = dashMatch.group(8)?.trim() ?? '';
        if (!afterDash.contains(':')) {
          return true;
        } else {
          for (final keyword in _systemAuthorPatterns) {
            if (lower.contains(keyword)) {
              return true;
            }
          }
        }
      }
    }

    final bracketMatch = systemBracketRegex.firstMatch(sanitized);
    if (bracketMatch != null) {
      if (_buildDateFromMatch(bracketMatch) != null) {
        final insideBracket = bracketMatch.group(8)?.trim() ?? '';
        if (!insideBracket.contains(':')) {
          return true;
        } else {
          for (final keyword in _systemAuthorPatterns) {
            if (lower.contains(keyword)) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  /// Checks whether message content represents a media marker.
  static bool isMedia(String content) {
    final trimmed = content.trim();
    final lower = trimmed.toLowerCase();

    for (final marker in _exactMediaMarkers) {
      if (lower == marker) return true;
    }

    if (lower.startsWith('<mídia oculta') ||
        lower.startsWith('<midia oculta') ||
        lower.startsWith('<media omitted') ||
        lower.startsWith('<arquivo de mídia oculto') ||
        lower.startsWith('<arquivo de midia oculto')) {
      return true;
    }

    if (lower.contains('(arquivo anexado)') ||
        lower.contains('arquivo anexado') ||
        lower.contains('(file attached)')) {
      return true;
    }

    if (lower.contains('omitted') &&
        (lower.contains('audio') ||
            lower.contains('image') ||
            lower.contains('video') ||
            lower.contains('sticker') ||
            lower.contains('gif') ||
            lower.contains('document') ||
            lower.contains('contact card'))) {
      return true;
    }

    return false;
  }

  /// Detects the media type ('audio', 'video', 'sticker', 'image') from content.
  static String? detectMediaType(String content) {
    if (!isMedia(content)) return null;
    final lower = content.toLowerCase();

    if (lower.contains('audio') ||
        lower.contains('áudio') ||
        lower.contains('.opus') ||
        lower.contains('.m4a') ||
        lower.contains('ptt-')) {
      return 'audio';
    }
    if (lower.contains('video') ||
        lower.contains('vídeo') ||
        lower.contains('.mp4') ||
        lower.contains('vid-')) {
      return 'video';
    }
    if (lower.contains('sticker') ||
        lower.contains('figurinha') ||
        lower.contains('.webp') ||
        lower.contains('stk-')) {
      return 'sticker';
    }

    // Default media marker (e.g. <Mídia oculta>, image omitted) is classified as image
    return 'image';
  }
}
