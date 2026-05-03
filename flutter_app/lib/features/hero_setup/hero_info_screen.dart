import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/lullabook_colors.dart';
import '../../core/theme/lullabook_typography.dart';
import '../../domain/entities/hero.dart';
import '../../shared/widgets/lullabook_chip.dart';

class HeroInfoScreen extends ConsumerStatefulWidget {
  const HeroInfoScreen({
    super.key,
    this.prefillName,
    this.prefillArtStyle,
    this.previewId,
  });

  final String? prefillName;
  final String? prefillArtStyle;
  final String? previewId;

  @override
  ConsumerState<HeroInfoScreen> createState() => _HeroInfoScreenState();
}

class _HeroInfoScreenState extends ConsumerState<HeroInfoScreen> {
  final _nameController = TextEditingController();
  int _age = 5;
  HeroPronouns _pronouns = HeroPronouns.theyThem;
  final _traitsController = TextEditingController();
  ArtStyle _artStyle = ArtStyle.pixar3d;

  @override
  void initState() {
    super.initState();
    if (widget.prefillName != null) _nameController.text = widget.prefillName!;
    if (widget.prefillArtStyle != null) {
      _artStyle = ArtStyle.fromString(widget.prefillArtStyle!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _traitsController.dispose();
    super.dispose();
  }

  void _continue(AppLocalizations l10n) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.heroNameValidation)),
      );
      return;
    }

    final extra = {
      'name': name,
      'age': _age,
      'pronouns': _pronouns,
      'definingTraits': _traitsController.text.trim(),
      'artStyle': _artStyle,
      'previewId': widget.previewId,
    };

    if (widget.previewId != null) {
      context.push('/hero/anchor-preview', extra: extra);
    } else {
      context.push('/hero/photo', extra: extra);
    }
  }

  String get _dynamicName {
    final n = _nameController.text.trim();
    return n.isEmpty ? 'your hero' : n;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        color: i == 1
                            ? LullabookColors.gold500
                            : LullabookColors.borderStrong,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )),
                  ),
                  const SizedBox(width: 36),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                l10n.heroInfoEyebrow,
                style: LullabookTypography.eyebrowMd,
              ),
              const SizedBox(height: 8),
              ListenableBuilder(
                listenable: _nameController,
                builder: (ctx, __) => Text(
                  AppLocalizations.of(ctx)!.heroInfoTitle(_dynamicName),
                  style: LullabookTypography.displayXl,
                ),
              ),

              const SizedBox(height: 28),

              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: l10n.heroNameLabel,
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

              Text(l10n.heroAgeHeader, style: LullabookTypography.eyebrowSm),
              const SizedBox(height: 8),
              Row(
                children: [3, 4, 5, 6, 7, 8].map((age) {
                  final selected = _age == age;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => setState(() => _age = age),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? LullabookColors.gold500
                                : LullabookColors.bgHover,
                            border: Border.all(
                              color: selected
                                  ? LullabookColors.gold500
                                  : LullabookColors.borderSubtle,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            age.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              fontSize: 13,
                              color: selected
                                  ? LullabookColors.bgBase
                                  : LullabookColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              Text(l10n.heroPronounsHeader, style: LullabookTypography.eyebrowSm),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: HeroPronouns.values.map((p) => LullabookChip(
                  label: p.localizedLabel(l10n),
                  selected: _pronouns == p,
                  onTap: () => setState(() => _pronouns = p),
                )).toList(),
              ),

              const SizedBox(height: 24),

              TextField(
                controller: _traitsController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: l10n.heroTraitsLabel,
                  hintText: l10n.heroTraitsHint,
                  labelStyle: const TextStyle(color: AppColors.textTertiary),
                  hintStyle: const TextStyle(color: AppColors.textFaint),
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

              Text(l10n.heroArtStyleHeader, style: LullabookTypography.eyebrowSm),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ArtStyle.values.map((s) => LullabookChip(
                  label: s.localizedLabel(l10n),
                  selected: _artStyle == s,
                  onTap: () => setState(() => _artStyle = s),
                )).toList(),
              ),

              const SizedBox(height: 40),

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
                    widget.previewId != null ? l10n.heroConfirmButton : l10n.heroNextPhotoButton,
                    style: LullabookTypography.labelButton
                        .copyWith(color: AppColors.bgBase),
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
