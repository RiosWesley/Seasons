import 'package:flutter/material.dart';
import '../../core/models/amigos_stats.dart';
import '../../widgets/stories/amigos/amigos_a1_cover_slide.dart';
import '../../widgets/stories/amigos/amigos_a2_total_impact_slide.dart';
import '../../widgets/stories/amigos/amigos_a3_styles_slide.dart';
import '../../widgets/stories/amigos/amigos_a4_compatibility_slide.dart';
import '../../widgets/stories/amigos/amigos_a5_timeline_slide.dart';
import '../../widgets/stories/amigos/amigos_a6_top_conversations_slide.dart';
import '../../widgets/stories/amigos/amigos_a7_heatmap_slide.dart';
import '../../widgets/stories/amigos/amigos_a8_emoji_culture_slide.dart';
import '../../widgets/stories/amigos/amigos_a9_flood_moments_slide.dart';
import '../../widgets/stories/amigos/amigos_a10_personalities_slide.dart';
import '../../widgets/stories/amigos/amigos_a11_squad_stats_slide.dart';
import '../../widgets/stories/amigos/amigos_a12_insight_slide.dart';
import '../../widgets/stories/amigos/amigos_a13_hidden_interactions_slide.dart';
import '../../widgets/stories/amigos/amigos_a14_audios_slide.dart';
import '../../widgets/stories/amigos/amigos_a15_prints_slide.dart';
import '../../widgets/stories/amigos/amigos_a16_forwarded_slide.dart';
import '../../widgets/stories/amigos/amigos_a17_draft_slide.dart';
import '../../widgets/stories/amigos/amigos_a18_squad_poster_slide.dart';
import '../adapters/amigos_story_adapter.dart';

/// Facade routing all 18 bespoke slides for Amigos Mode (a1..a18).
class AmigosStoryCards {
  AmigosStoryCards._();

  static Widget buildSlide({
    required String slideId,
    required AmigosAnalysisResult analysis,
    VoidCallback? onShare,
  }) {
    final adapter = AmigosStoryAdapter(analysis);

    switch (slideId) {
      case 'a1':
        return AmigosA1CoverSlide(adapter: adapter);
      case 'a2':
        return AmigosA2TotalImpactSlide(adapter: adapter);
      case 'a3':
        return AmigosA3StylesSlide(adapter: adapter);
      case 'a4':
        return AmigosA4CompatibilitySlide(adapter: adapter);
      case 'a5':
        return AmigosA5TimelineSlide(adapter: adapter);
      case 'a6':
        return AmigosA6TopConversationsSlide(adapter: adapter);
      case 'a7':
        return AmigosA7HeatmapSlide(adapter: adapter);
      case 'a8':
        return AmigosA8EmojiCultureSlide(adapter: adapter);
      case 'a9':
        return AmigosA9FloodMomentsSlide(adapter: adapter);
      case 'a10':
        return AmigosA10PersonalitiesSlide(adapter: adapter);
      case 'a11':
        return AmigosA11SquadStatsSlide(adapter: adapter);
      case 'a12':
        return AmigosA12InsightSlide(adapter: adapter);
      case 'a13':
        return AmigosA13HiddenInteractionsSlide(adapter: adapter);
      case 'a14':
        return AmigosA14AudiosSlide(adapter: adapter);
      case 'a15':
        return AmigosA15PrintsSlide(adapter: adapter);
      case 'a16':
        return AmigosA16ForwardedSlide(adapter: adapter);
      case 'a17':
        return AmigosA17DraftSlide(adapter: adapter);
      case 'a18':
        return AmigosA18SquadPosterSlide(
          adapter: adapter,
          onShare: onShare,
        );
      default:
        return AmigosA1CoverSlide(adapter: adapter);
    }
  }
}
