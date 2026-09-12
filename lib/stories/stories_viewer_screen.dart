import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/models/general_stats.dart';
import '../export/story_export_service.dart';
import 'cards/story_card_factory.dart';
import 'story_progress_bar.dart';
import 'story_slide.dart';

/// Fullscreen 9:16 interactive Stories Viewer (Spotify Wrapped style).
/// Features:
/// - Segmented progress bars with 5.0s auto-advance
/// - Tap left 30% for previous slide, tap right 70% for next slide
/// - Press and hold to pause progress
/// - Interactive downward vertical drag to dismiss
/// - Top chrome with Close (X) and Share buttons
/// - 100% unlocked (zero paywalls)
class StoriesViewerScreen extends StatefulWidget {
  final ChatAnalysisResult analysis;
  final Duration slideDuration;
  final VoidCallback? onFinished;

  const StoriesViewerScreen({
    super.key,
    required this.analysis,
    this.slideDuration = const Duration(milliseconds: 5000),
    this.onFinished,
  });

  @override
  State<StoriesViewerScreen> createState() => _StoriesViewerScreenState();
}

class _StoriesViewerScreenState extends State<StoriesViewerScreen>
    with SingleTickerProviderStateMixin {
  late List<StorySlide> _slides;
  late final AnimationController _animController;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  int _currentIndex = 0;
  bool _isPaused = false;
  double _dragOffsetY = 0.0;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _slides = StoryCatalog.getSlidesForMode(widget.analysis.mode);

    _animController = AnimationController(
      vsync: this,
      duration: widget.slideDuration,
    )..addStatusListener(_onAnimationStatusChanged);

    _animController.forward();
  }

  @override
  void didUpdateWidget(StoriesViewerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.analysis.mode != oldWidget.analysis.mode) {
      setState(() {
        _slides = StoryCatalog.getSlidesForMode(widget.analysis.mode);
        _currentIndex = 0;
      });
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.stop();
    _animController.removeStatusListener(_onAnimationStatusChanged);
    _animController.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _nextSlide();
    }
  }

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _animController.reset();
      _animController.forward();
    } else {
      // Last slide finished
      _animController.stop();
      if (widget.onFinished != null) {
        widget.onFinished!();
      } else if (mounted) {
        Navigator.of(context).maybePop();
      }
    }
  }

  void _previousSlide() {
    // If progress is greater than 25%, restart current slide; otherwise go back
    if (_animController.value > 0.25 || _currentIndex == 0) {
      _animController.reset();
      _animController.forward();
    } else if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _animController.reset();
      _animController.forward();
    }
  }

  void _pauseTimer() {
    if (!_isPaused) {
      setState(() {
        _isPaused = true;
      });
      _animController.stop();
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      setState(() {
        _isPaused = false;
      });
      _animController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;

    // Tap left 30% vs tap right 70%
    if (tapX / width <= 0.30) {
      _previousSlide();
    } else {
      _nextSlide();
    }
  }

  Future<void> _handleShare() async {
    _pauseTimer();
    setState(() {
      _isExporting = true;
    });

    try {
      await StoryExportService.exportAndShare(
        _repaintBoundaryKey,
        context: context,
        text: 'Confira o nosso WhatsApp Wrapped! 📊✨',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
        _resumeTimer();
      }
    }
  }

  Color _resolveModeAccent(ChatMode mode) {
    switch (mode) {
      case ChatMode.casal:
        return const Color(0xFFE11D48);
      case ChatMode.amigos:
        return const Color(0xFF2563EB);
      case ChatMode.grupo:
        return const Color(0xFF7C3AED);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = _slides.isNotEmpty
        ? _slides[_currentIndex]
        : StorySlide(
            id: 'fallback',
            type: 'header',
            title: 'Retrospectiva',
            mode: widget.analysis.mode,
          );

    final scaleFactor = (1.0 - (_dragOffsetY / 2000.0)).clamp(0.85, 1.0);
    final opacityFactor = (1.0 - (_dragOffsetY / 600.0)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: _handleTapUp,
        onLongPressStart: (_) => _pauseTimer(),
        onLongPressEnd: (_) => _resumeTimer(),
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0 || _dragOffsetY > 0) {
            setState(() {
              _dragOffsetY = (_dragOffsetY + details.delta.dy).clamp(0.0, 600.0);
            });
          }
        },
        onVerticalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0.0;
          if (_dragOffsetY > 120.0 || velocity > 300.0) {
            Navigator.of(context).pop();
          } else {
            // Spring back
            setState(() {
              _dragOffsetY = 0.0;
            });
          }
        },
        child: Transform.translate(
          offset: Offset(0, _dragOffsetY),
          child: Transform.scale(
            scale: scaleFactor,
            child: Opacity(
              opacity: opacityFactor,
              child: Stack(
                children: [
                  // 9:16 Slide Content inside RepaintBoundary for PNG Export
                  Positioned.fill(
                    child: RepaintBoundary(
                      key: _repaintBoundaryKey,
                      child: StoryCardFactory.buildCard(
                        slide: currentSlide,
                        analysis: widget.analysis,
                        onShare: _handleShare,
                      ),
                    ),
                  ),

                  // Top Chrome: Segmented Progress Bar & Action Icons
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Segmented progress
                            AnimatedBuilder(
                              animation: _animController,
                              builder: (context, _) {
                                return StoryProgressBar(
                                  totalSegments: _slides.length,
                                  currentIndex: _currentIndex,
                                  animationProgress: _animController.value,
                                  activeColor: _resolveModeAccent(widget.analysis.mode),
                                  completedColor: const Color(0x591E1B4B),
                                  unfilledColor: const Color(0x1A1E1B4B),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // Controls Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Close button
                                IconButton(
                                  icon: const Icon(
                                    LucideIcons.x,
                                    color: Color(0xFF1E1B4B),
                                    size: 24,
                                  ),
                                  tooltip: 'Fechar',
                                  onPressed: () => Navigator.of(context).pop(),
                                ),

                                // Slide counter & Share action
                                Row(
                                  children: [
                                    Text(
                                      '${_currentIndex + 1}/${_slides.length}',
                                      style: const TextStyle(
                                        color: Color(0xB31E1B4B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFeatures: [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: _isExporting
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF1E1B4B),
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              LucideIcons.share2,
                                              color: Color(0xFF1E1B4B),
                                              size: 22,
                                            ),
                                      tooltip: 'Compartilhar Slide',
                                      onPressed:
                                          _isExporting ? null : _handleShare,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
