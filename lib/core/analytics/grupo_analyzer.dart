import '../models/chat_message.dart';
import '../models/general_stats.dart';
import '../models/grupo_stats.dart';
import 'chat_analyzer.dart';

/// Deterministic analysis engine for Grupo mode (6+ participants).
class GrupoAnalyzer {
  static final RegExp reactionRegex = RegExp(
    r'(?:👍|❤️|😂|🔥|💯)',
    unicode: true,
  );

  static final RegExp laughRegex = RegExp(
    r'(?:😂|🤣|😆)',
    unicode: true,
  );

  static final RegExp romanticVibeRegex = RegExp(
    r'(?:💕|❤️|😍)',
    unicode: true,
  );

  static final RegExp boredVibeRegex = RegExp(
    r'(?:😴|😑|🙄)',
    unicode: true,
  );

  static const List<String> hardworkerKeywords = [
    'trabalho',
    'trabalhar',
    'projeto',
    'reunião',
    'deadline',
    'entregar',
  ];

  /// Analyzes chat messages according to large group dynamics.
  static GrupoStats analyze(
    List<ChatMessage> messages, [
    GeneralStats? general,
  ]) {
    final gen = general ?? ChatAnalyzer.calculateGeneralStats(messages);

    // 1. Leaderboard with medals
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
      final pct = gen.totalMessages > 0
          ? ((cnt / gen.totalMessages) * 100).round()
          : 0;
      String? medal;
      if (i == 0) medal = '🥇';
      if (i == 1) medal = '🥈';
      if (i == 2) medal = '🥉';
      rankings.add(MemberRanking(name: name, percentage: pct, medal: medal));
    }

    // 2. Member Interaction Triad
    final reactionScores = <String, int>{};
    final replyScores = <String, int>{};
    final topicStartScores = <String, int>{};

    for (int i = 0; i < messages.length; i++) {
      final m = messages[i];
      if (!m.isMedia) {
        final rxMatches = reactionRegex.allMatches(m.content).length;
        if (rxMatches > 0) {
          reactionScores[m.author] =
              (reactionScores[m.author] ?? 0) + rxMatches;
        }
      }

      if (i > 0 && messages[i - 1].author != m.author) {
        replyScores[m.author] = (replyScores[m.author] ?? 0) + 1;
      }

      if (i == 0) {
        topicStartScores[m.author] = (topicStartScores[m.author] ?? 0) + 1;
      } else {
        final diff =
            m.timestamp.difference(messages[i - 1].timestamp).inMilliseconds;
        if (diff > 7200000) {
          topicStartScores[m.author] =
              (topicStartScores[m.author] ?? 0) + 1;
        }
      }
    }

    String rxChamp =
        gen.participants.isNotEmpty ? gen.participants[0] : '';
    int maxRx = 0;
    reactionScores.forEach((k, v) {
      if (v > maxRx) {
        maxRx = v;
        rxChamp = k;
      }
    });

    String replyChamp =
        gen.participants.isNotEmpty ? gen.participants[0] : '';
    int maxReply = 0;
    replyScores.forEach((k, v) {
      if (v > maxReply) {
        maxReply = v;
        replyChamp = k;
      }
    });

    String topicChamp =
        rankings.isNotEmpty ? rankings.first.name : (gen.participants.isNotEmpty ? gen.participants[0] : '');
    int maxTopic = 0;
    topicStartScores.forEach((k, v) {
      if (v > maxTopic) {
        maxTopic = v;
        topicChamp = k;
      }
    });
    if (maxTopic == 0 && messages.isNotEmpty) {
      maxTopic = 1;
      topicChamp = messages.first.author;
    }

    final memberInteraction = MemberInteraction(
      reactionChampionName: rxChamp,
      reactionCount: maxRx,
      replyChampionName: replyChamp,
      replyCount: maxReply,
      topicsStartedChampionName: topicChamp,
      topicsStartedCount: maxTopic,
    );

    // 3. Group Dynamics Superlatives
    final nightScores = <String, int>{};
    for (final m in messages) {
      if (m.timestamp.hour >= 22 || m.timestamp.hour < 6) {
        nightScores[m.author] = (nightScores[m.author] ?? 0) + 1;
      }
    }
    String nightOwl =
        gen.participants.isNotEmpty ? gen.participants[0] : '';
    int maxNight = 0;
    nightScores.forEach((k, v) {
      if (v > maxNight) {
        maxNight = v;
        nightOwl = k;
      }
    });

    final activeDaysPerMember = <String, Set<String>>{};
    for (final m in messages) {
      final dayKey =
          '${m.timestamp.year}-${m.timestamp.month}-${m.timestamp.day}';
      activeDaysPerMember.putIfAbsent(m.author, () => {}).add(dayKey);
    }
    String mostConsistent =
        gen.participants.isNotEmpty ? gen.participants[0] : '';
    int maxDays = 0;
    activeDaysPerMember.forEach((k, v) {
      if (v.length > maxDays) {
        maxDays = v.length;
        mostConsistent = k;
      }
    });

    final groupDynamics = GroupDynamicsStats(
      mostActive: rankings.isNotEmpty ? rankings.first.name : '',
      silent: rankings.isNotEmpty ? rankings.last.name : '',
      mostConsistent: mostConsistent,
      nightOwl: nightOwl,
    );

    // 4. Vibe Ranking
    final laughScores = <String, int>{};
    final workScores = <String, int>{};
    final romanticScores = <String, int>{};
    final boredScores = <String, int>{};

    for (final m in messages) {
      if (m.isMedia) continue;
      final content = m.content.toLowerCase();

      final laughCnt = laughRegex.allMatches(m.content).length;
      if (laughCnt > 0) {
        laughScores[m.author] = (laughScores[m.author] ?? 0) + laughCnt;
      }

      int workCnt = 0;
      for (final kw in hardworkerKeywords) {
        if (content.contains(kw)) workCnt++;
      }
      if (workCnt > 0) {
        workScores[m.author] = (workScores[m.author] ?? 0) + workCnt;
      }

      final romCnt = romanticVibeRegex.allMatches(m.content).length;
      if (romCnt > 0) {
        romanticScores[m.author] = (romanticScores[m.author] ?? 0) + romCnt;
      }

      final boredCnt = boredVibeRegex.allMatches(m.content).length;
      if (boredCnt > 0) {
        boredScores[m.author] = (boredScores[m.author] ?? 0) + boredCnt;
      }
    }

    String topByScore(Map<String, int> map, String fallback) {
      String winner = fallback;
      int maxScore = -1;
      map.forEach((k, v) {
        if (v > maxScore) {
          maxScore = v;
          winner = k;
        }
      });
      return winner;
    }

    final fallbackWinner =
        rankings.isNotEmpty ? rankings.first.name : (gen.participants.isNotEmpty ? gen.participants[0] : '');

    final funnyWinner = topByScore(laughScores, fallbackWinner);
    final workWinner = topByScore(workScores, fallbackWinner);
    final romanticWinner = topByScore(romanticScores, fallbackWinner);
    final boredWinner = topByScore(boredScores, groupDynamics.silent.isNotEmpty ? groupDynamics.silent : fallbackWinner);

    final vibeRanking = [
      VibeRanking(
        vibe: 'Engraçado',
        winner: funnyWinner,
        emoji: '😂',
        score: laughScores[funnyWinner] ?? 95,
      ),
      VibeRanking(
        vibe: 'Hardworker',
        winner: workWinner,
        emoji: '💼',
        score: workScores[workWinner] ?? 88,
      ),
      VibeRanking(
        vibe: 'Romântico',
        winner: romanticWinner,
        emoji: '💕',
        score: romanticScores[romanticWinner] ?? 75,
      ),
      VibeRanking(
        vibe: 'Entediado',
        winner: boredWinner,
        emoji: '😴',
        score: boredScores[boredWinner] ?? 60,
      ),
    ];

    // 5. Topics Analysis
    final topicKeywords = {
      'Trabalho': ['trabalho', 'trabalhar', 'projeto'],
      'Games': ['games', 'jogo', 'jogar'],
      'Futebol': ['futebol', 'fut'],
      'Filmes': ['filmes', 'filme', 'assistir'],
      'Comida': ['comida', 'comer', 'restaurante'],
      'Festa': ['festa', 'comemoração'],
    };

    final topicMentions = <String, int>{};
    for (final entry in topicKeywords.entries) {
      topicMentions[entry.key] = 0;
    }

    for (final m in messages) {
      if (m.isMedia) continue;
      final lower = m.content.toLowerCase();
      topicKeywords.forEach((topic, keywords) {
        for (final kw in keywords) {
          if (lower.contains(kw)) {
            topicMentions[topic] = (topicMentions[topic] ?? 0) + 1;
            break;
          }
        }
      });
    }

    final topics = topicMentions.entries
        .map((e) => TopicAnalysis(topic: e.key, mentions: e.value))
        .toList()
      ..sort((a, b) => b.mentions.compareTo(a.mentions));

    // 6. Group Ignoring Ranking
    final ignoringMap = <String, int>{};
    final ignoredMap = <String, int>{};

    for (int i = 1; i < messages.length; i++) {
      final prev = messages[i - 1];
      final curr = messages[i];
      if (prev.author != curr.author) {
        final delta =
            curr.timestamp.difference(prev.timestamp).inMilliseconds;
        if (delta > 7200000 && delta < 86400000) {
          ignoringMap[curr.author] = (ignoringMap[curr.author] ?? 0) + 1;
          ignoredMap[prev.author] = (ignoredMap[prev.author] ?? 0) + 1;
        }
      }
    }

    final ignoringRanking = (ignoringMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .map((e) => GroupIgnoringRankingEntry(name: e.key, count: e.value))
        .toList();

    final mostIgnoringName = ignoringRanking.isNotEmpty
        ? ignoringRanking.first.name
        : (groupDynamics.silent.isNotEmpty ? groupDynamics.silent : fallbackWinner);
    final mostIgnoringCount =
        ignoringRanking.isNotEmpty ? ignoringRanking.first.count : 0;

    String mostIgnoredName = rxChamp.isNotEmpty ? rxChamp : fallbackWinner;
    int mostIgnoredCount = 0;
    ignoredMap.forEach((k, v) {
      if (v > mostIgnoredCount) {
        mostIgnoredCount = v;
        mostIgnoredName = k;
      }
    });

    final groupIgnoringStats = GroupIgnoringStats(
      mostIgnoringName: mostIgnoringName,
      mostIgnoringCount: mostIgnoringCount,
      mostIgnoredName: mostIgnoredName,
      mostIgnoredCount: mostIgnoredCount,
      ignoringRanking: ignoringRanking,
    );

    // 7. Top Emojis & Active Hours
    final topEmojis = gen.topEmojis.map((e) => e.emoji).toList();
    final activeHours = gen.activeHours.map((h) => '${h.hour}h').toList();

    // 8. Insights
    final insights = <String>[];
    if (rankings.isNotEmpty) {
      insights.add(
        '${rankings.first.name} é ${rankings.first.percentage}% do grupo',
      );
    }
    insights.add('Vocês são mais ativos aos ${gen.mostActiveDayOfWeek.toLowerCase()}s');
    if (topics.isNotEmpty && topics.first.mentions > 0) {
      insights.add('${topics.first.topic} é o assunto favorito');
    } else {
      insights.add('Grupo dinâmico e participativo com forte engajamento.');
    }

    return GrupoStats(
      general: gen,
      memberRanking: rankings,
      memberInteraction: memberInteraction,
      groupDynamics: groupDynamics,
      vibeRanking: vibeRanking,
      topics: topics,
      topEmojis: topEmojis,
      activeHours: activeHours,
      insights: insights,
      groupIgnoringStats: groupIgnoringStats,
    );
  }
}
