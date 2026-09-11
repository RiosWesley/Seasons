/// Represents a single parsed message from a WhatsApp chat export.
class ChatMessage implements Comparable<ChatMessage> {
  final DateTime timestamp;
  final String author;
  final String content;
  final bool isMedia;
  final String? mediaType; // 'image', 'audio', 'video', 'sticker'
  final bool isSystem;

  const ChatMessage({
    required this.timestamp,
    required this.author,
    required this.content,
    this.isMedia = false,
    this.mediaType,
    this.isSystem = false,
  });

  ChatMessage copyWith({
    DateTime? timestamp,
    String? author,
    String? content,
    bool? isMedia,
    String? mediaType,
    bool? isSystem,
  }) {
    return ChatMessage(
      timestamp: timestamp ?? this.timestamp,
      author: author ?? this.author,
      content: content ?? this.content,
      isMedia: isMedia ?? this.isMedia,
      mediaType: mediaType ?? this.mediaType,
      isSystem: isSystem ?? this.isSystem,
    );
  }

  @override
  int compareTo(ChatMessage other) => timestamp.compareTo(other.timestamp);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp &&
          author == other.author &&
          content == other.content &&
          isMedia == other.isMedia &&
          mediaType == other.mediaType &&
          isSystem == other.isSystem;

  @override
  int get hashCode => Object.hash(
        timestamp,
        author,
        content,
        isMedia,
        mediaType,
        isSystem,
      );

  @override
  String toString() =>
      'ChatMessage(timestamp: $timestamp, author: "$author", content: "$content", isMedia: $isMedia, mediaType: $mediaType, isSystem: $isSystem)';
}
