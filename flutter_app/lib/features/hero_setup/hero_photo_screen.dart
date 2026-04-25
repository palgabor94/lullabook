import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("$name's photo"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Add a clear photo of $name\'s face.\nThis becomes their hero image!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _pick(ImageSource.gallery),
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withAlpha(80), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primary.withAlpha(10),
                ),
                child: _photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(_photo!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.primary),
                          SizedBox(height: 12),
                          Text('Tap to choose from gallery',
                              style: TextStyle(color: AppColors.primary)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _pick(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Take a photo'),
            ),
            const Spacer(),
            if (_loading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Creating hero… ~40 seconds',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              )
            else
              FilledButton(
                onPressed: _photo != null ? _generate : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Create hero!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
