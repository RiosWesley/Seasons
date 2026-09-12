import 'package:flutter/material.dart';

/// Minimal, high-craft physical footer for the 9:16 Seasons Stories experience.
/// Completely eliminates legacy "CHAT WRAPPED" and "100% OFFLINE" badges,
/// proudly displaying the lowercase serif "seasons" brand signature with an edition tag.
class SeasonsStoryFooter extends StatelessWidget {
  final String editionTag;
  final Color inkPrimary;
  final Color inkSecondary;

  const SeasonsStoryFooter({
    super.key,
    this.editionTag = 'archive edition',
    this.inkPrimary = const Color(0xFF1E1B4B),
    this.inkSecondary = const Color(0xFF475569),
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Rodapé Seasons: $editionTag',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lowercase serif brand signature
            Text(
              'seasons',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.3,
                color: inkPrimary.withValues(alpha: 0.65),
              ),
            ),

            // Mode edition tag
            if (editionTag.isNotEmpty)
              Text(
                editionTag.toLowerCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: inkSecondary.withValues(alpha: 0.55),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
