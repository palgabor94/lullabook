import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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

              // Top bar: back + progress dashes (step 3 of 3, all gold)
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

              // Eyebrow + title + subtitle
              Text(
                'STEP 3 OF 3 · ${name.toUpperCase()}\'S PHOTO',
                style: LullabookTypography.eyebrowMd,
              ),
              const SizedBox(height: 8),
              const Text(
                'A clear photo\nworks best',
                style: LullabookTypography.displayXl,
              ),
              const SizedBox(height: 8),
              const Text(
                'Front-facing with good lighting works best. '
                'Original is deleted within 24 hours.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.5,
                  color: LullabookColors.textTertiary,
                ),
              ),

              const SizedBox(height: 24),

              // Upload zone
              Expanded(
                child: GestureDetector(
                  onTap: () => _pick(ImageSource.gallery),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.gold500.withAlpha(100), // ~40% opacity, softer
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0x0AFFFFFF), // 4% white
                    ),
                    child: _photo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(_photo!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Camera icon in a gold-tint container
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
                              const Text(
                                'Add a photo',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'A clear photo of your child works best',
                                style: TextStyle(
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

              // Camera shortcut
              Center(
                child: TextButton.icon(
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.textTertiary),
                  label: const Text(
                    'Take a photo',
                    style: TextStyle(color: AppColors.textTertiary),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Loading or CTA
              if (_loading)
                const Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.gold500),
                    SizedBox(height: 12),
                    Text(
                      'Creating hero… ~40 seconds',
                      style: TextStyle(color: AppColors.textSecondary),
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
                      'Create hero!',
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
