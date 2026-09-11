import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/squircle_border.dart';
import '../theme/swiss_colors.dart';
import '../theme/swiss_typography.dart';

enum PipelineStage {
  idle(
    id: 'idle',
    label: 'Aguardando Arquivo',
    description: 'Selecione um arquivo .txt ou .zip exportado do WhatsApp',
    progress: 0.0,
  ),
  decompressing(
    id: 'decompressing',
    label: 'Descompactando',
    description: 'Localizando histórico de conversa no arquivo ZIP...',
    progress: 0.25,
  ),
  parsing(
    id: 'parsing',
    label: 'Processando Linhas',
    description: 'Formatando cronologia e sanitizando mensagens...',
    progress: 0.55,
  ),
  analyzing(
    id: 'analyzing',
    label: 'Calculando Métricas',
    description: 'Analisando afinidade, love language e estatísticas...',
    progress: 0.85,
  ),
  complete(
    id: 'complete',
    label: 'Concluído',
    description: 'Retrospectiva pronta com privacidade 100% offline!',
    progress: 1.0,
  ),
  error(
    id: 'error',
    label: 'Erro no Processamento',
    description: 'Não foi possível ler o arquivo. Verifique o formato exportado.',
    progress: 0.0,
  );

  final String id;
  final String label;
  final String description;
  final double progress;

  const PipelineStage({
    required this.id,
    required this.label,
    required this.description,
    required this.progress,
  });
}

/// Architectural multistage pipeline progress indicator with smooth animation,
/// vector iconography (zero emojis), and clear status feedback.
class StageProgressIndicator extends StatelessWidget {
  final PipelineStage stage;
  final String? customMessage;
  final double? customProgress;

  const StageProgressIndicator({
    super.key,
    required this.stage,
    this.customMessage,
    this.customProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isError = stage == PipelineStage.error;
    final progressVal = (customProgress ?? stage.progress).clamp(0.0, 1.0);

    const stageSteps = [
      (PipelineStage.decompressing, LucideIcons.archive, 'Extrair'),
      (PipelineStage.parsing, LucideIcons.fileText, 'Ler'),
      (PipelineStage.analyzing, LucideIcons.chartBar, 'Analisar'),
      (PipelineStage.complete, LucideIcons.checkCircle, 'Pronto'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: isDark ? SwissColors.darkSurfaceCard : SwissColors.lightSurfaceCard,
        shape: SquircleBorder.card(
          side: BorderSide(
            color: isError
                ? SwissColors.danger
                : (isDark ? SwissColors.darkBorder : SwissColors.lightBorder),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isError
                    ? LucideIcons.alertCircle
                    : (stage == PipelineStage.complete
                        ? LucideIcons.checkCircle
                        : LucideIcons.refreshCw),
                size: 20,
                color: isError
                    ? SwissColors.danger
                    : (stage == PipelineStage.complete
                        ? SwissColors.emeraldPrimary
                        : SwissColors.emeraldSecondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  stage.label,
                  style: SwissTypography.titleMedium.copyWith(
                    color: isError
                        ? SwissColors.danger
                        : (isDark ? SwissColors.darkTextPrimary : SwissColors.lightTextPrimary),
                  ),
                ),
              ),
              Text(
                '${(progressVal * 100).toInt()}%',
                style: SwissTypography.labelSmall.copyWith(
                  color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
                  fontFeatures: SwissTypography.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            customMessage ?? stage.description,
            style: SwissTypography.bodyMedium.copyWith(
              color: isDark ? SwissColors.darkTextSecondary : SwissColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progressVal),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: isDark
                      ? SwissColors.darkSurfaceSubdued
                      : SwissColors.lightSurfaceSubdued,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isError ? SwissColors.danger : SwissColors.emeraldPrimary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Step indicators row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stageSteps.map((step) {
              final stepStage = step.$1;
              final icon = step.$2;
              final label = step.$3;

              final isCompleted = stage.progress >= stepStage.progress && !isError;
              final isCurrent = stage == stepStage;

              Color iconColor;
              if (isCompleted || isCurrent) {
                iconColor = SwissColors.emeraldPrimary;
              } else {
                iconColor = isDark ? SwissColors.darkTextMuted : SwissColors.lightTextMuted;
              }

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: iconColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: SwissTypography.labelSmall.copyWith(
                      color: iconColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
