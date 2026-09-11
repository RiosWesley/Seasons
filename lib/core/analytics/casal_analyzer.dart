import 'dart:math';

import '../models/casal_stats.dart';
import '../models/chat_message.dart';
import '../models/general_stats.dart';
import 'chat_analyzer.dart';

/// Deterministic analysis engine for Casal mode (2 participants).
class CasalAnalyzer {
  static const List<String> romanticWords = [
    'amor',
    'amorzinho',
    'querido',
    'querida',
    'coração',
    'beijo',
    'beijinho',
    'te amo',
    'amo você',
    'lindo',
    'linda',
    'gatinho',
    'gatinha',
    'fofo',
    'fofa',
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

  static final RegExp heartRegex = RegExp(
    r'(?:❤️|💕|💖|💗|💓|💞|💝|♥️)',
    unicode: true,
  );

  static final RegExp laughRegex = RegExp(
    r'(?:😂|🤣|😆|😄|😃)',
    unicode: true,
  );

  static final RegExp emojiRegex = RegExp(
    r'(?:[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{27FF}]|[\u{1F600}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}])',
    unicode: true,
  );

  /// Performs complete offline analysis for a couple chat export.
  static CasalStats analyze(
    List<ChatMessage> messages, [
    GeneralStats? general,
  ]) {
    final gen = general ?? ChatAnalyzer.calculateGeneralStats(messages);

    // 1. Love language breakdown
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

    // 2. Compatibility calculation
    final p1 = gen.participants.isNotEmpty ? gen.participants[0] : 'P1';
    final p2 = gen.participants.length > 1 ? gen.participants[1] : 'P2';

    final p1Msgs = messages.where((m) => m.author == p1).toList();
    final p2Msgs = messages.where((m) => m.author == p2).toList();

    double avgLen1 = p1Msgs.isEmpty
        ? 0.0
        : p1Msgs.map((m) => m.content.length).reduce((a, b) => a + b) /
            p1Msgs.length;
    double avgLen2 = p2Msgs.isEmpty
        ? 0.0
        : p2Msgs.map((m) => m.content.length).reduce((a, b) => a + b) /
            p2Msgs.length;

    double maxLen = max(avgLen1, avgLen2);
    if (maxLen < 1) maxLen = 1.0;
    double sLen = 1.0 - ((avgLen1 - avgLen2).abs() / maxLen);
    if (sLen < 0) sLen = 0.0;

    double emojiRatio1 = p1Msgs.isEmpty
        ? 0.0
        : p1Msgs.where((m) => emojiRegex.hasMatch(m.content)).length /
            p1Msgs.length;
    double emojiRatio2 = p2Msgs.isEmpty
        ? 0.0
        : p2Msgs.where((m) => emojiRegex.hasMatch(m.content)).length /
            p2Msgs.length;
    double sEmoji = 1.0 - (emojiRatio1 - emojiRatio2).abs();
    if (sEmoji < 0) sEmoji = 0.0;

    double sResp;
    if (gen.averageResponseTimeMs < 3600000) {
      sResp = 0.9;
    } else if (gen.averageResponseTimeMs < 14400000) {
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

    // 3. Participant stats
    final participantStats = <ParticipantStats>[];
    for (final p in gen.participants) {
      final pTextMsgs =
          messages.where((m) => m.author == p && !m.isMedia).toList();

      final emojiCounts = <String, int>{};
      final wordCounts = <String, int>{};
      final hourCounts = List<int>.filled(24, 0);
      final dayCounts = List<int>.filled(7, 0);

      for (final m in pTextMsgs) {
        for (final match in emojiRegex.allMatches(m.content)) {
          final em = match.group(0)!;
          emojiCounts[em] = (emojiCounts[em] ?? 0) + 1;
        }

        final cleaned = m.content
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-záéíóúâêîôûãõç0-9]'), ' ');
        for (final token in cleaned.split(RegExp(r'\s+'))) {
          if (token.length > 3) {
            wordCounts[token] = (wordCounts[token] ?? 0) + 1;
          }
        }

        hourCounts[m.timestamp.hour]++;
        dayCounts[m.timestamp.weekday - 1]++;
      }

      String topEmoji = '😊';
      int maxEmoji = 0;
      emojiCounts.forEach((k, v) {
        if (v > maxEmoji) {
          maxEmoji = v;
          topEmoji = k;
        }
      });

      String topWord = '';
      int maxWord = 0;
      wordCounts.forEach((k, v) {
        if (v > maxWord) {
          maxWord = v;
          topWord = k;
        }
      });

      int activeHour = 12;
      int maxHour = -1;
      for (int h = 0; h < 24; h++) {
        if (hourCounts[h] > maxHour) {
          maxHour = hourCounts[h];
          activeHour = h;
        }
      }

      String activeDay = 'Segunda';
      int maxDay = -1;
      for (int d = 0; d < 7; d++) {
        if (dayCounts[d] > maxDay) {
          maxDay = dayCounts[d];
          activeDay = weekdayNames[d];
        }
      }

      participantStats.add(
        ParticipantStats(
          name: p,
          topEmoji: topEmoji,
          topWord: topWord,
          activeHour: activeHour,
          activeDay: activeDay,
        ),
      );
    }

    // 4. Ignoring stats (> 2 hours, < 24 hours)
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

    // 5. Audio ignoring stats (> 1 hour)
    int ignoredAudios = 0;
    int wasIgnoredAudios = 0;
    int totalAudios = messages.where((m) => m.isMedia).length;

    for (int i = 0; i < messages.length - 1; i++) {
      final msg = messages[i];
      if (msg.isMedia) {
        for (int j = i + 1; j < messages.length; j++) {
          final next = messages[j];
          if (next.author != msg.author) {
            final delta =
                next.timestamp.difference(msg.timestamp).inMilliseconds;
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

    // 6. Response time stats
    int fastest = 999999999;
    int slowest = 0;
    int respCount = 0;
    int sumResp = 0;
    for (int i = 1; i < messages.length; i++) {
      if (messages[i].author != messages[i - 1].author) {
        final delta = messages[i]
            .timestamp
            .difference(messages[i - 1].timestamp)
            .inMilliseconds;
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
      averageResponseTimeMs: respCount > 0 ? sumResp / respCount : 0.0,
      fastestResponseMs: fastest,
      slowestResponseMs: slowest,
      responseCount: respCount,
    );

    // 7. Insights
    final insights = <String>[];
    if (messages.isNotEmpty) {
      final p1Count = p1Msgs.length;
      final p2Count = p2Msgs.length;
      final p1Pct = ((p1Count / messages.length) * 100).round();
      final p2Pct = ((p2Count / messages.length) * 100).round();

      if (p1Pct > 60) {
        insights.add('$p1 é $p1Pct% da conversa');
      } else if (p2Pct > 60) {
        insights.add('$p2 é $p2Pct% da conversa');
      } else {
        insights.add('Vocês têm uma conversa equilibrada');
      }
    }

    final mostActiveDay = gen.mostActiveDayOfWeek;
    insights.add('Conversam mais aos ${mostActiveDay.toLowerCase()}s');

    if (gen.timeline.isNotEmpty) {
      final peak = (List.of(gen.timeline)
            ..sort((a, b) => b.count.compareTo(a.count)))
          .first;
      insights.add('Pico de mensagens em ${peak.month}/${peak.year}');
    }

    if (gen.topWords.isNotEmpty) {
      insights.add('"${gen.topWords.first.word}" foi a palavra mais usada');
    }

    if (compScore >= 85) {
      insights.add('Vocês combinam demais! 💕');
    }

    return CasalStats(
      general: gen,
      loveLanguage: loveLanguage,
      compatibility: compatibility,
      participantStats: participantStats,
      insights: insights,
      ignoringStats: ignoringStats,
      audioIgnoringStats: audioIgnoringStats,
      responseTimeStats: responseTimeStats,
    );
  }
}
