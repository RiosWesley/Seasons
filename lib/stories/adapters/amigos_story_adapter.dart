import '../../core/models/amigos_stats.dart';
import '../../core/models/casal_stats.dart';
import '../../core/models/general_stats.dart';

/// Adapter providing strongly-typed, clean accessors and deterministic
/// derivations for Amigos/Squad Mode story slides (a1..a18).
class AmigosStoryAdapter {
  final AmigosAnalysisResult result;

  const AmigosStoryAdapter(this.result);

  factory AmigosStoryAdapter.fromStats(AmigosStats stats) =>
      AmigosStoryAdapter(AmigosAnalysisResult(stats));

  // --- Squad & Duo Members & Volumes ---
  List<String> get participants => result.generalStats.participants;

  int get memberCount => participants.length;

  bool get isDuo => participants.length == 2;

  String get friendA =>
      participants.isNotEmpty ? participants[0] : 'Amigo 1';

  String get friendB =>
      participants.length > 1 ? participants[1] : 'Amigo 2';

  String get duoNames => isDuo ? '$friendA & $friendB' : squadRosterFormatted;

  String get squadRosterFormatted {
    if (participants.isEmpty) return 'Dupla';
    if (isDuo) return '$friendA & $friendB';
    if (participants.length <= 3) return participants.join(' • ');
    return '${participants.take(3).join(', ')} e +${participants.length - 3}';
  }

  int get totalMessages => result.generalStats.totalMessages;

  Map<String, int> get participantCounts => result.generalStats.participantCounts;

  List<MapEntry<String, int>> get sortedMemberVolumes {
    final entries = participantCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  int get friendAMessages {
    final counts = participantCounts;
    if (counts.containsKey(friendA)) return counts[friendA]!;
    return totalMessages > 0 ? (totalMessages / 2).round() : 0;
  }

  int get friendBMessages {
    final counts = participantCounts;
    if (counts.containsKey(friendB)) return counts[friendB]!;
    return (totalMessages - friendAMessages).clamp(0, totalMessages);
  }

  int get friendAPercentage =>
      totalMessages > 0 ? ((friendAMessages / totalMessages) * 100).round() : 50;

  int get friendBPercentage =>
      totalMessages > 0 ? (100 - friendAPercentage) : 50;

  String get mostChattyFriend =>
      friendAMessages >= friendBMessages ? friendA : friendB;

  String get leastChattyFriend =>
      friendAMessages >= friendBMessages ? friendB : friendA;

  DateTime get startDate => result.generalStats.startDate;
  DateTime get endDate => result.generalStats.endDate;

  // --- Archetypes & Dynamics (Squad & Duo) ---
  List<CommunicationStyle> get communicationStyles =>
      result.communicationStyles;

  CommunicationStyle get friendAStyle {
    for (final s in communicationStyles) {
      if (s.name == friendA) return s;
    }
    return CommunicationStyle(
      name: friendA,
      style: 'expressivo',
      emoji: '😊',
    );
  }

  CommunicationStyle get friendBStyle {
    for (final s in communicationStyles) {
      if (s.name == friendB) return s;
    }
    return CommunicationStyle(
      name: friendB,
      style: 'engraçado',
      emoji: '😂',
    );
  }

  String styleSignature(CommunicationStyle style) {
    switch (style.style.toLowerCase()) {
      case 'engraçado':
        return 'Manda risadas e figurinhas sem moderação';
      case 'expressivo':
        return 'Reações intensas e pontua tudo com emojis';
      case 'detalhista':
        return 'Digita a história inteira nos mínimos detalhes';
      case 'objetivo':
        return 'Respostas rápidas que encerram o assunto';
      case 'carinhoso':
      default:
        return 'Sempre presente com apoio e boas energias';
    }
  }

  CompatibilityScore get compatibility => result.compatibility;
  int get compatibilityScore => result.compatibility.score;
  String get compatibilityDescription => result.compatibility.description;

  FriendStat get friendStats => result.friendStats;
  GroupDynamic get groupDynamics => result.groupDynamics;

  // --- Temporal & Vocabulary Stats ---
  List<TimelineData> get timeline => result.generalStats.timeline;

  TimelineData? get peakTimelineMonth {
    if (timeline.isEmpty) return null;
    TimelineData peak = timeline.first;
    for (final entry in timeline) {
      if (entry.count > peak.count) {
        peak = entry;
      }
    }
    return peak;
  }

  List<WordCount> get topWords => result.generalStats.topWords;
  List<EmojiCount> get topEmojis => result.generalStats.topEmojis;

  List<HourActivity> get activeHours => result.generalStats.activeHours;
  int get peakHour => result.generalStats.mostActiveHour;
  String get peakHourFormatted => '${peakHour.toString().padLeft(2, '0')}:00';

  // --- Speed & Ignoring Metrics ---
  ResponseTimeStats get responseTimeStats => result.responseTimeStats;

  double get averageResponseTimeMinutes =>
      responseTimeStats.averageResponseTimeMs / 60000;

  String get averageResponseTimeFormatted {
    final mins = averageResponseTimeMinutes;
    if (mins < 1.0) {
      final secs = (responseTimeStats.averageResponseTimeMs / 1000).round();
      return '$secs seg';
    }
    return '${mins.toStringAsFixed(1)} min';
  }

  IgnoringStats get ignoringStats => result.ignoringStats;
  AudioIgnoringStats get audioIgnoringStats => result.audioIgnoringStats;

  List<String> get insights => result.insights;
  String get primaryInsight => result.insights.isNotEmpty
      ? result.insights.first
      : (isDuo
          ? 'Uma dupla com sintonia impecável que transforma qualquer conversa em um evento inesquecível.'
          : 'Um squad vibrante que transforma qualquer assunto em um evento inesquecível.');

  // --- Deterministic Derivations (Zero-Model-Mutation) ---
  String get biggestFloodAuthor => friendStats.biggestFloodName.isNotEmpty
      ? friendStats.biggestFloodName
      : (participants.isNotEmpty ? participants.first : 'O Monólogo');

  int get biggestFloodCount => friendStats.biggestFloodCount > 0
      ? friendStats.biggestFloodCount
      : 8;

  String get fastestReplier => friendStats.fastestReplyName.isNotEmpty
      ? friendStats.fastestReplyName
      : (participants.isNotEmpty ? participants.first : 'O Relâmpago');

  int get totalAudios => audioIgnoringStats.totalAudios;

  /// Estimated audio duration in minutes for the squad / duo.
  int get estimatedAudioMinutes =>
      (totalAudios * 0.45).round().clamp(1, 9999);

  String get podcasterAuthor {
    if (isDuo) {
      if (audioIgnoringStats.ignoredAudios > audioIgnoringStats.wasIgnoredAudios) {
        return friendA;
      } else if (audioIgnoringStats.wasIgnoredAudios > audioIgnoringStats.ignoredAudios) {
        return friendB;
      }
      return friendA;
    }
    return audioIgnoringStats.ignoredAudios >= audioIgnoringStats.wasIgnoredAudios
        ? (participants.isNotEmpty ? participants.first : 'O Podcaster')
        : (participants.length > 1 ? participants[1] : 'O Podcaster');
  }

  /// Estimated prints / screenshots taken by the squad / duo.
  int get estimatedPrints =>
      (result.generalStats.mediaCount * 0.22).round().clamp(1, 999);

  String get printInvestigator {
    if (isDuo) {
      return friendB;
    }
    return participants.length > 1
        ? participants[1]
        : (participants.isNotEmpty ? participants.first : 'Detetive da Dupla');
  }

  /// Circulating forwarded memes and external fuel.
  int get forwardedMemes =>
      (totalMessages * 0.042).round().clamp(5, 500);

  String get memeSupplier => groupDynamics.conversationStarter.isNotEmpty
      ? groupDynamics.conversationStarter
      : (participants.isNotEmpty ? participants.first : 'Central de Memes');

  /// Comic suspense unsent drafts within discussions.
  int get unsentDrafts =>
      (totalMessages * 0.052).round().clamp(3, 400);

  String get vacuumKing {
    if (isDuo) {
      if (ignoringStats.ignoredCount > ignoringStats.wasIgnoredCount) {
        return friendA;
      } else if (ignoringStats.wasIgnoredCount > ignoringStats.ignoredCount) {
        return friendB;
      }
      // Deterministic fallback: the one who replies slower ghosts more!
      return fastestReplier == friendA ? friendB : friendA;
    }
    return ignoringStats.ignoredCount >= ignoringStats.wasIgnoredCount
        ? (participants.isNotEmpty ? participants.first : 'Fantasma')
        : (participants.length > 1 ? participants[1] : 'Fantasma');
  }

  String get vacuumVictim {
    if (isDuo) {
      return vacuumKing == friendA ? friendB : friendA;
    }
    return ignoringStats.wasIgnoredCount >= ignoringStats.ignoredCount
        ? (participants.isNotEmpty ? participants.first : 'O Paciente')
        : (participants.length > 1 ? participants[1] : 'O Paciente');
  }

  /// 3 honorary titles cleanly distributed so both friends in a duo are featured.
  List<(String title, String author, String emoji, String subtitle)> get distributedTitles {
    if (!isDuo) {
      return [
        (
          'Mais Rápido no Gatilho',
          fastestReplier,
          '⚡',
          'Respostas em tempo recorde',
        ),
        (
          'O Podcaster de Áudios',
          podcasterAuthor,
          '🎙️',
          'Áudios com duração de podcast',
        ),
        (
          'Líder de Pautas',
          memeSupplier,
          '🔥',
          'Iniciador oficial das conversas',
        ),
      ];
    }

    final fastest = fastestReplier;
    final other = fastest == friendA ? friendB : friendA;

    final t1 = (
      'Mais Rápido no Gatilho',
      fastest,
      '⚡',
      'Respostas em tempo recorde no chat',
    );

    final podcaster = (podcasterAuthor == other)
        ? other
        : (totalAudios > 0 ? podcasterAuthor : other);

    final t2 = (
      'O Podcaster da Dupla',
      podcaster,
      '🎙️',
      'Áudios longos que viram episódios',
    );

    // Guarantee that if t1 and t2 both went to fastest, t3 MUST go to other!
    final t3Author = (t1.$2 == fastest && t2.$2 == fastest)
        ? other
        : (memeSupplier.isNotEmpty ? memeSupplier : other);

    final t3 = (
      'Líder de Pautas',
      t3Author,
      '🔥',
      'Inicia as conversas e traz os melhores assuntos',
    );

    return [t1, t2, t3];
  }
}
