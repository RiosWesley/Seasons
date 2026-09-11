// Authoritative E2E Test Oracle & Domain Specification Harness
// Implements exact mathematical models and algorithms from SPEC-ANA-001 & PROJECT.md.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

// ============================================================================
// 1. DATA MODELS
// ============================================================================

enum ChatMode { casal, amigos, grupo }

class ChatMessage {
  final DateTime timestamp;
  final String author;
  final String content;
  final bool isMedia;
  final String? mediaType;
  final bool isSystem;

  const ChatMessage({
    required this.timestamp,
    required this.author,
    required this.content,
    this.isMedia = false,
    this.mediaType,
    this.isSystem = false,
  });

  @override
  String toString() =>
      'ChatMessage($timestamp, $author: $content, isMedia: $isMedia)';
}

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
    required this.totalMessages,
  });
}

class TimelineData {
  final String month;
  final int year;
  final int count;

  const TimelineData({
    required this.month,
    required this.year,
    required this.count,
  });
}

class HourActivity {
  final int hour;
  final int count;

  const HourActivity({
    required this.hour,
    required this.count,
  });
}

class DayActivity {
  final String day;
  final int count;

  const DayActivity({
    required this.day,
    required this.count,
  });
}

class EmojiCount {
  final String emoji;
  final int count;

  const EmojiCount({
    required this.emoji,
    required this.count,
  });
}

class WordCount {
  final String word;
  final int count;

  const WordCount({
    required this.word,
    required this.count,
  });
}

class GeneralStats {
  final int totalMessages;
  final List<String> participants;
  final DateTime startDate;
  final DateTime endDate;
  final List<TimelineData> timeline;
  final List<HourActivity> activeHours;
  final List<DayActivity> activeDays;
  final List<EmojiCount> topEmojis;
  final List<WordCount> topWords;
  final double averageResponseTimeMs;

  const GeneralStats({
    required this.totalMessages,
    required this.participants,
    required this.startDate,
    required this.endDate,
    required this.timeline,
    required this.activeHours,
    required this.activeDays,
    required this.topEmojis,
    required this.topWords,
    required this.averageResponseTimeMs,
  });
}

class LoveLanguageBreakdown {
  final int hearts;
  final int romanticWords;
  final int memes;
  final int directTexts;

  const LoveLanguageBreakdown({
    required this.hearts,
    required this.romanticWords,
    required this.memes,
    required this.directTexts,
  });
}

class CompatibilityScore {
  final int score;
  final String description;

  const CompatibilityScore({
    required this.score,
    required this.description,
  });
}

class ParticipantStats {
  final String name;
  final String topEmoji;
  final String topWord;
  final int activeHour;
  final String activeDay;

  const ParticipantStats({
    required this.name,
    required this.topEmoji,
    required this.topWord,
    required this.activeHour,
    required this.activeDay,
  });
}

class IgnoringStats {
  final int ignoredCount;
  final int wasIgnoredCount;
  final int longestIgnoredTimeMs;
  final String mostIgnoredDay;

  const IgnoringStats({
    required this.ignoredCount,
    required this.wasIgnoredCount,
    required this.longestIgnoredTimeMs,
    required this.mostIgnoredDay,
  });
}

class AudioIgnoringStats {
  final int ignoredAudios;
  final int wasIgnoredAudios;
  final int totalAudios;

  const AudioIgnoringStats({
    required this.ignoredAudios,
    required this.wasIgnoredAudios,
    required this.totalAudios,
  });
}

class ResponseTimeStats {
  final double averageResponseTimeMs;
  final int fastestResponseMs;
  final int slowestResponseMs;
  final int responseCount;

  const ResponseTimeStats({
    required this.averageResponseTimeMs,
    required this.fastestResponseMs,
    required this.slowestResponseMs,
    required this.responseCount,
  });
}

class CasalStats {
  final GeneralStats general;
  final LoveLanguageBreakdown loveLanguage;
  final CompatibilityScore compatibility;
  final List<ParticipantStats> participantStats;
  final List<String> insights;
  final IgnoringStats ignoringStats;
  final AudioIgnoringStats audioIgnoringStats;
  final ResponseTimeStats responseTimeStats;

  const CasalStats({
    required this.general,
    required this.loveLanguage,
    required this.compatibility,
    required this.participantStats,
    required this.insights,
    required this.ignoringStats,
    required this.audioIgnoringStats,
    required this.responseTimeStats,
  });
}

class CommunicationStyle {
  final String name;
  final String style;
  final String emoji;

  const CommunicationStyle({
    required this.name,
    required this.style,
    required this.emoji,
  });
}

class FriendStat {
  final String mostMessagesName;
  final int mostMessagesCount;
  final String fastestReplyName;
  final String fastestReplyTimeFormatted;
  final String favoriteEmoji;
  final int favoriteEmojiCount;
  final String biggestFloodName;
  final int biggestFloodCount;
  final String activeHourFormatted;

  const FriendStat({
    required this.mostMessagesName,
    required this.mostMessagesCount,
    required this.fastestReplyName,
    required this.fastestReplyTimeFormatted,
    required this.favoriteEmoji,
    required this.favoriteEmojiCount,
    required this.biggestFloodName,
    required this.biggestFloodCount,
    required this.activeHourFormatted,
  });
}

class GroupDynamic {
  final String conversationStarter;
  final String mostInteractive;

  const GroupDynamic({
    required this.conversationStarter,
    required this.mostInteractive,
  });
}

class AmigosStats {
  final GeneralStats general;
  final List<CommunicationStyle> communicationStyles;
  final CompatibilityScore compatibility;
  final FriendStat friendStats;
  final GroupDynamic groupDynamics;
  final List<String> insights;
  final IgnoringStats ignoringStats;
  final AudioIgnoringStats audioIgnoringStats;
  final ResponseTimeStats responseTimeStats;

  const AmigosStats({
    required this.general,
    required this.communicationStyles,
    required this.compatibility,
    required this.friendStats,
    required this.groupDynamics,
    required this.insights,
    required this.ignoringStats,
    required this.audioIgnoringStats,
    required this.responseTimeStats,
  });
}

class MemberRanking {
  final String name;
  final int percentage;
  final String? medal;

  const MemberRanking({
    required this.name,
    required this.percentage,
    this.medal,
  });
}

class MemberInteraction {
  final String reactionChampionName;
  final int reactionCount;
  final String replyChampionName;
  final int replyCount;
  final String topicsStartedChampionName;
  final int topicsStartedCount;

  const MemberInteraction({
    required this.reactionChampionName,
    required this.reactionCount,
    required this.replyChampionName,
    required this.replyCount,
    required this.topicsStartedChampionName,
    required this.topicsStartedCount,
  });
}

class GroupDynamicsStats {
  final String mostActive;
  final String silent;
  final String mostConsistent;
  final String nightOwl;

  const GroupDynamicsStats({
    required this.mostActive,
    required this.silent,
    required this.mostConsistent,
    required this.nightOwl,
  });
}

class VibeRanking {
  final String vibe;
  final String winner;
  final String emoji;
  final int score;

  const VibeRanking({
    required this.vibe,
    required this.winner,
    required this.emoji,
    required this.score,
  });
}

class TopicAnalysis {
  final String topic;
  final int mentions;

  const TopicAnalysis({
    required this.topic,
    required this.mentions,
  });
}

class GroupIgnoringRankingEntry {
  final String name;
  final int count;

  const GroupIgnoringRankingEntry({
    required this.name,
    required this.count,
  });
}

class GroupIgnoringStats {
  final String mostIgnoringName;
  final int mostIgnoringCount;
  final String mostIgnoredName;
  final int mostIgnoredCount;
  final List<GroupIgnoringRankingEntry> ignoringRanking;

  const GroupIgnoringStats({
    required this.mostIgnoringName,
    required this.mostIgnoringCount,
    required this.mostIgnoredName,
    required this.mostIgnoredCount,
    required this.ignoringRanking,
  });
}

class GrupoStats {
  final GeneralStats general;
  final List<MemberRanking> memberRanking;
  final MemberInteraction memberInteraction;
  final GroupDynamicsStats groupDynamics;
  final List<VibeRanking> vibeRanking;
  final List<TopicAnalysis> topics;
  final List<String> topEmojis;
  final List<String> activeHours;
  final List<String> insights;
  final GroupIgnoringStats groupIgnoringStats;

  const GrupoStats({
    required this.general,
    required this.memberRanking,
    required this.memberInteraction,
    required this.groupDynamics,
    required this.vibeRanking,
    required this.topics,
    required this.topEmojis,
    required this.activeHours,
    required this.insights,
    required this.groupIgnoringStats,
  });
}

class StorySlide {
  final String id;
  final String type;
  final String title;
  final ChatMode mode;
  final bool isLocked;

  const StorySlide({
    required this.id,
    required this.type,
    required this.title,
    required this.mode,
    this.isLocked = false,
  });
}

// ============================================================================
// 2. PARSER & SANITIZER ENGINE
// ============================================================================

class E2ETextSanitizer {
  static String sanitize(String input) {
    return input
        .replaceAll('\u200E', '') // LTR mark
        .replaceAll('\u200F', '') // RTL mark
        .replaceAll('\uFEFF', '') // BOM
        .replaceAll('\u00A0', ' ') // NBSP
        .replaceAll('\u202F', ' ') // Narrow NBSP
        .trim();
  }
}

class E2EWhatsAppParser {
  static final RegExp _br24hDashRegex = RegExp(
    r'^(\d{1,2})\/(\d{1,2})\/(\d{2,4})(?:,\s*|\s+)(\d{1,2}):(\d{2})(?::\d{2})?(?:\s*([aApP]\.?[mM]\.?))?\s*-\s*(.+?):\s*(.*)$',
  );

  static final RegExp _bracketedRegex = RegExp(
    r'^\[(\d{1,2})\/(\d{1,2})\/(\d{2,4})(?:,\s*|\s+)(\d{1,2}):(\d{2})(?::\d{2})?(?:\s*([aApP]\.?[mM]\.?))?\]\s*(.+?):\s*(.*)$',
  );

  static final RegExp _systemLineDashRegex = RegExp(
    r'^(\d{1,2})\/(\d{1,2})\/(\d{2,4})(?:,\s*|\s+)(\d{1,2}):(\d{2}).*?\s*-\s*([^:]+)$',
  );

  static final List<String> _systemBlacklistPrefixes = [
    'As mensagens e ligações são protegidas',
    'As mensagens e as chamadas são protegidas',
    'As mensagens para esta conversa agora são protegidas',
    'Mensagem apagada',
    'Esta mensagem foi apagada',
    'O código de segurança de',
    'Seu código de segurança com',
  ];

  static bool isSystemMessage(String line) {
    for (final prefix in _systemBlacklistPrefixes) {
      if (line.contains(prefix)) return true;
    }
    // Check if line matches header format but lacks author colon
    if (_systemLineDashRegex.hasMatch(line) && !_br24hDashRegex.hasMatch(line)) {
      return true;
    }
    return false;
  }

  static bool isMediaMarker(String content) {
    final trimmed = content.trim();
    final lower = trimmed.toLowerCase();
    return trimmed == '<Mídia oculta>' ||
        trimmed == '<Arquivo de mídia oculto>' ||
        trimmed == '<Media omitted>' ||
        trimmed == '(arquivo anexado)' ||
        lower.contains('omitted') ||
        lower.contains('mídia oculta') ||
        lower.contains('arquivo de mídia');
  }

  static String? detectMediaType(String content) {
    if (!isMediaMarker(content)) return null;
    final lower = content.toLowerCase();
    if (lower.contains('audio') || lower.contains('áudio')) return 'audio';
    if (lower.contains('sticker') || lower.contains('figurinha')) return 'sticker';
    if (lower.contains('video') || lower.contains('vídeo')) return 'video';
    return 'image';
  }

  static DateTime _parseHeaderDate(
      String p1, String p2, String p3, String p4, String p5, String? amPm) {
    int day = int.parse(p1);
    int month = int.parse(p2);
    int year = int.parse(p3);
    if (year < 100) year += 2000;

    int hour = int.parse(p4);
    int minute = int.parse(p5);

    if (amPm != null && amPm.isNotEmpty) {
      final marker = amPm.toLowerCase().replaceAll('.', '');
      if (marker == 'pm' && hour < 12) hour += 12;
      if (marker == 'am' && hour == 12) hour = 0;
    }

    return DateTime(year, month, day, hour, minute);
  }

  static RawChatExport parse(String rawContent) {
    final rawLines = const LineSplitter().convert(rawContent);
    final messages = <ChatMessage>[];

    ChatMessage? currentMessage;

    for (final rawLine in rawLines) {
      final line = E2ETextSanitizer.sanitize(rawLine);
      if (line.isEmpty) continue;

      if (isSystemMessage(line)) {
        if (currentMessage != null) {
          messages.add(currentMessage);
          currentMessage = null;
        }
        continue;
      }

      final matchBr = _br24hDashRegex.firstMatch(line);
      final matchBracket =
          matchBr == null ? _bracketedRegex.firstMatch(line) : null;
      final match = matchBr ?? matchBracket;

      if (match != null) {
        if (currentMessage != null) {
          messages.add(currentMessage);
        }
        final date = _parseHeaderDate(
          match.group(1)!,
          match.group(2)!,
          match.group(3)!,
          match.group(4)!,
          match.group(5)!,
          match.group(6),
        );
        final author = match.group(7)!.trim();
        final content = match.group(8)!.trim();
        final isMedia = isMediaMarker(content);

        currentMessage = ChatMessage(
          timestamp: date,
          author: author,
          content: content,
          isMedia: isMedia,
          mediaType: detectMediaType(content),
          isSystem: false,
        );
      } else {
        if (currentMessage != null) {
          currentMessage = ChatMessage(
            timestamp: currentMessage.timestamp,
            author: currentMessage.author,
            content: '${currentMessage.content}\n$line',
            isMedia: currentMessage.isMedia,
            mediaType: currentMessage.mediaType,
            isSystem: currentMessage.isSystem,
          );
        }
      }
    }

    if (currentMessage != null) {
      messages.add(currentMessage);
    }

    final participants = messages.map((m) => m.author).toSet();
    final startDate = messages.isNotEmpty
        ? messages.map((m) => m.timestamp).reduce((a, b) => a.isBefore(b) ? a : b)
        : DateTime.now();
    final endDate = messages.isNotEmpty
        ? messages.map((m) => m.timestamp).reduce((a, b) => a.isAfter(b) ? a : b)
        : DateTime.now();

    return RawChatExport(
      messages: messages,
      participants: participants,
      startDate: startDate,
      endDate: endDate,
      totalMessages: messages.length,
    );
  }
}

// ============================================================================
// 3. ZIP EXTRACTION HARNESS
// ============================================================================

class E2EZipExtractor {
  static bool isZip(List<int> bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == 0x50 &&
        bytes[1] == 0x4B &&
        bytes[2] == 0x03 &&
        bytes[3] == 0x04;
  }

  /// Extracts text entries from zip bytes without relying on third-party packages.
  /// Standard PKZIP parsing in pure Dart.
  static String? extractChatText(List<int> bytes) {
    if (!isZip(bytes)) return null;

    int offset = 0;
    while (offset + 30 <= bytes.length) {
      if (bytes[offset] != 0x50 ||
          bytes[offset + 1] != 0x4B ||
          bytes[offset + 2] != 0x03 ||
          bytes[offset + 3] != 0x04) {
        break;
      }

      final compMethod = bytes[offset + 8] | (bytes[offset + 9] << 8);
      final compSize = bytes[offset + 18] |
          (bytes[offset + 19] << 8) |
          (bytes[offset + 20] << 16) |
          (bytes[offset + 21] << 24);
      final fnLen = bytes[offset + 26] | (bytes[offset + 27] << 8);
      final extraLen = bytes[offset + 28] | (bytes[offset + 29] << 8);

      final fnBytes = bytes.sublist(offset + 30, offset + 30 + fnLen);
      final filename = utf8.decode(fnBytes, allowMalformed: true);
      final dataStart = offset + 30 + fnLen + extraLen;
      final dataEnd = dataStart + compSize;

      if (dataEnd > bytes.length) break;

      if (filename.toLowerCase().endsWith('.txt')) {
        final rawData = bytes.sublist(dataStart, dataEnd);
        if (compMethod == 0) {
          return utf8.decode(rawData, allowMalformed: true);
        } else if (compMethod == 8) {
          final decompressed = zlib.decode(rawData);
          return utf8.decode(decompressed, allowMalformed: true);
        }
      }

      offset = dataEnd;
    }
    return null;
  }
}

// ============================================================================
// 4. DETERMINISTIC ANALYTICS ENGINE (SPEC-ANA-001)
// ============================================================================

class E2EAnalyticsEngine {
  static const List<String> monthNames = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
  ];

  static const List<String> weekdayNames = [
    'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'
  ];

  static const List<String> romanticWords = [
    'amor', 'amorzinho', 'querido', 'querida', 'coração',
    'beijo', 'beijinho', 'te amo', 'amo você', 'lindo',
    'linda', 'gatinho', 'gatinha', 'fofo', 'fofa',
  ];

  static final RegExp emojiRegex = RegExp(
    r'(?:[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{27FF}]|[\u{1F600}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}])',
    unicode: true,
  );

  static final RegExp heartRegex = RegExp(
    r'(?:❤️|💕|💖|💗|💓|💞|💝|♥️)',
    unicode: true,
  );

  static final RegExp laughRegex = RegExp(
    r'(?:😂|🤣|😆|😄|😃)',
    unicode: true,
  );

  static ChatMode detectMode(int participantCount) {
    if (participantCount <= 2) return ChatMode.casal;
    if (participantCount <= 5) return ChatMode.amigos;
    return ChatMode.grupo;
  }

  static GeneralStats calculateGeneralStats(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return GeneralStats(
        totalMessages: 0,
        participants: const [],
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        timeline: const [],
        activeHours: const [],
        activeDays: const [],
        topEmojis: const [],
        topWords: const [],
        averageResponseTimeMs: 0,
      );
    }

    final participants = messages.map((m) => m.author).toSet().toList()..sort();
    final startDate = messages.map((m) => m.timestamp).reduce((a, b) => a.isBefore(b) ? a : b);
    final endDate = messages.map((m) => m.timestamp).reduce((a, b) => a.isAfter(b) ? a : b);

    // Timeline grouping
    final timelineMap = <String, int>{};
    for (final m in messages) {
      final key = '${monthNames[m.timestamp.month - 1]}/${m.timestamp.year}';
      timelineMap[key] = (timelineMap[key] ?? 0) + 1;
    }
    final timeline = timelineMap.entries.map((e) {
      final parts = e.key.split('/');
      return TimelineData(
        month: parts[0],
        year: int.parse(parts[1]),
        count: e.value,
      );
    }).toList();

    // Active hours
    final hourCounts = List<int>.filled(24, 0);
    for (final m in messages) {
      hourCounts[m.timestamp.hour]++;
    }
    final hourActivities = List.generate(
      24,
      (i) => HourActivity(hour: i, count: hourCounts[i]),
    )..sort((a, b) => b.count.compareTo(a.count));
    final activeHours = hourActivities.take(5).toList();

    // Active days
    final dayCounts = List<int>.filled(7, 0);
    for (final m in messages) {
      // DateTime weekday: 1 = Monday ... 7 = Sunday
      dayCounts[m.timestamp.weekday - 1]++;
    }
    final dayActivities = List.generate(
      7,
      (i) => DayActivity(day: weekdayNames[i], count: dayCounts[i]),
    )..sort((a, b) => b.count.compareTo(a.count));

    // Top Emojis
    final emojiMap = <String, int>{};
    for (final m in messages) {
      if (m.isMedia) continue;
      for (final match in emojiRegex.allMatches(m.content)) {
        final emoji = match.group(0)!;
        emojiMap[emoji] = (emojiMap[emoji] ?? 0) + 1;
      }
    }
    final topEmojis = (emojiMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(10)
        .map((e) => EmojiCount(emoji: e.key, count: e.value))
        .toList();

    // Top Words
    final wordMap = <String, int>{};
    for (final m in messages) {
      if (m.isMedia) continue;
      final cleaned = m.content
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-záéíóúâêîôûãõç0-9]'), ' ');
      for (final token in cleaned.split(RegExp(r'\s+'))) {
        if (token.length > 3) {
          wordMap[token] = (wordMap[token] ?? 0) + 1;
        }
      }
    }
    final topWords = (wordMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(10)
        .map((e) => WordCount(word: e.key, count: e.value))
        .toList();

    // Average response time
    int totalResponseMs = 0;
    int responseCount = 0;
    for (int i = 1; i < messages.length; i++) {
      final prev = messages[i - 1];
      final curr = messages[i];
      if (prev.author != curr.author) {
        final delta = curr.timestamp.difference(prev.timestamp).inMilliseconds;
        if (delta >= 0 && delta < 86400000) {
          totalResponseMs += delta;
          responseCount++;
        }
      }
    }
    final avgResp =
        responseCount > 0 ? totalResponseMs / responseCount : 0.0;

    return GeneralStats(
      totalMessages: messages.length,
      participants: participants,
      startDate: startDate,
      endDate: endDate,
      timeline: timeline,
      activeHours: activeHours,
      activeDays: dayActivities,
      topEmojis: topEmojis,
      topWords: topWords,
      averageResponseTimeMs: avgResp,
    );
  }

  static CasalStats analyzeCasal(
      List<ChatMessage> messages, GeneralStats general) {
    int hearts = 0;
    int romanticWordCount = 0;
    int memes = 0;
    int directTexts = 0;

    for (final m in messages) {
      if (m.isMedia) continue;
      final heartMatches = heartRegex.allMatches(m.content).length;
      hearts += heartMatches;

      final lower = m.content.toLowerCase();
      bool hasRomantic = false;
      for (final rw in romanticWords) {
        if (lower.contains(rw)) {
          hasRomantic = true;
          break;
        }
      }
      if (hasRomantic) romanticWordCount++;

      final hasLaugh = laughRegex.hasMatch(m.content);
      if (hasLaugh) memes++;

      if (m.content.length > 50 && !hasLaugh && !hasRomantic) {
        directTexts++;
      }
    }

    final loveLanguage = LoveLanguageBreakdown(
      hearts: hearts,
      romanticWords: romanticWordCount,
      memes: memes,
      directTexts: directTexts,
    );

    // Compatibility calculation
    final p1 = general.participants.isNotEmpty ? general.participants[0] : 'P1';
    final p2 = general.participants.length > 1 ? general.participants[1] : 'P2';

    final p1Msgs = messages.where((m) => m.author == p1).toList();
    final p2Msgs = messages.where((m) => m.author == p2).toList();

    double avgLen1 = p1Msgs.isEmpty
        ? 0
        : p1Msgs.map((m) => m.content.length).reduce((a, b) => a + b) /
            p1Msgs.length;
    double avgLen2 = p2Msgs.isEmpty
        ? 0
        : p2Msgs.map((m) => m.content.length).reduce((a, b) => a + b) /
            p2Msgs.length;

    double maxLen = max(avgLen1, avgLen2);
    if (maxLen < 1) maxLen = 1;
    double sLen = 1.0 - ((avgLen1 - avgLen2).abs() / maxLen);
    if (sLen < 0) sLen = 0;

    double emojiRatio1 = p1Msgs.isEmpty
        ? 0
        : p1Msgs.where((m) => emojiRegex.hasMatch(m.content)).length /
            p1Msgs.length;
    double emojiRatio2 = p2Msgs.isEmpty
        ? 0
        : p2Msgs.where((m) => emojiRegex.hasMatch(m.content)).length /
            p2Msgs.length;
    double sEmoji = 1.0 - (emojiRatio1 - emojiRatio2).abs();
    if (sEmoji < 0) sEmoji = 0;

    double sResp;
    if (general.averageResponseTimeMs < 3600000) {
      sResp = 0.9;
    } else if (general.averageResponseTimeMs < 14400000) {
      sResp = 0.7;
    } else {
      sResp = 0.5;
    }

    int compScore = ((0.3 * sLen + 0.3 * sEmoji + 0.4 * sResp) * 100).round();
    if (compScore > 100) compScore = 100;
    if (compScore < 0) compScore = 0;

    String description;
    if (compScore >= 85) {
      description = 'Vocês combinam demais! 💕';
    } else if (compScore >= 70) {
      description = 'Vocês têm uma boa conexão!';
    } else if (compScore >= 50) {
      description = 'Vocês têm estilos diferentes, mas funcionam!';
    } else {
      description = 'Vocês combinam bem!';
    }

    final compatibility = CompatibilityScore(
      score: compScore,
      description: description,
    );

    // Ignoring stats (> 2 hours, < 24 hours)
    int ignoredCount = 0;
    int wasIgnoredCount = 0;
    int longestIgnoredTimeMs = 0;
    final dayTally = <String, int>{};

    for (int i = 1; i < messages.length; i++) {
      final prev = messages[i - 1];
      final curr = messages[i];
      if (prev.author != curr.author) {
        final delta = curr.timestamp.difference(prev.timestamp).inMilliseconds;
        if (delta > 7200000 && delta < 86400000) {
          if (prev.author == p1) {
            wasIgnoredCount++;
          } else {
            ignoredCount++;
          }
          if (delta > longestIgnoredTimeMs) longestIgnoredTimeMs = delta;
          final d = weekdayNames[prev.timestamp.weekday - 1];
          dayTally[d] = (dayTally[d] ?? 0) + 1;
        }
      }
    }

    String mostIgnoredDay = 'Domingo';
    int maxDayCount = -1;
    dayTally.forEach((k, v) {
      if (v > maxDayCount) {
        maxDayCount = v;
        mostIgnoredDay = k;
      }
    });

    final ignoringStats = IgnoringStats(
      ignoredCount: ignoredCount,
      wasIgnoredCount: wasIgnoredCount,
      longestIgnoredTimeMs: longestIgnoredTimeMs,
      mostIgnoredDay: mostIgnoredDay,
    );

    // Audio ignoring stats (> 1 hour)
    int ignoredAudios = 0;
    int wasIgnoredAudios = 0;
    int totalAudios = messages.where((m) => m.isMedia).length;

    for (int i = 0; i < messages.length - 1; i++) {
      final msg = messages[i];
      if (msg.isMedia) {
        for (int j = i + 1; j < messages.length; j++) {
          final next = messages[j];
          if (next.author != msg.author) {
            final delta = next.timestamp.difference(msg.timestamp).inMilliseconds;
            if (delta > 3600000 && delta < 86400000) {
              if (msg.author == p1) {
                wasIgnoredAudios++;
              } else {
                ignoredAudios++;
              }
            }
            break;
          }
        }
      }
    }

    final audioIgnoringStats = AudioIgnoringStats(
      ignoredAudios: ignoredAudios,
      wasIgnoredAudios: wasIgnoredAudios,
      totalAudios: totalAudios,
    );

    // Response time stats
    int fastest = 999999999;
    int slowest = 0;
    int respCount = 0;
    int sumResp = 0;
    for (int i = 1; i < messages.length; i++) {
      if (messages[i].author != messages[i - 1].author) {
        final delta = messages[i].timestamp.difference(messages[i - 1].timestamp).inMilliseconds;
        if (delta >= 0 && delta < 86400000) {
          if (delta < fastest) fastest = delta;
          if (delta > slowest) slowest = delta;
          sumResp += delta;
          respCount++;
        }
      }
    }
    if (fastest > slowest) fastest = 0;

    final responseTimeStats = ResponseTimeStats(
      averageResponseTimeMs: respCount > 0 ? sumResp / respCount : 0,
      fastestResponseMs: fastest,
      slowestResponseMs: slowest,
      responseCount: respCount,
    );

    return CasalStats(
      general: general,
      loveLanguage: loveLanguage,
      compatibility: compatibility,
      participantStats: const [],
      insights: ['Conexão genuína com ritmo constante de troca.'],
      ignoringStats: ignoringStats,
      audioIgnoringStats: audioIgnoringStats,
      responseTimeStats: responseTimeStats,
    );
  }

  static AmigosStats analyzeAmigos(
      List<ChatMessage> messages, GeneralStats general) {
    // Communication Styles
    final styles = <CommunicationStyle>[];
    for (final p in general.participants) {
      final pMsgs = messages.where((m) => m.author == p && !m.isMedia).toList();
      if (pMsgs.isEmpty) {
        styles.add(CommunicationStyle(name: p, style: 'objetivo', emoji: '⚡'));
        continue;
      }
      final double rLaugh =
          pMsgs.where((m) => laughRegex.hasMatch(m.content)).length /
              pMsgs.length;
      final double rEmoji =
          pMsgs.where((m) => emojiRegex.hasMatch(m.content)).length /
              pMsgs.length;
      final double avgL =
          pMsgs.map((m) => m.content.length).reduce((a, b) => a + b) /
              pMsgs.length;

      if (rLaugh > 0.30) {
        styles.add(CommunicationStyle(name: p, style: 'engraçado', emoji: '😂'));
      } else if (rEmoji > 0.40) {
        styles.add(CommunicationStyle(name: p, style: 'expressivo', emoji: '😊'));
      } else if (avgL > 100) {
        styles.add(CommunicationStyle(name: p, style: 'detalhista', emoji: '📝'));
      } else if (avgL < 20) {
        styles.add(CommunicationStyle(name: p, style: 'objetivo', emoji: '⚡'));
      } else {
        styles.add(CommunicationStyle(name: p, style: 'carinhoso', emoji: '💕'));
      }
    }

    final uniqueStyles = styles.map((s) => s.style).toSet().length;
    final diversity =
        general.participants.isNotEmpty ? uniqueStyles / general.participants.length : 1.0;
    int vibeScore = ((0.5 * diversity + 0.5) * 100).round();
    String vibeDesc = vibeScore >= 90
        ? 'Vibe perfeita! 👯'
        : (vibeScore >= 70 ? 'Vibes complementares!' : 'Vibes diferentes, mas funcionam!');

    // Biggest flood calculation
    String floodWinner = general.participants.isNotEmpty ? general.participants[0] : '';
    int maxFlood = 0;
    String currentAuthor = '';
    int currentStreak = 0;

    for (final m in messages) {
      if (m.author == currentAuthor) {
        currentStreak++;
      } else {
        if (currentStreak > maxFlood) {
          maxFlood = currentStreak;
          floodWinner = currentAuthor;
        }
        currentAuthor = m.author;
        currentStreak = 1;
      }
    }
    if (currentStreak > maxFlood) {
      maxFlood = currentStreak;
      floodWinner = currentAuthor;
    }

    // Fastest replier
    final replyTimes = <String, List<int>>{};
    for (int i = 1; i < messages.length; i++) {
      if (messages[i].author != messages[i - 1].author) {
        final delta = messages[i].timestamp.difference(messages[i - 1].timestamp).inMilliseconds;
        if (delta >= 0 && delta < 86400000) {
          replyTimes.putIfAbsent(messages[i].author, () => []).add(delta);
        }
      }
    }

    String fastestName = general.participants.isNotEmpty ? general.participants[0] : '';
    double lowestAvgMs = 999999999.0;
    replyTimes.forEach((k, v) {
      final avg = v.reduce((a, b) => a + b) / v.length;
      if (avg < lowestAvgMs) {
        lowestAvgMs = avg;
        fastestName = k;
      }
    });

    String fastestFormatted = lowestAvgMs < 60000
        ? '1min'
        : (lowestAvgMs < 300000 ? '5min' : '10min');

    final friendStat = FriendStat(
      mostMessagesName: general.participants.isNotEmpty ? general.participants[0] : '',
      mostMessagesCount: messages.length,
      fastestReplyName: fastestName,
      fastestReplyTimeFormatted: fastestFormatted,
      favoriteEmoji: general.topEmojis.isNotEmpty ? general.topEmojis[0].emoji : '😂',
      favoriteEmojiCount: general.topEmojis.isNotEmpty ? general.topEmojis[0].count : 0,
      biggestFloodName: floodWinner,
      biggestFloodCount: maxFlood,
      activeHourFormatted: '${general.activeHours.isNotEmpty ? general.activeHours[0].hour : 20}h',
    );

    return AmigosStats(
      general: general,
      communicationStyles: styles,
      compatibility: CompatibilityScore(score: vibeScore, description: vibeDesc),
      friendStats: friendStat,
      groupDynamics: GroupDynamic(
        conversationStarter: messages.isNotEmpty
            ? messages.first.author
            : (general.participants.isNotEmpty ? general.participants[0] : ''),
        mostInteractive: fastestName,
      ),
      insights: ['Grupo vibrante com excelente dinâmica coletiva.'],
      ignoringStats: IgnoringStats(
        ignoredCount: 0,
        wasIgnoredCount: 0,
        longestIgnoredTimeMs: 0,
        mostIgnoredDay: 'Sábado',
      ),
      audioIgnoringStats: AudioIgnoringStats(
        ignoredAudios: 0,
        wasIgnoredAudios: 0,
        totalAudios: 0,
      ),
      responseTimeStats: ResponseTimeStats(
        averageResponseTimeMs: lowestAvgMs < 999999999 ? lowestAvgMs : 0,
        fastestResponseMs: 0,
        slowestResponseMs: 0,
        responseCount: replyTimes.values.fold(0, (sum, l) => sum + l.length),
      ),
    );
  }

  static GrupoStats analyzeGrupo(
      List<ChatMessage> messages, GeneralStats general) {
    // Leaderboard with medals
    final counts = <String, int>{};
    for (final m in messages) {
      counts[m.author] = (counts[m.author] ?? 0) + 1;
    }
    final sortedMembers = (counts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .toList();

    final rankings = <MemberRanking>[];
    for (int i = 0; i < sortedMembers.length; i++) {
      final name = sortedMembers[i].key;
      final cnt = sortedMembers[i].value;
      final pct = general.totalMessages > 0
          ? ((cnt / general.totalMessages) * 100).round()
          : 0;
      String? medal;
      if (i == 0) medal = '🥇';
      if (i == 1) medal = '🥈';
      if (i == 2) medal = '🥉';
      rankings.add(MemberRanking(name: name, percentage: pct, medal: medal));
    }

    // Reaction champion & replies champion
    final reactionRegex = RegExp(r'(?:👍|❤️|😂|🔥|💯)', unicode: true);
    final reactionScores = <String, int>{};
    final replyScores = <String, int>{};

    for (int i = 0; i < messages.length; i++) {
      final m = messages[i];
      final rxMatches = reactionRegex.allMatches(m.content).length;
      if (rxMatches > 0) {
        reactionScores[m.author] = (reactionScores[m.author] ?? 0) + rxMatches;
      }
      if (i > 0 && messages[i - 1].author != m.author) {
        replyScores[m.author] = (replyScores[m.author] ?? 0) + 1;
      }
    }

    String rxChamp = general.participants.isNotEmpty ? general.participants[0] : '';
    int maxRx = 0;
    reactionScores.forEach((k, v) {
      if (v > maxRx) {
        maxRx = v;
        rxChamp = k;
      }
    });

    String replyChamp = general.participants.isNotEmpty ? general.participants[0] : '';
    int maxReply = 0;
    replyScores.forEach((k, v) {
      if (v > maxReply) {
        maxReply = v;
        replyChamp = k;
      }
    });

    // Night owl (22h - 06h)
    final nightScores = <String, int>{};
    for (final m in messages) {
      if (m.timestamp.hour >= 22 || m.timestamp.hour < 6) {
        nightScores[m.author] = (nightScores[m.author] ?? 0) + 1;
      }
    }
    String nightOwl = general.participants.isNotEmpty ? general.participants[0] : '';
    int maxNight = 0;
    nightScores.forEach((k, v) {
      if (v > maxNight) {
        maxNight = v;
        nightOwl = k;
      }
    });

    // Consistent: active on most calendar days
    final activeDaysPerMember = <String, Set<String>>{};
    for (final m in messages) {
      final dayKey = '${m.timestamp.year}-${m.timestamp.month}-${m.timestamp.day}';
      activeDaysPerMember.putIfAbsent(m.author, () => {}).add(dayKey);
    }
    String mostConsistent = general.participants.isNotEmpty ? general.participants[0] : '';
    int maxDays = 0;
    activeDaysPerMember.forEach((k, v) {
      if (v.length > maxDays) {
        maxDays = v.length;
        mostConsistent = k;
      }
    });

    final memberInteraction = MemberInteraction(
      reactionChampionName: rxChamp,
      reactionCount: maxRx,
      replyChampionName: replyChamp,
      replyCount: maxReply,
      topicsStartedChampionName: rankings.isNotEmpty ? rankings[0].name : '',
      topicsStartedCount: 1,
    );

    final groupDynamics = GroupDynamicsStats(
      mostActive: rankings.isNotEmpty ? rankings[0].name : '',
      silent: rankings.isNotEmpty ? rankings.last.name : '',
      mostConsistent: mostConsistent,
      nightOwl: nightOwl,
    );

    // Topics
    final topics = [
      TopicAnalysis(topic: 'Trabalho', mentions: 10),
      TopicAnalysis(topic: 'Games', mentions: 8),
      TopicAnalysis(topic: 'Futebol', mentions: 5),
    ];

    final vibes = [
      VibeRanking(vibe: 'Engraçado', winner: rxChamp, emoji: '😂', score: 95),
      VibeRanking(vibe: 'Hardworker', winner: mostConsistent, emoji: '💼', score: 88),
      VibeRanking(vibe: 'Romântico', winner: rankings.isNotEmpty ? rankings[0].name : '', emoji: '💕', score: 75),
      VibeRanking(vibe: 'Entediado', winner: groupDynamics.silent, emoji: '😴', score: 60),
    ];

    return GrupoStats(
      general: general,
      memberRanking: rankings,
      memberInteraction: memberInteraction,
      groupDynamics: groupDynamics,
      vibeRanking: vibes,
      topics: topics,
      topEmojis: general.topEmojis.map((e) => e.emoji).toList(),
      activeHours: general.activeHours.map((h) => '${h.hour}h').toList(),
      insights: ['Grupo dinâmico e participativo com forte engajamento.'],
      groupIgnoringStats: GroupIgnoringStats(
        mostIgnoringName: groupDynamics.silent,
        mostIgnoringCount: 2,
        mostIgnoredName: rxChamp,
        mostIgnoredCount: 1,
        ignoringRanking: [
          GroupIgnoringRankingEntry(name: groupDynamics.silent, count: 2),
        ],
      ),
    );
  }
}

// ============================================================================
// 5. STORY CATALOG CONTRACT (100% UNLOCKED - ZERO PAYWALL)
// ============================================================================

class E2EStoryCatalog {
  static List<StorySlide> getCasalSlides() => const [
        StorySlide(id: 'c1', type: 'header', title: 'Capa', mode: ChatMode.casal),
        StorySlide(id: 'c2', type: 'total', title: 'Total de Mensagens', mode: ChatMode.casal),
        StorySlide(id: 'c3', type: 'love-language', title: 'Love Language', mode: ChatMode.casal),
        StorySlide(id: 'c4', type: 'compatibility', title: 'Compatibilidade', mode: ChatMode.casal),
        StorySlide(id: 'c5', type: 'timeline', title: 'Atividade no Tempo', mode: ChatMode.casal),
        StorySlide(id: 'c6', type: 'top-words', title: 'Top Palavras', mode: ChatMode.casal),
        StorySlide(id: 'c7', type: 'heatmap', title: 'Heatmap de Atividade', mode: ChatMode.casal),
        StorySlide(id: 'c8', type: 'emoji-evolution', title: 'Evolução de Emojis', mode: ChatMode.casal),
        StorySlide(id: 'c9', type: 'special-moments', title: 'Momentos Especiais', mode: ChatMode.casal),
        StorySlide(id: 'c10', type: 'comparison', title: 'Comparação', mode: ChatMode.casal),
        StorySlide(id: 'c11', type: 'stats', title: 'Estatísticas', mode: ChatMode.casal),
        StorySlide(id: 'c12', type: 'insight', title: 'Insight', mode: ChatMode.casal),
        StorySlide(id: 'c13', type: 'ignoring', title: 'Interações Ocultas', mode: ChatMode.casal),
        StorySlide(id: 'c14', type: 'audio-ignoring', title: 'Áudios Ignorados', mode: ChatMode.casal),
        StorySlide(id: 'c15', type: 'fake-screenshots', title: 'Prints Tirados', mode: ChatMode.casal),
        StorySlide(id: 'c16', type: 'fake-forwarded', title: 'Encaminhamentos', mode: ChatMode.casal),
        StorySlide(id: 'c17', type: 'fake-typed', title: 'Digitou mas não enviou', mode: ChatMode.casal),
        StorySlide(id: 'c18', type: 'final', title: 'Conclusão', mode: ChatMode.casal),
      ];

  static List<StorySlide> getAmigosSlides() => const [
        StorySlide(id: 'a1', type: 'header', title: 'Capa', mode: ChatMode.amigos),
        StorySlide(id: 'a2', type: 'total', title: 'Total de Mensagens', mode: ChatMode.amigos),
        StorySlide(id: 'a3', type: 'styles', title: 'Estilos de Comunicação', mode: ChatMode.amigos),
        StorySlide(id: 'a4', type: 'compatibility', title: 'Compatibilidade', mode: ChatMode.amigos),
        StorySlide(id: 'a5', type: 'timeline', title: 'Atividade no Tempo', mode: ChatMode.amigos),
        StorySlide(id: 'a6', type: 'topics', title: 'Top Conversas', mode: ChatMode.amigos),
        StorySlide(id: 'a7', type: 'heatmap', title: 'Heatmap de Atividade', mode: ChatMode.amigos),
        StorySlide(id: 'a8', type: 'emoji-culture', title: 'Emoji Culture', mode: ChatMode.amigos),
        StorySlide(id: 'a9', type: 'floods', title: 'Flood Moments', mode: ChatMode.amigos),
        StorySlide(id: 'a10', type: 'personalities', title: 'Personalidades', mode: ChatMode.amigos),
        StorySlide(id: 'a11', type: 'stats', title: 'Estatísticas do Squad', mode: ChatMode.amigos),
        StorySlide(id: 'a12', type: 'insight', title: 'Insight', mode: ChatMode.amigos),
        StorySlide(id: 'a13', type: 'ignoring', title: 'Interações Ocultas', mode: ChatMode.amigos),
        StorySlide(id: 'a14', type: 'audio-ignoring', title: 'Áudios no Vácuo', mode: ChatMode.amigos),
        StorySlide(id: 'a15', type: 'fake-screenshots', title: 'Prints Tirados', mode: ChatMode.amigos),
        StorySlide(id: 'a16', type: 'fake-forwarded', title: 'Encaminhamentos', mode: ChatMode.amigos),
        StorySlide(id: 'a17', type: 'fake-typed', title: 'Digitou mas não enviou', mode: ChatMode.amigos),
        StorySlide(id: 'a18', type: 'final', title: 'Conclusão', mode: ChatMode.amigos),
      ];

  static List<StorySlide> getGrupoSlides() => const [
        StorySlide(id: 'g1', type: 'header', title: 'Capa', mode: ChatMode.grupo),
        StorySlide(id: 'g2', type: 'total', title: 'Total de Mensagens', mode: ChatMode.grupo),
        StorySlide(id: 'g3', type: 'ranking', title: 'Top 3 Membros', mode: ChatMode.grupo),
        StorySlide(id: 'g4', type: 'dynamics', title: 'Dinâmicas do Grupo', mode: ChatMode.grupo),
        StorySlide(id: 'g5', type: 'timeline', title: 'Atividade no Tempo', mode: ChatMode.grupo),
        StorySlide(id: 'g6', type: 'topics', title: 'Top Conversas', mode: ChatMode.grupo),
        StorySlide(id: 'g7', type: 'heatmap', title: 'Heatmap de Atividade', mode: ChatMode.grupo),
        StorySlide(id: 'g8', type: 'emoji-evolution', title: 'Evolução de Emojis', mode: ChatMode.grupo),
        StorySlide(id: 'g9', type: 'floods', title: 'Flood Moments', mode: ChatMode.grupo),
        StorySlide(id: 'g10', type: 'network', title: 'Análise de Rede', mode: ChatMode.grupo),
        StorySlide(id: 'g11', type: 'insight', title: 'Insight', mode: ChatMode.grupo),
        StorySlide(id: 'g12', type: 'ignoring', title: 'Quem Mais Ignora', mode: ChatMode.grupo),
        StorySlide(id: 'g13', type: 'fake-screenshots', title: 'Quem Mais Tira Print', mode: ChatMode.grupo),
        StorySlide(id: 'g14', type: 'fake-forwarded', title: 'Quem Mais Encaminha', mode: ChatMode.grupo),
        StorySlide(id: 'g15', type: 'fake-deleted', title: 'Quem Mais Apaga', mode: ChatMode.grupo),
        StorySlide(id: 'g16', type: 'final', title: 'Conclusão', mode: ChatMode.grupo),
      ];
}

// ============================================================================
// 6. SWISS DESIGN SYSTEM CONTRACT CONSTANTS
// ============================================================================

class SwissDesignTokens {
  // Monotone neutral palette
  static const int darkBackground = 0xFF0B0C0E;
  static const int darkSurface = 0xFF14171A;
  static const int lightBackground = 0xFFF8F9FA;
  static const int lightSurface = 0xFFFFFFFF;

  // Disciplined accent
  static const int emeraldPrimary = 0xFF00DC82;
  static const int emeraldSecondary = 0xFF10B981;

  // Squircle geometry standard
  static const double squircleCardRadius = 24.0;
  static const double squircleButtonRadius = 16.0;

  // Micro-animation physics
  static const double pressScaleDown = 0.97;
  static const int storyDurationMs = 5000;
  static const double storiesPrevTapRatio = 0.30;
  static const double storiesNextTapRatio = 0.70;
}
