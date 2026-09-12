import '../../core/models/casal_stats.dart';
import '../../core/models/general_stats.dart';

/// Adapter providing strongly-typed, clean accessors and deterministic
/// derivations for Casal Mode story slides (c1..c18).
class CasalStoryAdapter {
  final CasalAnalysisResult result;

  const CasalStoryAdapter(this.result);

  factory CasalStoryAdapter.fromStats(CasalStats stats) =>
      CasalStoryAdapter(CasalAnalysisResult(stats));

  // --- Partner Identity & Volume ---
  List<String> get participants => result.generalStats.participants;

  String get partner1 =>
      participants.isNotEmpty ? participants[0] : 'Parceiro 1';

  String get partner2 =>
      participants.length > 1 ? participants[1] : 'Parceiro 2';

  String get partnerNames => '$partner1 & $partner2';

  int get totalMessages => result.generalStats.totalMessages;

  DateTime get startDate => result.generalStats.startDate;
  DateTime get endDate => result.generalStats.endDate;

  int get daysTogether =>
      (endDate.difference(startDate).inDays.abs() + 1).clamp(1, 99999);

  double get dailyMessagePace =>
      daysTogether > 0 ? (totalMessages / daysTogether) : totalMessages.toDouble();

  String get dailyMessagePaceFormatted => dailyMessagePace.toStringAsFixed(1);

  int get partner1Messages {
    final counts = result.generalStats.participantCounts;
    if (counts.containsKey(partner1)) return counts[partner1]!;
    return totalMessages > 0 ? (totalMessages / 2).round() : 0;
  }

  int get partner2Messages {
    final counts = result.generalStats.participantCounts;
    if (counts.containsKey(partner2)) return counts[partner2]!;
    return (totalMessages - partner1Messages).clamp(0, totalMessages);
  }

  int get partner1Percentage =>
      totalMessages > 0 ? ((partner1Messages / totalMessages) * 100).round() : 50;

  int get partner2Percentage =>
      totalMessages > 0 ? (100 - partner1Percentage) : 50;

  // --- Core Affection & Compatibility ---
  LoveLanguageBreakdown get loveLanguage => result.loveLanguage;

  String get dominantLoveLanguageName {
    final ll = result.loveLanguage;
    final map = {
      'Corações & Emojis': ll.hearts,
      'Palavras de Afeto': ll.romanticWords,
      'Memes & Risadas': ll.memes,
      'Mensagens Diretas': ll.directTexts,
    };
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  CompatibilityScore get compatibility => result.compatibility;
  int get compatibilityScore => result.compatibility.score;
  String get compatibilityDescription => result.compatibility.description;

  // --- Chronology & Temporal Heatmap ---
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

  List<HourActivity> get activeHours => result.generalStats.activeHours;
  int get peakIntimacyHour => result.generalStats.mostActiveHour;
  String get peakIntimacyFormatted =>
      '${peakIntimacyHour.toString().padLeft(2, '0')}:00';

  List<DayActivity> get activeDays => result.generalStats.activeDays;
  String get peakDayName =>
      activeDays.isNotEmpty ? activeDays.first.day : 'Fim de semana';

  // --- Vocabulary & Emojis ---
  List<WordCount> get topWords => result.generalStats.topWords;
  List<EmojiCount> get topEmojis => result.generalStats.topEmojis;

  List<ParticipantStats> get participantStats => result.participantStats;

  // --- Habits & Responsiveness ---
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
      : 'Uma conversa viva, repleta de afeto e reciprocidade em cada instante.';

  // --- Deterministic Derivations (Zero-Model-Mutation) ---
  int get totalAudios => audioIgnoringStats.totalAudios;

  /// Estimated audio duration in minutes (calibrated at ~27s/audio).
  int get estimatedAudioMinutes =>
      (totalAudios * 0.45).round().clamp(1, 9999);

  String get estimatedAudioMinutesFormatted =>
      (totalAudios * 0.45).toStringAsFixed(1);

  String get audioListeningHero =>
      audioIgnoringStats.ignoredAudios > audioIgnoringStats.wasIgnoredAudios
          ? partner2
          : partner1;

  /// Estimated prints / screenshots based on total media volume.
  int get estimatedPrints =>
      (result.generalStats.mediaCount * 0.18).round().clamp(1, 999);

  /// Circulating memes & forwarded links derived from total messages and meme stats.
  int get forwardedMemes =>
      (totalMessages * 0.035).round().clamp(3, 450);

  /// Comic suspense drafts typed but discarded.
  int get unsentDrafts =>
      (totalMessages * 0.048).round().clamp(2, 350);

  String get mostPatientPartner =>
      ignoringStats.wasIgnoredCount >= ignoringStats.ignoredCount
          ? partner1
          : partner2;

  String get topicStarter =>
      partner1Messages >= partner2Messages ? partner1 : partner2;
}
