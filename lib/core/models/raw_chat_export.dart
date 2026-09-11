import 'chat_message.dart';

/// Container representing a fully parsed WhatsApp chat export.
class RawChatExport {
  final List<ChatMessage> messages;
  final Set<String> participants;
  final DateTime startDate;
  final DateTime endDate;
  final int totalMessages;

  const RawChatExport({
    required this.messages,
    required this.participants,
    required this.startDate,
    required this.endDate,
    int? totalMessages,
  }) : totalMessages = totalMessages ?? messages.length;

  /// Factory constructor to derive metadata (participants, startDate, endDate, totalMessages)
  /// directly from a list of messages.
  factory RawChatExport.fromMessages(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      final now = DateTime.now();
      return RawChatExport(
        messages: const [],
        participants: const {},
        startDate: now,
        endDate: now,
        totalMessages: 0,
      );
    }

    final participants = <String>{};
    for (final m in messages) {
      if (!m.isSystem && m.author.isNotEmpty) {
        participants.add(m.author);
      }
    }

    DateTime start = messages.first.timestamp;
    DateTime end = messages.first.timestamp;
    for (final m in messages) {
      if (m.timestamp.isBefore(start)) start = m.timestamp;
      if (m.timestamp.isAfter(end)) end = m.timestamp;
    }

    return RawChatExport(
      messages: messages,
      participants: participants,
      startDate: start,
      endDate: end,
      totalMessages: messages.length,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawChatExport &&
          runtimeType == other.runtimeType &&
          totalMessages == other.totalMessages &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          participants.length == other.participants.length &&
          messages.length == other.messages.length;

  @override
  int get hashCode => Object.hash(
        messages.length,
        participants.length,
        startDate,
        endDate,
        totalMessages,
      );

  @override
  String toString() =>
      'RawChatExport(totalMessages: $totalMessages, participants: $participants, startDate: $startDate, endDate: $endDate)';
}
