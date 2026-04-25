import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/hero_repository.dart';

class HeroAnchorPreviewScreen extends ConsumerStatefulWidget {
  const HeroAnchorPreviewScreen({super.key, required this.heroData});
  final Map<String, dynamic> heroData;

  @override
  ConsumerState<HeroAnchorPreviewScreen> createState() =>
      _HeroAnchorPreviewScreenState();
}

class _HeroAnchorPreviewScreenState
    extends ConsumerState<HeroAnchorPreviewScreen> {
  bool _regenLoading = false;
  late String _currentImageUrl;
  late int _regenCount;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.heroData['heroAnchorImageUrl'] as String? ?? '';
    _regenCount = widget.heroData['regenCount'] as int? ?? 0;
  }

  Future<void> _regenerate() async {
    final heroId = widget.heroData['heroId'] as String?;
    if (heroId == null) return;

    setState(() => _regenLoading = true);
    try {
      final result =
          await ref.read(heroRepositoryProvider).regenerateHeroAnchor(heroId);
      setState(() {
        _currentImageUrl = result.heroAnchorImageUrl;
        _regenCount = result.regenCount;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _regenLoading = false);
    }
  }

  void _confirm() => context.go('/adventure');

  @override
  Widget build(BuildContext context) {
    final name = widget.heroData['name'] as String? ?? 'your hero';
    final regenLeft = 2 - _regenCount;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Text(
              'Does this look like $name?',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ).animate().fadeIn(),
            const SizedBox(height: 24),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _currentImageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: _currentImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 64),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ).animate().fadeIn(duration: 600.ms),
            ),
            const SizedBox(height: 24),
            if (_regenLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Regenerating… ~40 seconds',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              )
            else ...[
              FilledButton(
                onPressed: _confirm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  "Yes! Start $name's adventure",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              if (regenLeft > 0)
                OutlinedButton(
                  onPressed: _regenerate,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Try again ($regenLeft free regeneration${regenLeft == 1 ? '' : 's'} left)',
                  ),
                )
              else
                Text(
                  'No more free regenerations — you can edit the hero later',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
