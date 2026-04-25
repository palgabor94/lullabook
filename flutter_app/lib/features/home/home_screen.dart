import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/hero_repository.dart';
import '../../data/repositories/story_repository.dart';
import '../../data/sources/local/story_cache.dart';
import '../../domain/entities/story.dart';

// Alias to avoid conflict with Flutter's built-in Hero widget
import '../../domain/entities/hero.dart' as domain;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _filter = 'recent'; // 'recent' | 'favorite'

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    final heroAsync = ref.watch(firstHeroProvider(_uid));
    final storiesAsync = ref.watch(storyListProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Lullabook',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startAdventure(heroAsync.valueOrNull),
        backgroundColor: AppColors.primary,
        label: const Text('New adventure',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.auto_stories, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          // Hero banner
          SliverToBoxAdapter(
            child: heroAsync.when(
              loading: () => const SizedBox(height: 80),
              error: (_, __) => const SizedBox.shrink(),
              data: (hero) => hero == null
                  ? _NoHeroBanner(onSetup: () => context.push('/hero/setup'))
                  : _HeroBanner(hero: hero),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text(
                    'Stories',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  _FilterChip(
                    label: 'Recent',
                    selected: _filter == 'recent',
                    onTap: () => setState(() => _filter = 'recent'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Favourites',
                    selected: _filter == 'favorite',
                    onTap: () => setState(() => _filter = 'favorite'),
                  ),
                ],
              ),
            ),
          ),

          // Story list
          storiesAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => SliverToBoxAdapter(
              child: _OfflineList(filter: _filter),
            ),
            data: (stories) {
              final filtered = _filter == 'favorite'
                  ? stories.where((s) => s.favorite).toList()
                  : stories;

              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyState(
                    isFavoriteFilter: _filter == 'favorite',
                    hasHero: heroAsync.valueOrNull != null,
                    onAction: () => _startAdventure(heroAsync.valueOrNull),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _StoryCard(
                      story: filtered[i],
                      index: i,
                      onTap: () =>
                          context.push('/story/reader/${filtered[i].storyId}'),
                      onFavourite: () => ref
                          .read(storyRepositoryProvider)
                          .toggleFavorite(
                            filtered[i].storyId,
                            favorite: !filtered[i].favorite,
                          ),
                    ),
                    childCount: filtered.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _startAdventure(domain.Hero? hero) {
    if (hero == null) {
      context.push('/hero/setup');
    } else {
      context.push('/adventure', extra: {'heroId': hero.heroId});
    }
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.hero});
  final domain.Hero hero;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF9B7FD4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: hero.heroAnchorThumbUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 64,
                height: 64,
                color: Colors.white24,
                child: const Icon(Icons.person, color: Colors.white54, size: 32),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: Colors.white24,
                child: const Icon(Icons.person, color: Colors.white54, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hero.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${hero.age} years old · ${hero.artStyle.label}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }
}

class _NoHeroBanner extends StatelessWidget {
  const _NoHeroBanner({required this.onSetup});
  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSetup,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(20),
          border: Border.all(color: AppColors.primary.withAlpha(80)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Text('🧒', style: TextStyle(fontSize: 40)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create your first hero',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Set up your child\'s character to start generating personalised stories.',
                      style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.story,
    required this.index,
    required this.onTap,
    required this.onFavourite,
  });

  final Story story;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  @override
  Widget build(BuildContext context) {
    final coverPage = story.pages.isNotEmpty ? story.pages.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cover image
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: coverPage != null && coverPage.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: coverPage.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(width: 90, height: 90, color: const Color(0xFFEDE7F6)),
                      errorWidget: (_, __, ___) =>
                          _PlaceholderCover(),
                    )
                  : _PlaceholderCover(),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.menu_book_outlined,
                            size: 13, color: Colors.black45),
                        const SizedBox(width: 4),
                        Text(
                          '${story.pages.length} pages',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black45),
                        ),
                        if (story.readCount > 0) ...[
                          const SizedBox(width: 10),
                          const Icon(Icons.visibility_outlined,
                              size: 13, color: Colors.black45),
                          const SizedBox(width: 4),
                          Text(
                            '${story.readCount}×',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black45),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Favourite button
            IconButton(
              icon: Icon(
                story.favorite ? Icons.favorite : Icons.favorite_border,
                color: story.favorite ? Colors.redAccent : Colors.black26,
                size: 20,
              ),
              onPressed: onFavourite,
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: index * 60))
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.08, duration: 300.ms),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      color: const Color(0xFFEDE7F6),
      child: const Center(
        child: Text('📖', style: TextStyle(fontSize: 32)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.isFavoriteFilter,
    required this.hasHero,
    required this.onAction,
  });

  final bool isFavoriteFilter;
  final bool hasHero;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    if (isFavoriteFilter) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('💛', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Text('No favourites yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Text('Tap the heart on a story to save it here.',
                style: TextStyle(color: Colors.black45)),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌙', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          const Text(
            'No stories yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first adventure\nand watch the magic happen.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45, height: 1.5),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            child: Text(
              hasHero ? 'Start an adventure' : 'Create a hero',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.black26,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Fallback offline list when Firestore stream errors
class _OfflineList extends StatelessWidget {
  const _OfflineList({required this.filter});
  final String filter;

  @override
  Widget build(BuildContext context) {
    var stories = storyCache.getAll();
    if (filter == 'favorite') stories = stories.where((s) => s.favorite).toList();

    if (stories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text(
            'No cached stories available offline.',
            style: TextStyle(color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.wifi_off, size: 14, color: Colors.black45),
              SizedBox(width: 6),
              Text('Offline — showing cached stories',
                  style: TextStyle(fontSize: 12, color: Colors.black45)),
            ],
          ),
        ),
        ...stories.map(
          (s) => _StoryCard(
            story: s,
            index: 0,
            onTap: () => context.push('/story/reader/${s.storyId}'),
            onFavourite: () {},
          ),
        ),
      ],
    );
  }
}
