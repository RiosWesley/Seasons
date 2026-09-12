import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/amigos_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import 'amigos_background_variants.dart';
import 'amigos_theme.dart';

class AmigosA13HiddenInteractionsSlide extends StatelessWidget {
  final AmigosStoryAdapter adapter;

  const AmigosA13HiddenInteractionsSlide({super.key, required this.adapter});

  @override
  Widget build(BuildContext context) {
    final king = adapter.vacuumKing;
    final victim = adapter.vacuumVictim;
    final count = adapter.ignoringStats.ignoredCount;

    return StoryCardBase(
      background: AmigosBackgroundVariants.a13HiddenInteractions(),
      isDarkTheme: true,
      backgroundColor: const Color(0xFF0F172A),
      category: 'Interações Ocultas',
      categoryIcon: Icons.timer_off_outlined,
      title: 'Cartaz de\nProcurado',
      subtitle: 'A diplomacia do vácuo no grupo.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Wanted poster container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7), // Aged parchment
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFB45309), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x30000000),
                  offset: Offset(3, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '★ PROCURADO PELO SQUAD ★',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF78350F),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),

                // Avatar / Criminal mugshot frame
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF78350F), width: 1.5),
                  ),
                  child: const Center(
                    child: Text('👻', style: TextStyle(fontSize: 44)),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  king.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF78350F),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Acusado de aplicar $count vácuos demorados (>2h)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFD97706)),
                  ),
                  child: Text(
                    'Vítima mais paciente: $victim',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF78350F),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().scale(duration: 550.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 16),

          // Red stamp
          Transform.rotate(
            angle: -0.06,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AmigosTheme.dangerRed, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'CULPADO / SEM RESPOSTA',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: AmigosTheme.dangerRed,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}
