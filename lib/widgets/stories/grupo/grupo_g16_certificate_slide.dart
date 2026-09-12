import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../stories/adapters/grupo_story_adapter.dart';
import '../../../stories/cards/story_card_base.dart';
import '../../../theme/squircle_border.dart';
import '../shared/editorial_stamp.dart';
import '../shared/story_share_action.dart';
import 'grupo_theme.dart';

/// Slide g16: Conclusão & Certificado Oficial da Comunidade (com bordas guilloche e botão de compartilhamento)
class GrupoG16CertificateSlide extends StatelessWidget {
  final GrupoStoryAdapter adapter;
  final VoidCallback? onShare;

  const GrupoG16CertificateSlide({
    super.key,
    required this.adapter,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final champ = adapter.champion?.name ?? 'Tribuno Principal';
    final topTopic = adapter.topics.isNotEmpty ? adapter.topics.first.topic : 'Debates Gerais';

    return StoryCardBase(
      category: 'Registro Oficial',
      categoryIcon: Icons.workspace_premium_rounded,
      title: 'Certificado de\nConvivência',
      subtitle: 'Chancelado solenemente pelo Conselho Seasons.',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Certificate Diploma Card with Guilloche-style double border
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: ShapeDecoration(
              color: GrupoTheme.cardSurfaceWhite,
              shape: SquircleBorder.radius(
                20,
                side: const BorderSide(color: GrupoTheme.accentPrimary, width: 2.0),
              ),
              shadows: [
                BoxShadow(
                  color: GrupoTheme.accentPrimary.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Header of the Diploma
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TEMPORADA ANUAL',
                      style: GrupoTheme.kicker.copyWith(
                        color: GrupoTheme.accentPrimary,
                        fontSize: 8,
                      ),
                    ),
                    const EditorialStamp.periodicalMedal(
                      size: 38,
                      label: 'SEASONS',
                    ),
                    Text(
                      'REGISTRO PÚBLICO',
                      style: GrupoTheme.kicker.copyWith(
                        color: GrupoTheme.accentPrimary,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const Text(
                  'CERTIFICADO DE CONVIVÊNCIA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: GrupoTheme.inkPrimary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Este diploma atesta a convivência, os debates calorosos e a união inabalável desta comunidade.',
                  textAlign: TextAlign.center,
                  style: GrupoTheme.bodySerif.copyWith(fontSize: 11),
                ),

                const SizedBox(height: 12),
                Container(height: 1, color: GrupoTheme.hairlineBorder),
                const SizedBox(height: 12),

                // 4-Pillar Census Grid
                Row(
                  children: [
                    _pillarItem('POPULAÇÃO ATIVA', '${adapter.memberCount} membros', Icons.groups_rounded),
                    const SizedBox(width: 8),
                    _pillarItem('MEMÓRIA ESCRITA', '${adapter.totalMessages} msgs', Icons.menu_book_rounded),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _pillarItem('TRIBUNO DO ANO', champ, Icons.military_tech_rounded),
                    const SizedBox(width: 8),
                    _pillarItem('PAUTA DE DESTAQUE', topTopic, Icons.gavel_rounded),
                  ],
                ),

                const SizedBox(height: 12),
                Container(height: 1, color: GrupoTheme.hairlineBorder),
                const SizedBox(height: 8),

                Text(
                  'Chancelado pelo Conselho Editorial Seasons • Registro Permanente',
                  style: GrupoTheme.captionItalic.copyWith(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: 20),

          // Share Action Button with Icons.share_rounded
          StoryShareAction(
            onShare: onShare ?? () {},
            label: 'COMPARTILHAR NO GRUPO',
            backgroundColor: GrupoTheme.accentPrimary,
            foregroundColor: Colors.white,
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _pillarItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: ShapeDecoration(
          color: const Color(0xFFF8FAFC),
          shape: SquircleBorder.radius(
            10,
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: GrupoTheme.accentPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GrupoTheme.kicker.copyWith(fontSize: 7),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: GrupoTheme.inkPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
