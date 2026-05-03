import 'dart:async';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/story_repository.dart';
import '../../domain/entities/story.dart';

const _kMessageCount = 6;

class StoryGeneratingScreen extends ConsumerStatefulWidget {
  const StoryGeneratingScreen({
    super.key,
    required this.heroId,
    required this.setup,
    this.heroName,
    this.debugMode = false,
    this.debugImageCount,
  });

  final String heroId;
  final Map<String, dynamic> setup;
  final String? heroName;
  final bool debugMode;
  final int? debugImageCount;

  @override
  ConsumerState<StoryGeneratingScreen> createState() => _StoryGeneratingScreenState();
}

class _StoryGeneratingScreenState extends ConsumerState<StoryGeneratingScreen>
    with SingleTickerProviderStateMixin {
  late final String _storyId;
  int _messageIndex = 0;
  Timer? _messageTimer;
  Timer? _pollTimer;
  String? _error;
  late AnimationController _constellationController;
  StreamSubscription<Story?>? _storySubscription;
  bool _hasNavigated = false;

  // Cover image state — set as soon as coverImageUrl is available
  String? _coverImageUrl;
  String? _coverCaption;

  @override
  void initState() {
    super.initState();
    _storyId = const Uuid().v4();
    _constellationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _startMessageCycle();
    _startGeneration();
    _subscribeToStory();
    _startPolling();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _pollTimer?.cancel();
    _constellationController.dispose();
    _storySubscription?.cancel();
    super.dispose();
  }

  void _startMessageCycle() {
    _messageTimer = Timer.periodic(const Duration(seconds: 9), (_) {
      if (!mounted) return;
      setState(() => _messageIndex = (_messageIndex + 1) % _kMessageCount);
    });
  }

  Future<void> _startGeneration() async {
    final language = ref.read(languageProvider.notifier).storyLanguage;
    try {
      await ref.read(storyRepositoryProvider).generateStory(
            storyId: _storyId,
            heroId: widget.heroId,
            setup: widget.setup,
            language: language,
            debugMode: widget.debugMode,
            debugImageCount: widget.debugMode ? (widget.debugImageCount ?? 0) : null,
          );
      _navigateToReader();
    } catch (e) {
      // Before showing an error, check Firestore — the story might be complete
      // even if the callable threw (e.g. non-fatal post-generation failure).
      try {
        final story = await ref.read(storyRepositoryProvider).get(_storyId);
        if (story?.status == StoryStatus.complete) {
          _navigateToReader();
          return;
        }
      } catch (_) {}
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = _friendlyError(e.toString(), l10n));
    }
  }

  // Belt-and-suspenders: poll Firestore every 30 s in case the stream misses an update.
  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (_hasNavigated || !mounted) {
        _pollTimer?.cancel();
        return;
      }
      try {
        final story = await ref.read(storyRepositoryProvider).get(_storyId);
        if (story == null || !mounted) return;
        if (_coverImageUrl == null && story.coverImageUrl.isNotEmpty) {
          setState(() {
            _coverImageUrl = story.coverImageUrl;
            _coverCaption = story.coverCaption.isNotEmpty ? story.coverCaption : null;
          });
        }
        if (story.status == StoryStatus.complete) {
          _pollTimer?.cancel();
          _navigateToReader();
        }
      } catch (_) {}
    });
  }

  void _navigateToReader() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    context.go('/story/reader/$_storyId');
  }

  // Subscribe to Firestore doc for real-time progress updates
  void _subscribeToStory() {
    _storySubscription =
        ref.read(storyRepositoryProvider).watch(_storyId).listen(
      (story) {
        if (!mounted || story == null) return;

        // Show cover image as soon as it's available (any status)
        if (_coverImageUrl == null && story.coverImageUrl.isNotEmpty) {
          setState(() {
            _coverImageUrl = story.coverImageUrl;
            _coverCaption = story.coverCaption.isNotEmpty ? story.coverCaption : null;
          });
        }

        if (story.status == StoryStatus.complete) {
          _navigateToReader();
        }
      },
      onError: (_) {
        // Stream error: fallback to callable completion for navigation
      },
    );
  }

  String _friendlyError(String raw, AppLocalizations l10n) {
    if (raw.contains('resource-exhausted') || raw.contains('Daily story limit')) {
      return l10n.generationErrorDailyLimit;
    }
    if (raw.contains('free_tier') || raw.contains('Upgrade')) {
      return l10n.generationErrorFreeTier;
    }
    if (raw.contains('content_')) {
      return l10n.generationErrorContent;
    }
    return l10n.generationErrorGeneric;
  }

  String _currentMessage(AppLocalizations l10n) {
    final name = widget.heroName ?? 'your hero';
    final messages = [
      l10n.generationLoadingDrawing(name),
      l10n.generationLoadingWriting,
      l10n.generationLoadingPainting,
      l10n.generationLoadingMixing,
      l10n.generationLoadingMagic,
      l10n.generationLoadingAlmost,
    ];
    return messages[_messageIndex % messages.length];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: _error != null
            ? _ErrorBody(
                error: _error!,
                heroId: widget.heroId,
                retryLabel: l10n.generationRetry,
                backLabel: l10n.generationBack,
                onRetry: () {
                  setState(() => _error = null);
                  _startGeneration();
                },
              )
            : _coverImageUrl != null
                ? _CoverReadyBody(
                    coverImageUrl: _coverImageUrl!,
                    coverCaption: _coverCaption,
                    heroName: widget.heroName,
                  )
                : _LoadingBody(
                    message: _currentMessage(l10n),
                    cancelLabel: l10n.generationCancel,
                    constellationController: _constellationController,
                    onCancel: () => context.pop(),
                  ),
      ),
    );
  }
}

// ── Cover-ready body (shown ~40s in, while pages generate) ────────────────────

class _CoverReadyBody extends StatelessWidget {
  const _CoverReadyBody({
    required this.coverImageUrl,
    required this.coverCaption,
    required this.heroName,
  });

  final String coverImageUrl;
  final String? coverCaption;
  final String? heroName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Drifting gold particles (same as loading)
        ...List.generate(8, (i) => _GoldParticle(seed: i + 20)),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cover image with rounded corners and glow — natural 3:4 aspect ratio
                LayoutBuilder(
                  builder: (_, constraints) {
                    final imgWidth = constraints.maxWidth.clamp(0.0, 280.0);
                    return Container(
                      width: imgWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold500.withAlpha(60),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: CachedNetworkImage(
                            imageUrl: coverImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: AppColors.bgElevated,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.gold500,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.92, 0.92), duration: 800.ms, curve: Curves.easeOut),

                const SizedBox(height: 28),

                if (coverCaption != null) ...[
                  Text(
                    coverCaption!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.1, duration: 600.ms, curve: Curves.easeOut),
                  const SizedBox(height: 20),
                ],

                // Subtle progress indicator
                SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.gold500.withAlpha(30),
                    valueColor: const AlwaysStoppedAnimation(AppColors.gold500),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Loading body ──────────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({
    required this.message,
    required this.cancelLabel,
    required this.constellationController,
    required this.onCancel,
  });

  final String message;
  final String cancelLabel;
  final AnimationController constellationController;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Drifting gold particles
        ...List.generate(12, (i) => _GoldParticle(seed: i)),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Constellation animation
              SizedBox(
                width: 200,
                height: 200,
                child: AnimatedBuilder(
                  animation: constellationController,
                  builder: (_, __) => CustomPaint(
                    painter: _ConstellationPainter(constellationController.value),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Rotating Fraunces message §4.11
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              )
                  .animate(key: ValueKey(message))
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.1, duration: 600.ms, curve: Curves.easeOut),

              const SizedBox(height: 80),
            ],
          ),
        ),

        // Cancel button §4.11
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: TextButton(
              onPressed: onCancel,
              child: Text(
                cancelLabel,
                style: TextStyle(color: AppColors.textTertiary.withAlpha(230), fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Constellation painter ─────────────────────────────────────────────────────

class _ConstellationPainter extends CustomPainter {
  const _ConstellationPainter(this.t);
  final double t;

  static const _stars = [
    Offset(100, 30),
    Offset(160, 80),
    Offset(140, 150),
    Offset(70, 170),
    Offset(30, 110),
    Offset(60, 50),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final linePaint = Paint()
      ..color = AppColors.gold500.withAlpha(80)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.gold500
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppColors.gold500.withAlpha(40)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // How many connections to show (reveal over time)
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 0],
    ];
    final visibleLines = (t * connections.length).ceil().clamp(0, connections.length);

    for (int i = 0; i < visibleLines; i++) {
      final a = _toCanvas(_stars[connections[i][0]], cx, cy);
      final b = _toCanvas(_stars[connections[i][1]], cx, cy);

      // Partial draw for last line
      if (i == visibleLines - 1) {
        final frac = (t * connections.length) - (visibleLines - 1);
        final mid = Offset(a.dx + (b.dx - a.dx) * frac, a.dy + (b.dy - a.dy) * frac);
        canvas.drawLine(a, mid, linePaint);
      } else {
        canvas.drawLine(a, b, linePaint);
      }
    }

    // Draw stars
    for (int i = 0; i < _stars.length; i++) {
      final pos = _toCanvas(_stars[i], cx, cy);
      final appear = (i / _stars.length);
      if (t < appear) continue;

      final alpha = ((t - appear) / 0.15).clamp(0.0, 1.0);
      final pulse = 1.0 + 0.15 * math.sin(t * math.pi * 4 + i);

      canvas.drawCircle(pos, 6 * pulse, glowPaint..color = AppColors.gold500.withAlpha((40 * alpha).round()));
      canvas.drawCircle(pos, 3 * pulse, dotPaint..color = AppColors.gold500.withAlpha((255 * alpha).round()));
    }
  }

  Offset _toCanvas(Offset star, double cx, double cy) {
    return Offset(star.dx - 100 + cx, star.dy - 100 + cy);
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter old) => old.t != t;
}

// ── Drifting gold particle ────────────────────────────────────────────────────

class _GoldParticle extends StatelessWidget {
  const _GoldParticle({required this.seed});
  final int seed;

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(seed * 13);
    final left = rng.nextDouble() * MediaQuery.of(context).size.width;
    final top  = rng.nextDouble() * MediaQuery.of(context).size.height;
    final size = 2.0 + rng.nextDouble() * 3;

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.gold300,
          shape: BoxShape.circle,
        ),
      )
          .animate(
            onPlay: (c) => c.repeat(reverse: true),
            delay: Duration(milliseconds: rng.nextInt(3000)),
          )
          .fadeIn(duration: 2000.ms)
          .then()
          .moveY(begin: 0, end: -30, duration: 6000.ms, curve: Curves.easeInOut),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.error,
    required this.heroId,
    required this.retryLabel,
    required this.backLabel,
    required this.onRetry,
  });
  final String error;
  final String heroId;
  final String retryLabel;
  final String backLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌙', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: onRetry,
              child: Text(retryLabel),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/adventure', extra: {'heroId': heroId}),
              child: Text(backLabel, style: const TextStyle(color: AppColors.textTertiary)),
            ),
          ],
        ),
      ),
    );
  }
}
