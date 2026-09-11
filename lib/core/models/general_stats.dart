/// Mode discriminator identifying the analysis tier.
enum ChatMode { casal, amigos, grupo }

/// Monthly message volume bucket.
class TimelineData {
  final String month;
  final int year;
  final int count;

  const TimelineData({
    required this.month,
    required this.year,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineData &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          year == other.year &&
          count == other.count;

  @override
  int get hashCode => Object.hash(month, year, count);

  @override
  String toString() => 'TimelineData($month/$year: $count)';
}

/// Activity count for a specific hour of the day (0..23).
class HourActivity {
  final int hour;
  final int count;

  const HourActivity({
    required this.hour,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourActivity &&
          runtimeType == other.runtimeType &&
          hour == other.hour &&
          count == other.count;

  @override
  int get hashCode => Object.hash(hour, count);

  @override
  String toString() => 'HourActivity(${hour}h: $count)';
}

/// Activity count for a day of the week ('Segunda'..'Domingo').
class DayActivity {
  final String day;
  final int count;

  const DayActivity({
    required this.day,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayActivity &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          count == other.count;

  @override
  int get hashCode => Object.hash(day, count);

  @override
  String toString() => 'DayActivity($day: $count)';
}

/// Frequency count for a specific emoji.
class EmojiCount {
  final String emoji;
  final int count;

  const EmojiCount({
    required this.emoji,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmojiCount &&
          runtimeType == other.runtimeType &&
          emoji == other.emoji &&
          count == other.count;

  @override
  int get hashCode => Object.hash(emoji, count);

  @override
  String toString() => 'EmojiCount($emoji: $count)';
}

/// Frequency count for a specific word.
class WordCount {
  final String word;
  final int count;

  const WordCount({
    required this.word,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordCount &&
          runtimeType == other.runtimeType &&
          word == other.word &&
          count == other.count;

  @override
  int get hashCode => Object.hash(word, count);

  @override
  String toString() => 'WordCount($word: $count)';
}

/// Abstract contract for all mode analysis results.
abstract class ChatAnalysisResult {
  GeneralStats get generalStats;
  ChatMode get mode;
}

/// Universal baseline statistics computed across all chat modes.
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
  final int mediaCount;
  final Map<String, int> participantCounts;

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
    this.mediaCount = 0,
    this.participantCounts = const {},
  });

  factory GeneralStats.empty() {
    final now = DateTime.now();
    return GeneralStats(
      totalMessages: 0,
      participants: const [],
      startDate: now,
      endDate: now,
      timeline: const [],
      activeHours: const [],
      activeDays: const [],
      topEmojis: const [],
      topWords: const [],
      averageResponseTimeMs: 0.0,
      mediaCount: 0,
      participantCounts: const {},
    );
  }

  /// Convenience getters for UI presentation
  String get mostActiveDayOfWeek =>
      activeDays.isNotEmpty ? activeDays.first.day : 'Segunda';

  int get mostActiveHour =>
      activeHours.isNotEmpty ? activeHours.first.hour : 12;

  List<HourActivity> get hourlyDistribution => activeHours;

  List<DayActivity> get weekdayDistribution => activeDays;

  List<TimelineData> get monthlyTimeline => timeline;

  List<EmojiCount> get emojisSummary => topEmojis;

  int get activeDaysCount => activeDays.where((d) => d.count > 0).length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralStats &&
          runtimeType == other.runtimeType &&
          totalMessages == other.totalMessages &&
          averageResponseTimeMs == other.averageResponseTimeMs &&
          mediaCount == other.mediaCount &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          participants.length == other.participants.length &&
          timeline.length == other.timeline.length &&
          activeHours.length == other.activeHours.length &&
          activeDays.length == other.activeDays.length &&
          topEmojis.length == other.topEmojis.length &&
          topWords.length == other.topWords.length;

  @override
  int get hashCode => Object.hash(
        totalMessages,
        startDate,
        endDate,
        averageResponseTimeMs,
        mediaCount,
        participants.length,
      );

  @override
  String toString() =>
      'GeneralStats(totalMessages: $totalMessages, participants: $participants, avgResponse: ${averageResponseTimeMs}ms)';
}
