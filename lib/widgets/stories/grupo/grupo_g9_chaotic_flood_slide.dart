import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import 'grupo_theme.dart';

/// Slide g9: Flood Moments (Edição extraordinária do minuto mais caótico da história do chat)
class GrupoG9ChaoticFloodSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;

  const GrupoG9ChaoticFloodSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final mostActive = adapter.groupDynamics.mostActive;
    final estimatedFloodRush = (adapter.totalMessages * 0.015).round().clamp(15, 120);

    return StoryCardBase(
      category: 'Plantão Urgente',
      categoryIcon: Icons.bolt_rounded,
      title: 'Edição\nExtraordinária',
      subtitle: 'O minuto mais frenético e caótico na história do chat.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Extra banner headline
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: GrupoTheme.inkPrimary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PLANTÃO DE NOTÍCIAS • EDIÇÃO EXTRAORDINÁRIA',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ).animate().fadeIn(duration: 350.ms),

          const SizedBox(height: 20),

          // Main Broadsheet Newspaper Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                18,
                side: const BorderSide(color: GrupoTheme.hairlineBorder, width: 1.2),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Warning icon badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFEF2F2),
                    shape: SquircleBorder.radius(14),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFDC2626),
                    size: 32,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  'COLAPSO TEMPORÁRIO',
                  style: GrupoTheme.kicker.copyWith(
                    color: const Color(0xFFDC2626),
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '~$estimatedFloodRush',
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: GrupoTheme.inkPrimary,
                    height: 1.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'mensagens em rajada contínua',
                  style: GrupoTheme.captionItalic,
                ),

                const SizedBox(height: 14),
                Container(height: 1, color: GrupoTheme.hairlineBorder),
                const SizedBox(height: 12),

                // Protagonist
                Text(
                  'PROTAGONISTA DA COMOÇÃO',
                  style: GrupoTheme.kicker.copyWith(fontSize: 8),
                ),
                const SizedBox(height: 2),
                Text(
                  mostActive,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: GrupoTheme.accentPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fontes oficiais atestam que as notificações vibraram ininterruptamente até a poeira baixar.',
                  textAlign: TextAlign.center,
                  style: GrupoTheme.bodySerif.copyWith(fontSize: 12),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 450.ms).slideY(begin: 0.08, end: 0),
        ],
      ),
    );
  }
}
