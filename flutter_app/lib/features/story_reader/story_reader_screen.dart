import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

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
  StreamSubscription<PlayerState>? _playerSubscription;

  int _currentPage = 0;
  bool _isPlaying = false;
  bool _audioFinished = false;
  bool _controlsVisible = false;
  bool _hasMarkedRead = false;
  Timer? _controlsTimer;

  @override
  void dispose() {
    _playerSubscription?.cancel();
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
    _playerSubscription?.cancel();
    _playerSubscription = null;

    if (page.audioUrl.isEmpty) {
      setState(() {
        _isPlaying = false;
        _audioFinished = true;
      });
      return;
    }

    setState(() {
      _isPlaying = false;
      _audioFinished = false;
    });

    try {
      await _player.stop();
      await _player.setUrl(page.audioUrl);

      // Listener setup BEFORE play() to avoid missing events.
      // startedPlaying flag prevents the stale `completed` replay-event
      // (BehaviorSubject replays last value to new subscribers) from
      // immediately marking the page as finished before audio begins.
      bool startedPlaying = false;
      _playerSubscription = _player.playerStateStream.listen((state) {
        if (!mounted) return;
        if (state.playing && !startedPlaying) {
          startedPlaying = true;
          setState(() => _isPlaying = true);
        }
        if (startedPlaying && state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _audioFinished = true;
          });
        }
      });

      await _player.play();
    } catch (_) {
      if (mounted) setState(() => _audioFinished = true);
    }
  }

  Future<void> _replayPage(StoryPage page) async {
    await _playPage(page);
  }

  void _goNextPage(List<StoryPage> pages) {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home');
    }
  }

  void _onPageChanged(int index, List<StoryPage> pages) {
    setState(() {
      _currentPage = index;
      _isPlaying = false;
      _audioFinished = false;
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_currentPage == 0 && !_isPlaying && !_audioFinished) {
            _playPage(pages[0]);
          }
        });

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _showControls,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (i) => _onPageChanged(i, pages),
                  itemBuilder: (ctx, i) => _StoryPageView(
                    page: pages[i],
                    audioFinished: _audioFinished && _currentPage == i,
                    isLastPage: i == pages.length - 1,
                    onNext: () => _goNextPage(pages),
                    onAgain: () => _replayPage(pages[i]),
                  ),
                ),

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📖', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(l10n.readerErrorTitle,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/home'),
              child: Text(l10n.readerErrorBack,
                  style: const TextStyle(color: AppColors.gold500)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Story page: 65% illustration / 35% text ──────────────────────────────────

class _StoryPageView extends StatelessWidget {
  const _StoryPageView({
    required this.page,
    required this.audioFinished,
    required this.isLastPage,
    required this.onNext,
    required this.onAgain,
  });

  final StoryPage page;
  final bool audioFinished;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      fit: StackFit.expand,
      children: [
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

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.of(context).size.height * 0.38,
          child: Container(
            color: AppColors.bgBase,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _StoryText(text: page.text),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedOpacity(
                  opacity: audioFinished ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: IgnorePointer(
                    ignoring: !audioFinished,
                    child: Row(
                      children: [
                        // Again button
                        GestureDetector(
                          onTap: onAgain,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.borderDefault),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.replay,
                                  color: AppColors.textPrimary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.readerAgain,
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
                        const SizedBox(width: 12),
                        // Next / Finish button
                        Expanded(
                          child: GestureDetector(
                            onTap: onNext,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.gold500,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLastPage
                                        ? l10n.readerFinish
                                        : l10n.readerNext,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (!isLastPage) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ],
                                ],
                              ),
                            ),
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
    final l10n = AppLocalizations.of(context)!;
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
              l10n.readerPageIndicator(currentPage + 1, totalPages),
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
