import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/lullabook_colors.dart';
import '../../core/theme/lullabook_typography.dart';
import '../../shared/widgets/lullabook_chip.dart';

List<({String id, String label, String emoji})> _buildAdventureChoices(AppLocalizations l10n) => [
  (id: 'space_explorer', label: l10n.previewAdventureSpaceExplorer, emoji: '🚀'),
  (id: 'ocean_diver',    label: l10n.previewAdventureOceanDiver,    emoji: '🐬'),
  (id: 'dragon_rider',   label: l10n.previewAdventureDragonRider,   emoji: '🐉'),
  (id: 'forest_fairy',   label: l10n.previewAdventureForestFairy,   emoji: '🌿'),
  (id: 'treasure_hunter',label: l10n.previewAdventureTreasureHunter,emoji: '💎'),
  (id: 'time_traveler',  label: l10n.previewAdventureTimeTraveler,  emoji: '⏱️'),
];

List<({String id, String label})> _buildArtStyles(AppLocalizations l10n) => [
  (id: 'pixar_3d',          label: l10n.heroArtStylePixar),
  (id: 'watercolor',        label: l10n.heroArtStyleWatercolor),
  (id: 'flat_modern',       label: l10n.heroArtStyleFlatModern),
  (id: 'storybook_classic', label: l10n.heroArtStyleStorybook),
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

  void _continue(AppLocalizations l10n) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.previewNameValidation)),
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
    final l10n = AppLocalizations.of(context)!;
    final adventureChoices = _buildAdventureChoices(l10n);
    final artStyles = _buildArtStyles(l10n);

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Row(
                children: [
                  BackButton(color: AppColors.textSecondary),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                l10n.previewEyebrow,
                style: LullabookTypography.eyebrowMd,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.previewTitle,
                style: LullabookTypography.displayXl,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.previewSubtitle,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.5,
                  color: LullabookColors.textTertiary,
                ),
              ),

              const SizedBox(height: 28),

              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: l10n.previewChildNameLabel,
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

              Text(
                l10n.previewAdventureHeader,
                style: LullabookTypography.eyebrowSm,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: adventureChoices.map((a) {
                  return LullabookChip(
                    label: '${a.emoji} ${a.label}',
                    selected: _selectedAdventure == a.id,
                    onTap: () => setState(() => _selectedAdventure = a.id),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              Text(
                l10n.previewArtStyleHeader,
                style: LullabookTypography.eyebrowSm,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: artStyles.map((s) {
                  return LullabookChip(
                    label: s.label,
                    selected: _selectedStyle == s.id,
                    onTap: () => setState(() => _selectedStyle = s.id),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              Text(
                l10n.previewPrivacyNote,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  height: 1.5,
                  color: LullabookColors.textDisabled,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () => _continue(l10n),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: AppColors.bgBase,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.previewNextButton,
                    style: LullabookTypography.labelButton,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () => context.push('/auth'),
                  child: Text(
                    l10n.previewAlreadyAccount,
                    style: const TextStyle(
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
