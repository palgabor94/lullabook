import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/lullabook_colors.dart';
import '../../core/theme/lullabook_typography.dart';
import '../../shared/widgets/lullabook_chip.dart';

const _adventureChoices = [
  (id: 'space_explorer', label: 'Space Explorer', emoji: '🚀'),
  (id: 'ocean_diver', label: 'Ocean Diver', emoji: '🐬'),
  (id: 'dragon_rider', label: 'Dragon Rider', emoji: '🐉'),
  (id: 'forest_fairy', label: 'Forest Fairy', emoji: '🌿'),
  (id: 'treasure_hunter', label: 'Treasure Hunter', emoji: '💎'),
  (id: 'time_traveler', label: 'Time Traveler', emoji: '⏱️'),
];

const _artStyles = [
  (id: 'pixar_3d', label: 'Pixar Style'),
  (id: 'watercolor', label: 'Watercolor'),
  (id: 'flat_modern', label: 'Flat Modern'),
  (id: 'storybook_classic', label: 'Storybook Classic'),
];

class PreviewIntroScreen extends StatefulWidget {
  const PreviewIntroScreen({super.key});

  @override
  State<PreviewIntroScreen> createState() => _PreviewIntroScreenState();
}

class _PreviewIntroScreenState extends State<PreviewIntroScreen> {
  final _nameController = TextEditingController();
  String _selectedAdventure = 'space_explorer';
  String _selectedStyle = 'pixar_3d';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter your child's name to continue")),
      );
      return;
    }
    context.push('/preview/photo', extra: {
      'childName': name,
      'adventureChoice': _selectedAdventure,
      'artStyle': _selectedStyle,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back button row
              const Row(
                children: [
                  BackButton(color: AppColors.textSecondary),
                ],
              ),

              const SizedBox(height: 20),

              // Eyebrow + title + subtitle
              const Text(
                'FREE PREVIEW · NO SIGNUP',
                style: LullabookTypography.eyebrowMd,
              ),
              const SizedBox(height: 8),
              const Text(
                'See your child\nas the hero',
                style: LullabookTypography.displayXl,
              ),
              const SizedBox(height: 8),
              const Text(
                "We'll show you a sneak peek before any signup.",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.5,
                  color: LullabookColors.textTertiary,
                ),
              ),

              const SizedBox(height: 28),

              // Name field
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: "Child's first name",
                  labelStyle: const TextStyle(color: AppColors.textTertiary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderDefault),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.gold500, width: 1.5),
                  ),
                  filled: true,
                  fillColor: AppColors.bgHover,
                ),
              ),

              const SizedBox(height: 24),

              // Adventure section
              const Text(
                'CHOOSE AN ADVENTURE',
                style: LullabookTypography.eyebrowSm,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _adventureChoices.map((a) {
                  return LullabookChip(
                    label: '${a.emoji} ${a.label}',
                    selected: _selectedAdventure == a.id,
                    onTap: () => setState(() => _selectedAdventure = a.id),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Art style section
              const Text(
                'CHOOSE AN ART STYLE',
                style: LullabookTypography.eyebrowSm,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _artStyles.map((s) {
                  return LullabookChip(
                    label: s.label,
                    selected: _selectedStyle == s.id,
                    onTap: () => setState(() => _selectedStyle = s.id),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Privacy reassurance
              const Text(
                'Photo deleted within 24 hours.\nWe never share your child\'s image.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  height: 1.5,
                  color: LullabookColors.textDisabled,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Primary CTA — white background, dark text
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.bgBase,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next: Add a photo',
                    style: LullabookTypography.labelButton,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Sign in link
              Center(
                child: TextButton(
                  onPressed: () => context.push('/auth'),
                  child: const Text(
                    'Already have an account? Sign in',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
