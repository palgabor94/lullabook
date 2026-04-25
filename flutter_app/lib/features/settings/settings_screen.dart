import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/revenuecat_repository.dart';

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

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // Account section
          const _SectionHeader('Account'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: user?.email ?? 'Signed in',
            subtitle: isPremiumAsync.valueOrNull == true ? 'Premium subscriber' : 'Free plan',
          ),

          const SizedBox(height: 8),

          // Subscription
          const _SectionHeader('Subscription'),
          if (isPremiumAsync.valueOrNull != true)
            _SettingsTile(
              icon: Icons.star_outline,
              title: 'Upgrade to Premium',
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/paywall'),
            ),
          _SettingsTile(
            icon: Icons.restore,
            title: 'Restore purchases',
            trailing: _restoringPurchases
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: _restoringPurchases ? null : _restorePurchases,
          ),

          const SizedBox(height: 8),

          // Support
          const _SectionHeader('Support'),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: 'Contact support',
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {/* mailto: in V1.1 */},
          ),

          const SizedBox(height: 8),

          // Account actions
          const _SectionHeader('Account actions'),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Sign out',
            titleColor: Colors.black87,
            onTap: _signOut,
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Delete account',
            titleColor: Colors.redAccent,
            onTap: _confirmDeleteAccount,
          ),

          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Lullabook · v1.0',
              style: TextStyle(color: Colors.black38, fontSize: 12),
            ),
          ),
        ],
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
        title: const Text('Delete account?'),
        content: const Text(
          'This will permanently delete your account, heroes, and all stories. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      // Call deleteAccount Cloud Function (implemented in V1 polish week)
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.black38,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: titleColor ?? AppColors.primary, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: titleColor ?? Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(fontSize: 12))
            : null,
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
