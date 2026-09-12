import '../models/amigos_stats.dart';
import '../models/casal_stats.dart';
import '../models/chat_message.dart';
import '../models/general_stats.dart';
import '../models/grupo_stats.dart';
import '../models/raw_chat_export.dart';
import 'amigos_analyzer.dart';
import 'casal_analyzer.dart';
import 'grupo_analyzer.dart';

/// Central coordinator for offline WhatsApp analytics.
/// Auto-detects modes, calculates universal statistics, and routes to specialized analyzers.
class ChatAnalyzer {
  static const List<String> monthNames = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  static const List<String> weekdayNames = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];

  static final RegExp emojiRegex = RegExp(
    r'(?:[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{27FF}]|[\u{1F600}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}])',
    unicode: true,
  );

  /// Automatically categorizes chat:
  /// - <= 2 participants: defaults to Casal (duo lens, user can choose Casal or Amigos)
  /// - >= 3 participants: directly Grupo mode
  static ChatMode detectMode(int participantCount) {
    if (participantCount <= 2) {
      return ChatMode.casal;
    } else {
      return ChatMode.grupo;
    }
  }

  /// Calculates universal baseline statistics across all messages.
  static GeneralStats calculateGeneralStats(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return GeneralStats.empty();
    }

    final participantCounts = <String, int>{};
    for (final m in messages) {
      if (!m.isSystem && m.author.isNotEmpty) {
        participantCounts[m.author] = (participantCounts[m.author] ?? 0) + 1;
      }
    }

    final participants = participantCounts.keys.toList()..sort();

    DateTime start = messages.first.timestamp;
    DateTime end = messages.first.timestamp;
    for (final m in messages) {
      if (m.timestamp.isBefore(start)) start = m.timestamp;
      if (m.timestamp.isAfter(end)) end = m.timestamp;
    }

    // Timeline grouping (month/year)
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
    }).toList()
      ..sort((a, b) {
        if (a.year != b.year) return a.year.compareTo(b.year);
        return monthNames.indexOf(a.month).compareTo(monthNames.indexOf(b.month));
      });

    // Active hours (0..23)
    final hourCounts = List<int>.filled(24, 0);
    for (final m in messages) {
      hourCounts[m.timestamp.hour]++;
    }
    final hourActivities = List.generate(
      24,
      (i) => HourActivity(hour: i, count: hourCounts[i]),
    )..sort((a, b) => b.count.compareTo(a.count));
    final activeHours = hourActivities.take(5).toList();

    // Active days (Segunda..Domingo)
    final dayCounts = List<int>.filled(7, 0);
    for (final m in messages) {
      dayCounts[m.timestamp.weekday - 1]++;
    }
    final dayActivities = List.generate(
      7,
      (i) => DayActivity(day: weekdayNames[i], count: dayCounts[i]),
    )..sort((a, b) => b.count.compareTo(a.count));

    // Top emojis (excluding media markers)
    final emojiMap = <String, int>{};
    for (final m in messages) {
      if (m.isMedia) continue;
      for (final match in emojiRegex.allMatches(m.content)) {
        final em = match.group(0)!;
        emojiMap[em] = (emojiMap[em] ?? 0) + 1;
      }
    }
    final topEmojis = (emojiMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(10)
        .map((e) => EmojiCount(emoji: e.key, count: e.value))
        .toList();

    // Top words (length > 3, alphanumeric only)
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

    // Average response time (< 24h)
    int totalResponseMs = 0;
    int responseCount = 0;
    for (int i = 1; i < messages.length; i++) {
      final prev = messages[i - 1];
      final curr = messages[i];
      if (prev.author != curr.author) {
        final delta =
            curr.timestamp.difference(prev.timestamp).inMilliseconds;
        if (delta >= 0 && delta < 86400000) {
          totalResponseMs += delta;
          responseCount++;
        }
      }
    }
    final avgResp =
        responseCount > 0 ? totalResponseMs / responseCount : 0.0;

    final mediaCount = messages.where((m) => m.isMedia).length;

    return GeneralStats(
      totalMessages: messages.length,
      participants: participants,
      startDate: start,
      endDate: end,
      timeline: timeline,
      activeHours: activeHours,
      activeDays: dayActivities,
      topEmojis: topEmojis,
      topWords: topWords,
      averageResponseTimeMs: avgResp,
      mediaCount: mediaCount,
      participantCounts: participantCounts,
    );
  }

  /// Primary entry point analyzing a full raw chat export.
  static ChatAnalysisResult analyzeRawExport(
    RawChatExport export, {
    ChatMode? overrideMode,
  }) {
    return analyzeMessages(export.messages, overrideMode: overrideMode);
  }

  /// Entry point analyzing a list of messages with auto-detection or override.
  static ChatAnalysisResult analyzeMessages(
    List<ChatMessage> messages, {
    ChatMode? overrideMode,
  }) {
    final general = calculateGeneralStats(messages);
    final mode = overrideMode ?? detectMode(general.participants.length);

    switch (mode) {
      case ChatMode.casal:
        final stats = CasalAnalyzer.analyze(messages, general);
        return CasalAnalysisResult(stats);
      case ChatMode.amigos:
        final stats = AmigosAnalyzer.analyze(messages, general);
        return AmigosAnalysisResult(stats);
      case ChatMode.grupo:
        final stats = GrupoAnalyzer.analyze(messages, general);
        return GrupoAnalysisResult(stats);
    }
  }

  /// Directly generates CasalAnalysisResult.
  static CasalAnalysisResult analyzeCasal(
    List<ChatMessage> messages, [
    GeneralStats? general,
  ]) {
    final gen = general ?? calculateGeneralStats(messages);
    return CasalAnalysisResult(CasalAnalyzer.analyze(messages, gen));
  }

  /// Directly generates AmigosAnalysisResult.
  static AmigosAnalysisResult analyzeAmigos(
    List<ChatMessage> messages, [
    GeneralStats? general,
  ]) {
    final gen = general ?? calculateGeneralStats(messages);
    return AmigosAnalysisResult(AmigosAnalyzer.analyze(messages, gen));
  }

  /// Directly generates GrupoAnalysisResult.
  static GrupoAnalysisResult analyzeGrupo(
    List<ChatMessage> messages, [
    GeneralStats? general,
  ]) {
    final gen = general ?? calculateGeneralStats(messages);
    return GrupoAnalysisResult(GrupoAnalyzer.analyze(messages, gen));
  }
}
