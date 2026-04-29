import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/story_repository.dart';
import '../../domain/entities/story.dart';

class StoryReaderScreen extends ConsumerStatefulWidget {
  const StoryReaderScreen({super.key, required this.storyId});
  final String storyId;

  @override
  ConsumerState<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends ConsumerState<StoryReaderScreen> {
  final PageController _pageController = PageController();
  final AudioPlayer _player = AudioPlayer();
  int _currentPage = 0;
  bool _isPlaying = false;
  bool _controlsVisible = false;
  bool _hasMarkedRead = false;
  Timer? _controlsTimer;

  @override
  void dispose() {
    _pageController.dispose();
    _player.dispose();
    _controlsTimer?.cancel();
    super.dispose();
  }

  void _showControls() {
    setState(() => _controlsVisible = true);
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  Future<void> _playPage(StoryPage page) async {
    if (page.audioUrl.isEmpty) return;
    try {
      await _player.stop();
      await _player.setUrl(page.audioUrl);
      await _player.play();
      setState(() => _isPlaying = true);
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed && mounted) {
          setState(() => _isPlaying = false);
          // Auto-advance after 1.5s
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (!mounted) return;
            final pages = _pageController.page?.round() ?? _currentPage;
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
            if (pages >= 0) {}
          });
        }
      });
    } catch (_) {}
  }

  Future<void> _togglePlay(StoryPage page) async {
    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _playPage(page);
    }
  }

  void _onPageChanged(int index, List<StoryPage> pages) {
    setState(() {
      _currentPage = index;
      _isPlaying = false;
    });
    _player.stop();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _playPage(pages[index]);
    });
  }

  Future<void> _markRead() async {
    if (_hasMarkedRead) return;
    _hasMarkedRead = true;
    await ref.read(storyRepositoryProvider).markRead(widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    final storyAsync = ref.watch(storyProvider(widget.storyId));

    return storyAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold500)),
      ),
      error: (e, _) => _errorScaffold(context),
      data: (story) {
        if (story == null) return _errorScaffold(context);
        _markRead();
        final pages = story.pages;

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _showControls,
            child: Stack(
              children: [
                // Page view §4.12
                PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (i) => _onPageChanged(i, pages),
                  itemBuilder: (ctx, i) => _StoryPageView(
                    page: pages[i],
                    isPlaying: _isPlaying && _currentPage == i,
                    onTogglePlay: () => _togglePlay(pages[i]),
                  ),
                ),

                // Page indicator dots — bottom strip §4.12
                Positioned(
                  bottom: 16 + MediaQuery.of(context).padding.bottom,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (i) {
                      final active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 20 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: active ? AppColors.gold500 : AppColors.borderDefault,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),

                // Controls overlay (auto-hide) §4.12
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: IgnorePointer(
                      ignoring: !_controlsVisible,
                      child: _ControlsOverlay(
                        story: story,
                        currentPage: _currentPage,
                        totalPages: pages.length,
                        onClose: () => context.go('/home'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _errorScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📖', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text('Could not load story',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go back',
                  style: TextStyle(color: AppColors.gold500)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Story page §4.12: 65% illustration / 35% text ────────────────────────────

class _StoryPageView extends StatelessWidget {
  const _StoryPageView({
    required this.page,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  final StoryPage page;
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Illustration — top 65% §4.12
        Column(
          children: [
            Expanded(
              flex: 65,
              child: _PageImage(imageUrl: page.imageUrl),
            ),
            Expanded(
              flex: 35,
              child: Container(color: AppColors.bgBase),
            ),
          ],
        ),

        // Text area — bottom 35% §4.12
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.of(context).size.height * 0.38,
          child: Container(
            color: AppColors.bgBase,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _StoryText(text: page.text),
                  ),
                ),
                const SizedBox(height: 12),
                // Play button
                GestureDetector(
                  onTap: onTogglePlay,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.borderDefault),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isPlaying ? 'Pause' : 'Listen',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PageImage extends StatelessWidget {
  const _PageImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(color: AppColors.bgElevated);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, __) => Container(color: AppColors.bgElevated),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.bgElevated,
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppColors.textTertiary, size: 40),
      ),
    );
  }
}

// ── Story text with dialogue highlighting ────────────────────────────────────

class _StoryText extends StatelessWidget {
  const _StoryText({required this.text});
  final String text;

  List<({String text, bool isDialogue})> _parse(String input) {
    final segments = <({String text, bool isDialogue})>[];
    // matches both straight "..." and curly "..." dialogue quotes
    final regex = RegExp(r'"[^"]+"|"[^"]+"');
    int lastEnd = 0;
    for (final match in regex.allMatches(input)) {
      if (match.start > lastEnd) {
        segments.add((text: input.substring(lastEnd, match.start), isDialogue: false));
      }
      segments.add((text: match.group(0)!, isDialogue: true));
      lastEnd = match.end;
    }
    if (lastEnd < input.length) {
      segments.add((text: input.substring(lastEnd), isDialogue: false));
    }
    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.fraunces(
      fontSize: 17,
      height: 1.6,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.085,
      color: AppColors.textPrimary,
    );
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: _parse(text).map((seg) => TextSpan(
          text: seg.text,
          style: seg.isDialogue
              ? const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gold500,
                )
              : null,
        )).toList(),
      ),
    );
  }
}

// ── Controls overlay ──────────────────────────────────────────────────────────

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({
    required this.story,
    required this.currentPage,
    required this.totalPages,
    required this.onClose,
  });

  final dynamic story;
  final int currentPage;
  final int totalPages;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withAlpha(160), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: onClose,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(120),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${currentPage + 1} / $totalPages',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              story.favorite ? Icons.favorite : Icons.favorite_border,
              color: story.favorite ? AppColors.gold500 : Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

