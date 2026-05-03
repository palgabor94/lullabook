import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

import '../../core/providers/debug_settings_provider.dart';
import '../../core/providers/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/revenuecat_repository.dart';
import '../../shared/widgets/lullabook_switch.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _restoringPurchases = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final isPremiumAsync = ref.watch(isPremiumProvider);
    final isPremium = isPremiumAsync.valueOrNull ?? false;
    final currentLocale = ref.watch(languageProvider);
    final langSubtitle = currentLocale.languageCode == 'hu'
        ? l10n.settingsLanguageHungarian
        : l10n.settingsLanguageEnglish;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 24, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.textSecondary, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      l10n.settingsTitle,
                      style: AppTextStyles.displayMd(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // ── Account ────────────────────────────────────────────
                  _SectionHeader(l10n.settingsSectionAccount),
                  _SettingsTile(
                    icon: Icons.person_outline,
                    title: user?.email ?? l10n.settingsSignedInFallback,
                    subtitle: isPremium ? l10n.settingsPremiumLabel : l10n.settingsFreePlan,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0x26FFB84D),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPremium ? l10n.settingsPremiumBadge : l10n.settingsFreeBadge,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          letterSpacing: 0.5,
                          color: AppColors.gold500,
                        ),
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.star_outline,
                    title: l10n.settingsManageSubscription,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () => context.push('/paywall'),
                  ),
                  _SettingsTile(
                    icon: Icons.restore,
                    title: l10n.settingsRestorePurchases,
                    trailing: _restoringPurchases
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.gold500),
                          )
                        : null,
                    onTap: _restoringPurchases ? null : _restorePurchases,
                  ),

                  const SizedBox(height: 24),

                  // ── Story preferences ──────────────────────────────────
                  _SectionHeader(l10n.settingsSectionStoryPrefs),
                  _SettingsTile(
                    icon: Icons.language,
                    title: l10n.settingsStoryLanguage,
                    subtitle: langSubtitle,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () => _showLanguagePicker(context),
                  ),
                  _SettingsTile(
                    icon: Icons.palette_outlined,
                    title: l10n.settingsDefaultArtStyle,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.record_voice_over_outlined,
                    title: l10n.settingsNarrationVoice,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // ── Reader ─────────────────────────────────────────────
                  _SectionHeader(l10n.settingsSectionReader),
                  _ToggleTile(
                    icon: Icons.play_circle_outline,
                    title: l10n.settingsAutoPlay,
                    value: true,
                    onChanged: (_) {},
                  ),
                  _ToggleTile(
                    icon: Icons.bedtime_outlined,
                    title: l10n.settingsSleepMode,
                    value: true,
                    onChanged: (_) {},
                  ),
                  _ToggleTile(
                    icon: Icons.music_note_outlined,
                    title: l10n.settingsBackgroundMusic,
                    value: false,
                    onChanged: (_) {},
                  ),

                  const SizedBox(height: 24),

                  // ── App ────────────────────────────────────────────────
                  _SectionHeader(l10n.settingsSectionApp),
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: l10n.settingsTheme,
                    subtitle: l10n.settingsThemeDark,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _ToggleTile(
                    icon: Icons.notifications_outlined,
                    title: l10n.settingsBedtimeReminder,
                    value: false,
                    onChanged: (_) {},
                  ),

                  const SizedBox(height: 24),

                  // ── Support ────────────────────────────────────────────
                  _SectionHeader(l10n.settingsSectionSupport),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    title: l10n.settingsHelpCenter,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.mail_outline,
                    title: l10n.settingsContactUs,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.star_rate_outlined,
                    title: l10n.settingsRateApp,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // ── Legal ──────────────────────────────────────────────
                  _SectionHeader(l10n.settingsSectionLegal),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: l10n.settingsTerms,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.settingsPrivacy,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // ── Account actions ────────────────────────────────────
                  _SectionHeader(l10n.settingsSectionAccountActions),
                  _SettingsTile(
                    icon: Icons.logout,
                    title: l10n.settingsSignOut,
                    onTap: _signOut,
                  ),
                  _SettingsTile(
                    icon: Icons.delete_outline,
                    title: l10n.settingsDeleteAccount,
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: _confirmDeleteAccount,
                  ),

                  const SizedBox(height: 24),

                  // ── Developer ──────────────────────────────────────────
                  _SectionHeader(l10n.settingsSectionDeveloper),
                  _ToggleTile(
                    icon: Icons.science_outlined,
                    title: l10n.settingsDebugMode,
                    value: ref.watch(debugModeProvider),
                    onChanged: (v) =>
                        ref.read(debugModeProvider.notifier).setDebugMode(v),
                  ),
                  _SettingsTile(
                    icon: Icons.play_circle_outline,
                    title: l10n.settingsGenerateTestStory,
                    titleColor: AppColors.gold700,
                    iconColor: AppColors.gold700,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () => context.push('/debug'),
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text(
                      l10n.settingsFooter,
                      style: AppTextStyles.bodyXs(color: AppColors.textFaint),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext ctx) {
    final current = ref.read(languageProvider);
    showModalBottomSheet<void>(
      context: ctx,
      backgroundColor: AppColors.bgElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          for (final locale in supportedLocales)
            ListTile(
              title: Text(
                languageNames[locale.languageCode]!,
                style: AppTextStyles.bodyLg(color: AppColors.textPrimary),
              ),
              trailing: locale == current
                  ? const Icon(Icons.check, color: AppColors.gold500)
                  : null,
              onTap: () {
                ref.read(languageProvider.notifier).setLocale(locale);
                Navigator.pop(ctx);
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _restorePurchases() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _restoringPurchases = true);
    try {
      await ref.read(revenueCatRepositoryProvider).restorePurchases();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsPurchasesRestored)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsNothingToRestore)),
      );
    } finally {
      if (mounted) setState(() => _restoringPurchases = false);
    }
  }

  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    if (!mounted) return;
    context.go('/auth');
  }

  Future<void> _confirmDeleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        title: Text(l10n.settingsDeleteAccountTitle,
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(
          l10n.settingsDeleteAccountMessage,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.settingsDeleteAccountCancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.settingsDeleteAccountConfirm,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    final l10nAfter = AppLocalizations.of(context)!;
    try {
      await ref.read(authRepositoryProvider).signOut();
      if (!mounted) return;
      context.go('/auth');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nAfter.settingsDeleteError)),
      );
    }
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.eyebrowSm(color: AppColors.textTertiary),
      ),
    );
  }
}

// ── Settings tile ─────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: iconColor ?? AppColors.textTertiary, size: 20),
        title: Text(
          title,
          style: AppTextStyles.bodyLg(color: titleColor ?? AppColors.textPrimary),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: AppTextStyles.bodyXs(color: AppColors.textTertiary))
            : null,
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ── Toggle tile ────────────────────────────────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: AppColors.textTertiary, size: 20),
        title: Text(title, style: AppTextStyles.bodyLg(color: AppColors.textPrimary)),
        trailing: LullabookSwitch(value: value, onChanged: onChanged),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
