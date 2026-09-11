import '../models/amigos_stats.dart';
import '../models/casal_stats.dart';
import '../models/chat_message.dart';
import '../models/general_stats.dart';
import 'chat_analyzer.dart';

/// Deterministic analysis engine for Amigos mode (3-5 participants).
class AmigosAnalyzer {
  static final RegExp laughRegex = RegExp(
    r'(?:😂|🤣|😆|😄|😃)',
    unicode: true,
  );

  static final RegExp emojiRegex = RegExp(
    r'(?:[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{27FF}]|[\u{1F600}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}])',
    unicode: true,
  );

  /// Analyzes chat messages according to Amigos (squad) mode dynamics.
  static AmigosStats analyze(
    List<ChatMessage> messages, [
    GeneralStats? general,
  ]) {
    final gen = general ?? ChatAnalyzer.calculateGeneralStats(messages);

    // 1. Communication Styles (Personas decision tree)
    final styles = <CommunicationStyle>[];
    for (final p in gen.participants) {
      final pMsgs =
          messages.where((m) => m.author == p && !m.isMedia).toList();
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

    // 2. Vibe Compatibility Score
    final uniqueStyles = styles.map((s) => s.style).toSet().length;
    final diversity = gen.participants.isNotEmpty
        ? uniqueStyles / gen.participants.length
        : 1.0;
    final vibeScore = ((0.5 * diversity + 0.5) * 100).round();
    final vibeDesc = vibeScore >= 90
        ? 'Vibe perfeita! 👯'
        : (vibeScore >= 70
            ? 'Vibes complementares!'
            : 'Vibes diferentes, mas funcionam!');
    final compatibility = CompatibilityScore(
      score: vibeScore,
      description: vibeDesc,
    );

    // 3. Monologue Flood streak
    String floodWinner =
        gen.participants.isNotEmpty ? gen.participants[0] : '';
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

    // 4. Fastest Replier
    final replyTimes = <String, List<int>>{};
    for (int i = 1; i < messages.length; i++) {
      if (messages[i].author != messages[i - 1].author) {
        final delta = messages[i]
            .timestamp
            .difference(messages[i - 1].timestamp)
            .inMilliseconds;
        if (delta >= 0 && delta < 86400000) {
          replyTimes.putIfAbsent(messages[i].author, () => []).add(delta);
        }
      }
    }

    String fastestName =
        gen.participants.isNotEmpty ? gen.participants[0] : '';
    double lowestAvgMs = 999999999.0;
    replyTimes.forEach((k, v) {
      final avg = v.reduce((a, b) => a + b) / v.length;
      if (avg < lowestAvgMs) {
        lowestAvgMs = avg;
        fastestName = k;
      }
    });

    final fastestFormatted = lowestAvgMs < 60000
        ? '1min'
        : (lowestAvgMs < 300000 ? '5min' : '10min');

    // 5. Author with most messages
    final counts = <String, int>{};
    for (final m in messages) {
      counts[m.author] = (counts[m.author] ?? 0) + 1;
    }
    String topAuthor =
        gen.participants.isNotEmpty ? gen.participants[0] : '';
    int maxAuthorCount = -1;
    for (final p in gen.participants) {
      final c = counts[p] ?? 0;
      if (c > maxAuthorCount) {
        maxAuthorCount = c;
        topAuthor = p;
      }
    }

    final friendStat = FriendStat(
      mostMessagesName: topAuthor,
      mostMessagesCount: messages.length,
      fastestReplyName: fastestName,
      fastestReplyTimeFormatted: fastestFormatted,
      favoriteEmoji:
          gen.topEmojis.isNotEmpty ? gen.topEmojis.first.emoji : '😂',
      favoriteEmojiCount:
          gen.topEmojis.isNotEmpty ? gen.topEmojis.first.count : 0,
      biggestFloodName: floodWinner,
      biggestFloodCount: maxFlood,
      activeHourFormatted:
          '${gen.activeHours.isNotEmpty ? gen.activeHours.first.hour : 20}h',
    );

    // 6. Group dynamic roles
    final groupDynamics = GroupDynamic(
      conversationStarter: messages.isNotEmpty
          ? messages.first.author
          : (gen.participants.isNotEmpty ? gen.participants.first : ''),
      mostInteractive: fastestName,
    );

    // 7. Response turnaround stats
    final totalReplies =
        replyTimes.values.fold(0, (sum, list) => sum + list.length);
    final responseTimeStats = ResponseTimeStats(
      averageResponseTimeMs: lowestAvgMs < 999999999 ? lowestAvgMs : 0.0,
      fastestResponseMs: 0,
      slowestResponseMs: 0,
      responseCount: totalReplies,
    );

    // 8. Ignoring stats
    const ignoringStats = IgnoringStats(
      ignoredCount: 0,
      wasIgnoredCount: 0,
      longestIgnoredTimeMs: 0,
      mostIgnoredDay: 'Sábado',
    );

    const audioIgnoringStats = AudioIgnoringStats(
      ignoredAudios: 0,
      wasIgnoredAudios: 0,
      totalAudios: 0,
    );

    // 9. Insights
    final insights = <String>[
      'Vocês são mais ativos aos ${gen.mostActiveDayOfWeek.toLowerCase()}s',
      if (gen.topWords.isNotEmpty)
        'Assunto favorito: ${gen.topWords.first.word}'
      else
        'Grupo vibrante com excelente dinâmica coletiva',
      if (friendStat.mostMessagesName.isNotEmpty)
        '${friendStat.mostMessagesName} é o que mais escreve',
      if (friendStat.fastestReplyName.isNotEmpty)
        '${friendStat.fastestReplyName} sempre responde rápido',
    ];

    return AmigosStats(
      general: gen,
      communicationStyles: styles,
      compatibility: compatibility,
      friendStats: friendStat,
      groupDynamics: groupDynamics,
      insights: insights,
      ignoringStats: ignoringStats,
      audioIgnoringStats: audioIgnoringStats,
      responseTimeStats: responseTimeStats,
    );
  }
}
