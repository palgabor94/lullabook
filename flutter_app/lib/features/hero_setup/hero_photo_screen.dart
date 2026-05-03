import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/lullabook_colors.dart';
import '../../core/theme/lullabook_typography.dart';
import '../../data/repositories/hero_repository.dart';
import '../../domain/entities/hero.dart';

class HeroPhotoScreen extends ConsumerStatefulWidget {
  const HeroPhotoScreen({super.key, required this.heroData});
  final Map<String, dynamic> heroData;

  @override
  ConsumerState<HeroPhotoScreen> createState() => _HeroPhotoScreenState();
}

class _HeroPhotoScreenState extends ConsumerState<HeroPhotoScreen> {
  File? _photo;
  bool _loading = false;
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  Future<void> _generate() async {
    if (_photo == null) return;
    setState(() => _loading = true);
    try {
      final result = await ref.read(heroRepositoryProvider).createHero(
            name: widget.heroData['name'] as String,
            age: widget.heroData['age'] as int,
            pronouns: widget.heroData['pronouns'] as HeroPronouns,
            definingTraits: widget.heroData['definingTraits'] as String,
            artStyle: widget.heroData['artStyle'] as ArtStyle,
            photo: _photo,
          );

      if (mounted) {
        context.pushReplacement('/hero/anchor-preview', extra: {
          ...widget.heroData,
          'heroId': result.heroId,
          'heroAnchorImageUrl': result.heroAnchorImageUrl,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = widget.heroData['name'] as String;
    final hasPhoto = _photo != null;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(color: AppColors.textSecondary),
                  Row(
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                        color: LullabookColors.gold500,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )),
                  ),
                  const SizedBox(width: 36),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                l10n.heroPhotoEyebrow(name),
                style: LullabookTypography.eyebrowMd,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.heroPhotoTitle,
                style: LullabookTypography.displayXl,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.heroPhotoInstruction,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.5,
                  color: LullabookColors.textTertiary,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: GestureDetector(
                  onTap: () => _pick(ImageSource.gallery),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.gold500.withAlpha(100),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0x0AFFFFFF),
                    ),
                    child: _photo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(_photo!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: LullabookColors.goldTint15,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.gold500,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.heroPhotoAdd,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.heroPhotoAddSubtitle,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: LullabookColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton.icon(
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.textTertiary),
                  label: Text(
                    l10n.heroPhotoCameraButton,
                    style: const TextStyle(color: AppColors.textTertiary),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              if (_loading)
                Column(
                  children: [
                    const CircularProgressIndicator(color: AppColors.gold500),
                    const SizedBox(height: 12),
                    Text(
                      l10n.heroPhotoCreating,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: hasPhoto ? _generate : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: AppColors.bgBase,
                      disabledBackgroundColor: const Color(0x1AFFFFFF),
                      disabledForegroundColor: AppColors.textDisabled,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.heroPhotoCreateCta,
                      style: LullabookTypography.labelButton.copyWith(
                        color: hasPhoto ? AppColors.bgBase : AppColors.textDisabled,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
