import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/debug_settings_provider.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    final isPremiumAsync = ref.watch(isPremiumProvider);
    final isPremium = isPremiumAsync.valueOrNull ?? false;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Title §4.16
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
                      'Settings',
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
                  const _SectionHeader('ACCOUNT'),
                  _SettingsTile(
                    icon: Icons.person_outline,
                    title: user?.email ?? 'Signed in',
                    subtitle: isPremium ? 'Premium subscriber' : 'Free plan',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0x26FFB84D),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPremium ? 'PREMIUM' : 'FREE',
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
                    title: 'Manage subscription',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () => context.push('/paywall'),
                  ),
                  _SettingsTile(
                    icon: Icons.restore,
                    title: 'Restore purchases',
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
                  const _SectionHeader('STORY PREFERENCES'),
                  _SettingsTile(
                    icon: Icons.language,
                    title: 'Story language',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Default art style',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.record_voice_over_outlined,
                    title: 'Narration voice',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // ── Reader ─────────────────────────────────────────────
                  const _SectionHeader('READER'),
                  _ToggleTile(
                    icon: Icons.play_circle_outline,
                    title: 'Auto-play narration',
                    value: true,
                    onChanged: (_) {},
                  ),
                  _ToggleTile(
                    icon: Icons.bedtime_outlined,
                    title: 'Sleep mode',
                    value: true,
                    onChanged: (_) {},
                  ),
                  _ToggleTile(
                    icon: Icons.music_note_outlined,
                    title: 'Background music',
                    value: false,
                    onChanged: (_) {},
                  ),

                  const SizedBox(height: 24),

                  // ── App ────────────────────────────────────────────────
                  const _SectionHeader('APP'),
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Theme',
                    subtitle: 'Dark',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _ToggleTile(
                    icon: Icons.notifications_outlined,
                    title: 'Bedtime reminder',
                    value: false,
                    onChanged: (_) {},
                  ),

                  const SizedBox(height: 24),

                  // ── Support ────────────────────────────────────────────
                  const _SectionHeader('SUPPORT'),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help center',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.mail_outline,
                    title: 'Contact us',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.star_rate_outlined,
                    title: 'Rate Lullabook',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // ── Legal ──────────────────────────────────────────────
                  const _SectionHeader('LEGAL'),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),

                  // ── Account actions ────────────────────────────────────
                  const _SectionHeader('ACCOUNT ACTIONS'),
                  _SettingsTile(
                    icon: Icons.logout,
                    title: 'Sign out',
                    onTap: _signOut,
                  ),
                  _SettingsTile(
                    icon: Icons.delete_outline,
                    title: 'Delete account',
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: _confirmDeleteAccount,
                  ),

                  const SizedBox(height: 24),

                  // ── Developer ──────────────────────────────────────────
                  const _SectionHeader('DEVELOPER'),
                  _ToggleTile(
                    icon: Icons.science_outlined,
                    title: 'Debug mode',
                    value: ref.watch(debugModeProvider),
                    onChanged: (v) =>
                        ref.read(debugModeProvider.notifier).setDebugMode(v),
                  ),
                  _SettingsTile(
                    icon: Icons.play_circle_outline,
                    title: 'Generate test story',
                    titleColor: AppColors.gold700,
                    iconColor: AppColors.gold700,
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textTertiary),
                    onTap: () => context.push('/debug'),
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text(
                      'Lullabook · v1.0',
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

  Future<void> _restorePurchases() async {
    setState(() => _restoringPurchases = true);
    try {
      await ref.read(revenueCatRepositoryProvider).restorePurchases();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchases restored')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to restore')),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        title: const Text('Delete account?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'This will permanently delete your account, heroes, and all stories. This cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    try {
      await ref.read(authRepositoryProvider).signOut();
      if (!mounted) return;
      context.go('/auth');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete account. Contact support.')),
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
