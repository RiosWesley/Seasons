import '../models/chat_message.dart';
import '../models/raw_chat_export.dart';
import 'text_sanitizer.dart';
import 'whatsapp_regex.dart';

/// Exception thrown when WhatsApp chat export content cannot be parsed.
class WhatsAppParseException implements Exception {
  final String message;
  const WhatsAppParseException(this.message);

  @override
  String toString() => 'WhatsAppParseException: $message';
}

/// High-tolerance state-machine parser for WhatsApp chat exports.
class ChatParser {
  const ChatParser();

  /// Parses raw export text content into a list of [ChatMessage].
  List<ChatMessage> parseMessages(
    String rawContent, {
    bool includeSystemMessages = false,
  }) {
    if (rawContent.trim().isEmpty) {
      throw const WhatsAppParseException('O arquivo de conversa está vazio.');
    }

    final lines = rawContent.split(RegExp(r'\r?\n'));
    final messages = <ChatMessage>[];

    DateTime? currentTimestamp;
    String? currentAuthor;
    StringBuffer? currentContentBuffer;
    bool currentIsMedia = false;
    String? currentMediaType;

    void flushCurrentMessage() {
      final buffer = currentContentBuffer;
      final timestamp = currentTimestamp;
      final author = currentAuthor;

      if (timestamp != null && author != null && buffer != null) {
        final finalContent = buffer.toString().trim();
        messages.add(
          ChatMessage(
            timestamp: timestamp,
            author: author,
            content: finalContent,
            isMedia: currentIsMedia,
            mediaType: currentMediaType,
            isSystem: false,
          ),
        );
        currentTimestamp = null;
        currentAuthor = null;
        currentContentBuffer = null;
        currentIsMedia = false;
        currentMediaType = null;
      }
    }

    for (int i = 0; i < lines.length; i++) {
      final rawLine = lines[i];
      final sanitized = TextSanitizer.sanitizeLine(rawLine);

      // Handle blank lines inside a multiline message
      if (sanitized.trim().isEmpty) {
        currentContentBuffer?.writeln();
        continue;
      }

      // 1. Check if line is a new message header first
      final header = WhatsAppRegex.parseHeader(sanitized);
      if (header != null) {
        flushCurrentMessage();

        // Check if the parsed content itself is a deleted message notice
        if (WhatsAppRegex.isDeletedMessage(header.content)) {
          if (includeSystemMessages) {
            messages.add(
              ChatMessage(
                timestamp: header.timestamp,
                author: header.author,
                content: header.content,
                isMedia: false,
                mediaType: null,
                isSystem: true,
              ),
            );
          }
          continue;
        }

        currentTimestamp = header.timestamp;
        currentAuthor = header.author;
        currentContentBuffer = StringBuffer(header.content);
        currentIsMedia = WhatsAppRegex.isMedia(header.content);
        currentMediaType = WhatsAppRegex.detectMediaType(header.content);
        continue;
      }

      // 2. Multiline continuation: if we are accumulating a message and this line
      // does not have a timestamp prefix, it is guaranteed to be message continuation.
      // Multiline continuations must NEVER be checked against unanchored system keywords.
      if (currentContentBuffer != null && !WhatsAppRegex.hasTimestampPrefix(sanitized)) {
        currentContentBuffer!.writeln();
        currentContentBuffer!.write(sanitized.trim());
        continue;
      }

      // 3. Check if line is a system message (timestamped notification or initial banner)
      if (WhatsAppRegex.isSystemMessage(sanitized)) {
        flushCurrentMessage();
        if (includeSystemMessages) {
          final timestamp = WhatsAppRegex.extractTimestamp(sanitized) ??
              (messages.isNotEmpty
                  ? messages.last.timestamp
                  : DateTime.now());
          messages.add(
            ChatMessage(
              timestamp: timestamp,
              author: 'System',
              content: sanitized,
              isMedia: false,
              mediaType: null,
              isSystem: true,
            ),
          );
        }
        continue;
      }

      // 4. Multiline continuation fallback
      if (currentContentBuffer != null) {
        currentContentBuffer!.writeln();
        currentContentBuffer!.write(sanitized.trim());
      }
    }

    // Flush any trailing message
    flushCurrentMessage();

    if (messages.isEmpty) {
      throw const WhatsAppParseException(
        'Nenhuma mensagem válida encontrada no arquivo exportado. Verifique se o arquivo possui um formato suportado.',
      );
    }

    return messages;
  }

  /// Parses raw export text content into a [RawChatExport].
  RawChatExport parse(
    String rawContent, {
    bool includeSystemMessages = false,
  }) {
    final messages = parseMessages(
      rawContent,
      includeSystemMessages: includeSystemMessages,
    );
    return RawChatExport.fromMessages(messages);
  }
}
