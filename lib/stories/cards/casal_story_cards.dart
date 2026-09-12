import 'package:flutter/material.dart';
import '../../core/models/casal_stats.dart';
import '../../widgets/stories/casal/casal_c1_cover_slide.dart';
import '../../widgets/stories/casal/casal_c2_total_slide.dart';
import '../../widgets/stories/casal/casal_c3_love_language_slide.dart';
import '../../widgets/stories/casal/casal_c4_compatibility_slide.dart';
import '../../widgets/stories/casal/casal_c5_timeline_slide.dart';
import '../../widgets/stories/casal/casal_c6_top_words_slide.dart';
import '../../widgets/stories/casal/casal_c7_heatmap_slide.dart';
import '../../widgets/stories/casal/casal_c8_emoji_evolution_slide.dart';
import '../../widgets/stories/casal/casal_c9_special_moments_slide.dart';
import '../../widgets/stories/casal/casal_c10_habits_comparison_slide.dart';
import '../../widgets/stories/casal/casal_c11_daily_stats_slide.dart';
import '../../widgets/stories/casal/casal_c12_affection_insight_slide.dart';
import '../../widgets/stories/casal/casal_c13_hidden_interactions_slide.dart';
import '../../widgets/stories/casal/casal_c14_audios_slide.dart';
import '../../widgets/stories/casal/casal_c15_prints_slide.dart';
import '../../widgets/stories/casal/casal_c16_forwarded_slide.dart';
import '../../widgets/stories/casal/casal_c17_typed_unsend_slide.dart';
import '../../widgets/stories/casal/casal_c18_passport_slide.dart';
import '../adapters/casal_story_adapter.dart';

/// Builder that generates all 18 bespoke slides for Casal Mode.
class CasalStoryCards {
  CasalStoryCards._();

  static Widget buildSlide({
    required String slideId,
    required CasalAnalysisResult analysis,
    VoidCallback? onShare,
  }) {
    final adapter = CasalStoryAdapter(analysis);

    switch (slideId) {
      case 'c1':
        return CasalC1CoverSlide(adapter: adapter);
      case 'c2':
        return CasalC2TotalSlide(adapter: adapter);
      case 'c3':
        return CasalC3LoveLanguageSlide(adapter: adapter);
      case 'c4':
        return CasalC4CompatibilitySlide(adapter: adapter);
      case 'c5':
        return CasalC5TimelineSlide(adapter: adapter);
      case 'c6':
        return CasalC6TopWordsSlide(adapter: adapter);
      case 'c7':
        return CasalC7HeatmapSlide(adapter: adapter);
      case 'c8':
        return CasalC8EmojiEvolutionSlide(adapter: adapter);
      case 'c9':
        return CasalC9SpecialMomentsSlide(adapter: adapter);
      case 'c10':
        return CasalC10HabitsComparisonSlide(adapter: adapter);
      case 'c11':
        return CasalC11DailyStatsSlide(adapter: adapter);
      case 'c12':
        return CasalC12AffectionInsightSlide(adapter: adapter);
      case 'c13':
        return CasalC13HiddenInteractionsSlide(adapter: adapter);
      case 'c14':
        return CasalC14AudiosSlide(adapter: adapter);
      case 'c15':
        return CasalC15PrintsSlide(adapter: adapter);
      case 'c16':
        return CasalC16ForwardedSlide(adapter: adapter);
      case 'c17':
        return CasalC17TypedUnsendSlide(adapter: adapter);
      case 'c18':
        return CasalC18PassportSlide(adapter: adapter, onShare: onShare);
      default:
        return CasalC1CoverSlide(adapter: adapter);
    }
  }
}
