import 'general_stats.dart';

/// Breakdown of messages into romantic love languages.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoveLanguageBreakdown &&
          runtimeType == other.runtimeType &&
          hearts == other.hearts &&
          romanticWords == other.romanticWords &&
          memes == other.memes &&
          directTexts == other.directTexts;

  @override
  int get hashCode => Object.hash(hearts, romanticWords, memes, directTexts);

  @override
  String toString() =>
      'LoveLanguageBreakdown(hearts: $hearts, romantic: $romanticWords, memes: $memes, direct: $directTexts)';
}

/// Emotional and communication compatibility index (0..100).
class CompatibilityScore {
  final int score;
  final String description;

  const CompatibilityScore({
    required this.score,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompatibilityScore &&
          runtimeType == other.runtimeType &&
          score == other.score &&
          description == other.description;

  @override
  int get hashCode => Object.hash(score, description);

  @override
  String toString() => 'CompatibilityScore(score: $score, desc: "$description")';
}

/// Participant-specific communication footprint.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantStats &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          topEmoji == other.topEmoji &&
          topWord == other.topWord &&
          activeHour == other.activeHour &&
          activeDay == other.activeDay;

  @override
  int get hashCode => Object.hash(name, topEmoji, topWord, activeHour, activeDay);

  @override
  String toString() =>
      'ParticipantStats($name, topEmoji: $topEmoji, topWord: $topWord, hour: $activeHour, day: $activeDay)';
}

/// Ghosting ("vácuo") statistics for message delays between 2h and 24h.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IgnoringStats &&
          runtimeType == other.runtimeType &&
          ignoredCount == other.ignoredCount &&
          wasIgnoredCount == other.wasIgnoredCount &&
          longestIgnoredTimeMs == other.longestIgnoredTimeMs &&
          mostIgnoredDay == other.mostIgnoredDay;

  @override
  int get hashCode => Object.hash(
        ignoredCount,
        wasIgnoredCount,
        longestIgnoredTimeMs,
        mostIgnoredDay,
      );

  @override
  String toString() =>
      'IgnoringStats(ignored: $ignoredCount, wasIgnored: $wasIgnoredCount, longest: ${longestIgnoredTimeMs}ms, day: $mostIgnoredDay)';
}

/// Audio/media ignoring statistics for delays > 1h.
class AudioIgnoringStats {
  final int ignoredAudios;
  final int wasIgnoredAudios;
  final int totalAudios;

  const AudioIgnoringStats({
    required this.ignoredAudios,
    required this.wasIgnoredAudios,
    required this.totalAudios,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioIgnoringStats &&
          runtimeType == other.runtimeType &&
          ignoredAudios == other.ignoredAudios &&
          wasIgnoredAudios == other.wasIgnoredAudios &&
          totalAudios == other.totalAudios;

  @override
  int get hashCode => Object.hash(ignoredAudios, wasIgnoredAudios, totalAudios);

  @override
  String toString() =>
      'AudioIgnoringStats(ignored: $ignoredAudios, wasIgnored: $wasIgnoredAudios, total: $totalAudios)';
}

/// Response turnaround speed metrics across participants.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseTimeStats &&
          runtimeType == other.runtimeType &&
          averageResponseTimeMs == other.averageResponseTimeMs &&
          fastestResponseMs == other.fastestResponseMs &&
          slowestResponseMs == other.slowestResponseMs &&
          responseCount == other.responseCount;

  @override
  int get hashCode => Object.hash(
        averageResponseTimeMs,
        fastestResponseMs,
        slowestResponseMs,
        responseCount,
      );

  @override
  String toString() =>
      'ResponseTimeStats(avg: ${averageResponseTimeMs}ms, fastest: ${fastestResponseMs}ms, slowest: ${slowestResponseMs}ms, count: $responseCount)';
}

/// Aggregate statistical container for Casal Mode.
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CasalStats &&
          runtimeType == other.runtimeType &&
          general == other.general &&
          loveLanguage == other.loveLanguage &&
          compatibility == other.compatibility &&
          ignoringStats == other.ignoringStats &&
          audioIgnoringStats == other.audioIgnoringStats &&
          responseTimeStats == other.responseTimeStats;

  @override
  int get hashCode => Object.hash(
        general,
        loveLanguage,
        compatibility,
        ignoringStats,
        audioIgnoringStats,
        responseTimeStats,
      );

  @override
  String toString() =>
      'CasalStats(compatibility: ${compatibility.score}%, general: $general)';
}

/// ChatAnalysisResult implementation for Casal mode.
class CasalAnalysisResult implements ChatAnalysisResult {
  final CasalStats stats;

  const CasalAnalysisResult(this.stats);

  @override
  GeneralStats get generalStats => stats.general;

  @override
  ChatMode get mode => ChatMode.casal;

  LoveLanguageBreakdown get loveLanguage => stats.loveLanguage;
  CompatibilityScore get compatibility => stats.compatibility;
  List<ParticipantStats> get participantStats => stats.participantStats;
  List<String> get insights => stats.insights;
  IgnoringStats get ignoringStats => stats.ignoringStats;
  AudioIgnoringStats get audioIgnoringStats => stats.audioIgnoringStats;
  ResponseTimeStats get responseTimeStats => stats.responseTimeStats;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CasalAnalysisResult &&
          runtimeType == other.runtimeType &&
          stats == other.stats;

  @override
  int get hashCode => stats.hashCode;

  @override
  String toString() => 'CasalAnalysisResult($stats)';
}
