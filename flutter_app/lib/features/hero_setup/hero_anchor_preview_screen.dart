import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
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
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.bgElevated,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _regenLoading = false);
    }
  }

  void _confirm() {
    final heroId = widget.heroData['heroId'] as String? ?? '';
    context.go('/adventure', extra: {'heroId': heroId});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = widget.heroData['name'] as String? ?? 'your hero';
    final regenLeft = 2 - _regenCount;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const _ProgressDots(current: 1),

              const SizedBox(height: 28),

              Text(
                l10n.heroAnchorTitle(name),
                style: AppTextStyles.displayMd(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 32),

              Expanded(
                child: _regenLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                                color: AppColors.gold500),
                            const SizedBox(height: 16),
                            Text(
                              l10n.heroAnchorRegenerating,
                              style: AppTextStyles.bodyMd(
                                  color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: _currentImageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: _currentImageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (_, __) => Container(
                                    color: AppColors.bgElevated,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                          color: AppColors.gold500),
                                    )),
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.bgElevated,
                                  child: const Icon(Icons.broken_image,
                                      color: AppColors.textTertiary, size: 64),
                                ),
                              )
                            : Container(
                                color: AppColors.bgElevated,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.gold500)),
                              ),
                      ).animate().fadeIn(duration: 600.ms),
              ),

              const SizedBox(height: 24),

              Text(
                l10n.heroAnchorRegenerationsLeft(regenLeft),
                style: AppTextStyles.bodyXs(color: AppColors.textTertiary),
              ),

              const SizedBox(height: 16),

              if (!_regenLoading) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: regenLeft > 0 ? _regenerate : null,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text(l10n.heroAnchorTryAgain),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.borderDefault),
                          minimumSize: const Size(0, 54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _confirm,
                        child: Text(l10n.heroAnchorConfirm(name)),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.current});
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.gold500 : AppColors.borderDefault,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
