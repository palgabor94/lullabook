import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/lullabook_typography.dart';
import '../../data/repositories/hero_repository.dart';
import '../../data/repositories/story_repository.dart';
import '../../data/sources/local/story_cache.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/hero.dart' as domain;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _filter = 'recent';

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  String _currentDateTimeLabel() {
    final now = DateTime.now();
    const days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
    final day = days[now.weekday - 1];
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$day · $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final heroesAsync  = ref.watch(heroListProvider(_uid));
    final storiesAsync = ref.watch(storyListProvider);

    final firstHero = heroesAsync.valueOrNull?.isNotEmpty == true
        ? heroesAsync.valueOrNull!.first
        : null;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── Top bar ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 0),
                child: Row(
                  children: [
                    const Text(
                      'Lullabook',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: -0.36,
                        color: AppColors.gold500,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined,
                          color: AppColors.textSecondary, size: 22),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),
            ),

            // ── Greeting ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentDateTimeLabel(),
                      style: LullabookTypography.eyebrowMd,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      firstHero != null
                          ? 'Good evening, ${firstHero.name}'
                          : 'Good evening',
                      style: AppTextStyles.displayMd(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ready for tonight\'s adventure?',
                      style: AppTextStyles.bodyMd(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

            // ── Hero carousel ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: heroesAsync.when(
                  loading: () => const _HeroCarouselSkeleton(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (heroes) => _HeroCarousel(
                    heroes: heroes,
                    onHeroTap: (h) =>
                        context.push('/adventure', extra: {'heroId': h.heroId}),
                    onAddHero: () => context.push('/hero/setup'),
                    onDeleteHero: (h) => _confirmDeleteHero(context, h),
                  ),
                ),
              ),
            ),

            // ── "Continue reading" ───────────────────────────────────────────
            storiesAsync.when(
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) => SliverToBoxAdapter(child: _OfflineSection()),
              data: (stories) {
                final recent = stories.take(5).toList();
                if (recent.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 14),
                        child: Text(
                          'Continue reading',
                          style: AppTextStyles.eyebrowMd(color: AppColors.textTertiary),
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: recent.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (ctx, i) => _StoryThumbnail(
                            story: recent[i],
                            onTap: () => context.push('/story/reader/${recent[i].storyId}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // ── Library grid ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 14),
                child: Row(
                  children: [
                    Text(
                      'Library',
                      style: AppTextStyles.eyebrowMd(color: AppColors.textTertiary),
                    ),
                    const Spacer(),
                    _FilterPill(
                      label: 'Recent',
                      selected: _filter == 'recent',
                      onTap: () => setState(() => _filter = 'recent'),
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: 'Favourites',
                      selected: _filter == 'favorite',
                      onTap: () => setState(() => _filter = 'favorite'),
                    ),
                  ],
                ),
              ),
            ),

            storiesAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.gold500)),
              ),
              error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              data: (stories) {
                final filtered = _filter == 'favorite'
                    ? stories.where((s) => s.favorite).toList()
                    : stories;

                if (filtered.isEmpty) {
                  return SliverFillRemaining(
                    child: _EmptyState(
                      isFavoriteFilter: _filter == 'favorite',
                      hasHero: firstHero != null,
                      onAction: () {
                        if (firstHero == null) {
                          context.push('/hero/setup');
                        } else {
                          context.push('/adventure', extra: {'heroId': firstHero.heroId});
                        }
                      },
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 168 / 220,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _StoryGridCard(
                        story: filtered[i],
                        index: i,
                        onTap: () => context.push('/story/reader/${filtered[i].storyId}'),
                        onFavourite: () => ref
                            .read(storyRepositoryProvider)
                            .toggleFavorite(filtered[i].storyId, favorite: !filtered[i].favorite),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // ── Bottom tab bar §3.10 ─────────────────────────────────────────────
      bottomNavigationBar: _BottomTabBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 2) context.push('/settings');
        },
      ),
    );
  }

  Future<void> _confirmDeleteHero(BuildContext context, domain.Hero hero) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        title: Text('Delete ${hero.name}?',
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'This will permanently delete ${hero.name}\'s hero profile. Stories created with this hero will remain in your library.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(heroRepositoryProvider).deleteHero(hero.heroId);
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not delete hero. Please try again.')),
      );
    }
  }
}

// ── Hero carousel ─────────────────────────────────────────────────────────────

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel({
    required this.heroes,
    required this.onHeroTap,
    required this.onAddHero,
    required this.onDeleteHero,
  });

  final List<domain.Hero> heroes;
  final ValueChanged<domain.Hero> onHeroTap;
  final VoidCallback onAddHero;
  final ValueChanged<domain.Hero> onDeleteHero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: heroes.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          if (i == heroes.length) {
            return _AddHeroCard(onTap: onAddHero);
          }
          return _HeroCard(
            hero: heroes[i],
            onTap: () => onHeroTap(heroes[i]),
            onDelete: () => onDeleteHero(heroes[i]),
          );
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.hero, required this.onTap, required this.onDelete});

  final domain.Hero hero;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold500, width: 2),
              ),
              child: ClipOval(
                child: hero.heroAnchorThumbUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: hero.heroAnchorThumbUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: AppColors.bgElevated),
                        errorWidget: (_, __, ___) => const Icon(
                            Icons.person,
                            color: AppColors.textTertiary,
                            size: 32),
                      )
                    : const Icon(Icons.person,
                        color: AppColors.textTertiary, size: 32),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                hero.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm(color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold500,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Adventure →',
                  style: AppTextStyles.bodyXs(color: AppColors.bgBase),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, duration: 300.ms);
  }
}

class _AddHeroCard extends StatelessWidget {
  const _AddHeroCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.gold500.withAlpha(80), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold500.withAlpha(30),
              ),
              child: const Icon(Icons.add, color: AppColors.gold500, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              'Add hero',
              style: AppTextStyles.bodySm(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCarouselSkeleton extends StatelessWidget {
  const _HeroCarouselSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Container(
          width: 140,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(18),
          ),
        ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 1200.ms, color: AppColors.bgElevated),
      ),
    );
  }
}

// ── Story thumbnail (horizontal scroll) ──────────────────────────────────────

class _StoryThumbnail extends StatelessWidget {
  const _StoryThumbnail({required this.story, required this.onTap});
  final Story story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = story.pages
        .map((p) => p.imageUrl)
        .firstWhere((url) => url.isNotEmpty, orElse: () => '');

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: coverUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: coverUrl,
                      width: 140,
                      height: 168,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 140, height: 168, color: AppColors.bgCard,
                      ),
                      errorWidget: (_, __, ___) => _CoverPlaceholder(),
                    )
                  : _CoverPlaceholder(),
            ),
            const SizedBox(height: 8),
            Text(
              story.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Story grid card (library) ─────────────────────────────────────────────────

class _StoryGridCard extends StatelessWidget {
  const _StoryGridCard({
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
    final coverUrl = story.pages
        .map((p) => p.imageUrl)
        .firstWhere((url) => url.isNotEmpty, orElse: () => '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    coverUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: coverUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: AppColors.bgElevated),
                            errorWidget: (_, __, ___) => _CoverPlaceholder(),
                          )
                        : _CoverPlaceholder(),
                    // Favourite heart
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onFavourite,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.bgBase.withAlpha(180),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            story.favorite ? Icons.favorite : Icons.favorite_border,
                            color: story.favorite ? AppColors.gold500 : AppColors.textTertiary,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${story.pages.length} pages',
                    style: AppTextStyles.bodyXs(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: index * 50))
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.06, duration: 300.ms),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgElevated,
      child: const Center(
        child: Text('📖', style: TextStyle(fontSize: 32)),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💛', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('No favourites yet',
                style: AppTextStyles.displaySm(color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('Tap the heart on a story to save it here.',
                style: AppTextStyles.bodyMd(color: AppColors.textTertiary)),
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
          Text(
            'Your adventures begin tonight',
            style: AppTextStyles.displaySm(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Tap Tonight's Adventure to create your first story.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 200,
            child: FilledButton(
              onPressed: onAction,
              child: Text(hasHero ? 'Start now' : 'Create a hero'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter pill ────────────────────────────────────────────────────────────────

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold500 : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.gold500 : AppColors.borderDefault,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySm(
              color: selected ? AppColors.bgBase : AppColors.textTertiary),
        ),
      ),
    );
  }
}

// ── Bottom tab bar §3.10 ──────────────────────────────────────────────────────

class _BottomTabBar extends StatelessWidget {
  const _BottomTabBar({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.bgBase.withAlpha(230),
        border: const Border(
          top: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          _TabItem(
            icon: Icons.nightlight_round,
            label: 'TONIGHT',
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _TabItem(
            icon: Icons.menu_book_outlined,
            label: 'LIBRARY',
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _TabItem(
            icon: Icons.settings_outlined,
            label: 'SETTINGS',
            selected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.gold500 : AppColors.textTertiary;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: AppTextStyles.eyebrowXs(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Offline fallback ──────────────────────────────────────────────────────────

class _OfflineSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stories = storyCache.getAll();
    if (stories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, size: 13, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Text(
                'Offline — cached stories',
                style: AppTextStyles.bodyXs(color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
        ...stories.map(
          (s) => _StoryGridCard(
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
