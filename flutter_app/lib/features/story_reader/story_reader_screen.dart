import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:go_router/go_router.dart';

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
  bool _hasMarkedRead = false;

  @override
  void dispose() {
    _pageController.dispose();
    _player.dispose();
    super.dispose();
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
    // Auto-play narration on page change
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
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📖', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text('Could not load story',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/adventure'),
                child: const Text('Go back',
                    style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
      data: (story) {
        if (story == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Story not found',
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () => context.go('/adventure'),
                    child: const Text('Go back',
                        style: TextStyle(color: AppColors.primary)),
                  )
                ],
              ),
            ),
          );
        }

        _markRead();
        final pages = story.pages;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Page viewer
              PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (i) => _onPageChanged(i, pages),
                itemBuilder: (context, i) {
                  final page = pages[i];
                  return _StoryPage(
                    page: page,
                    isPlaying: _isPlaying && _currentPage == i,
                    onTogglePlay: () => _togglePlay(page),
                  );
                },
              ),

              // Top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => context.go('/adventure'),
                        ),
                        Expanded(
                          child: Text(
                            story.title,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Page indicator
                        Text(
                          '${_currentPage + 1} / ${pages.length}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom page dots
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _currentPage ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _currentPage
                            ? AppColors.primary
                            : Colors.white30,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StoryPage extends StatelessWidget {
  const _StoryPage({
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
        // Full-screen image
        if (page.imageUrl.isNotEmpty)
          CachedNetworkImage(
            imageUrl: page.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.backgroundDark),
            errorWidget: (_, __, ___) =>
                Container(color: AppColors.backgroundDark),
          )
        else
          Container(color: AppColors.backgroundDark),

        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
        ),

        // Text + play button
        Positioned(
          bottom: 56,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(blurRadius: 4, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onTogglePlay,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(220),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPlaying ? 'Pause' : 'Listen',
                        style: const TextStyle(
                          color: Colors.white,
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
      ],
    );
  }
}
