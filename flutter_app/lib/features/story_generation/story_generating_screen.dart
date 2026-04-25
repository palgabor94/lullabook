import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/story_repository.dart';

// Messages cycled through during generation (~90s)
const _loadingMessages = [
  'Picking up the quill...',
  'Writing the first chapter...',
  'Painting the opening scene...',
  'Your hero is getting ready...',
  'Mixing the perfect colours...',
  'Adding a sprinkle of magic...',
  'Recording the narrator\'s voice...',
  'Binding the pages together...',
  'Almost ready for bedtime...',
];

class StoryGeneratingScreen extends ConsumerStatefulWidget {
  const StoryGeneratingScreen({
    super.key,
    required this.heroId,
    required this.setup,
  });

  final String heroId;
  final Map<String, dynamic> setup;

  @override
  ConsumerState<StoryGeneratingScreen> createState() =>
      _StoryGeneratingScreenState();
}

class _StoryGeneratingScreenState extends ConsumerState<StoryGeneratingScreen> {
  int _messageIndex = 0;
  Timer? _messageTimer;
  bool _isGenerating = false;
  String? _error;
  late final StreamController<double> _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = StreamController<double>.broadcast();
    _startGeneration();
    _startMessageCycle();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progressController.close();
    super.dispose();
  }

  void _startMessageCycle() {
    _messageTimer = Timer.periodic(const Duration(seconds: 9), (_) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _loadingMessages.length;
      });
    });
  }

  Future<void> _startGeneration() async {
    if (_isGenerating) return;
    _isGenerating = true;

    try {
      final result = await ref
          .read(storyRepositoryProvider)
          .generateStory(
            heroId: widget.heroId,
            setup: widget.setup,
          );

      if (!mounted) return;
      context.go('/story/reader/${result.storyId}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = _friendlyError(e.toString());
        _isGenerating = false;
      });
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('resource-exhausted') || raw.contains('Daily story limit')) {
      return 'Daily story limit reached.\nNew stories available tomorrow at midnight 🌙';
    }
    if (raw.contains('free_tier') || raw.contains('Upgrade')) {
      return 'Your free story has been used.\nUpgrade to create more stories ✨';
    }
    if (raw.contains('content_')) {
      return 'The story content could not be approved.\nPlease try different settings.';
    }
    return 'Story generation failed.\nPlease check your connection and try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: _error != null ? _ErrorBody(error: _error!, onRetry: () {
          setState(() => _error = null);
          _startGeneration();
        }) : _LoadingBody(message: _loadingMessages[_messageIndex]),
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SpinningBook(),
            const SizedBox(height: 48),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            )
                .animate(key: ValueKey(message))
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.1, duration: 600.ms, curve: Curves.easeOut),
            const SizedBox(height: 48),
            _AnimatedDots(),
          ],
        ),
      ),
    );
  }
}

class _SpinningBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text('📖', style: TextStyle(fontSize: 72))
        .animate(onPlay: (c) => c.repeat())
        .rotate(
          begin: -0.03,
          end: 0.03,
          duration: 1800.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .rotate(
          begin: 0.03,
          end: -0.03,
          duration: 1800.ms,
          curve: Curves.easeInOut,
        );
  }
}

class _AnimatedDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .fadeIn(
              delay: Duration(milliseconds: i * 200),
              duration: 500.ms,
            )
            .then()
            .fadeOut(duration: 500.ms);
      }),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error, required this.onRetry});
  final String error;
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
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text('Try again'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/adventure'),
              child: const Text('Back', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}
