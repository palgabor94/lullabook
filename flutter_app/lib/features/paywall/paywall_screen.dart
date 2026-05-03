import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/revenuecat_repository.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final offeringAsync = ref.watch(currentOfferingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: offeringAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.paywallErrorLoad)),
        data: (offering) {
          if (offering == null) {
            return Center(child: Text(l10n.paywallErrorNoOffers));
          }
          return _PaywallContent(offering: offering);
        },
      ),
    );
  }
}

class _PaywallContent extends ConsumerStatefulWidget {
  const _PaywallContent({required this.offering});
  final Offering offering;

  @override
  ConsumerState<_PaywallContent> createState() => _PaywallContentState();
}

class _PaywallContentState extends ConsumerState<_PaywallContent> {
  bool _loading = false;
  Package? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.offering.availablePackages.firstWhere(
      (p) => p.packageType == PackageType.weekly,
      orElse: () => widget.offering.availablePackages.first,
    );
  }

  Future<void> _purchase() async {
    if (_selected == null) return;
    setState(() => _loading = true);
    try {
      final purchased =
          await ref.read(revenueCatRepositoryProvider).purchase(_selected!);
      if (purchased && mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.paywallErrorPurchaseFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _loading = true);
    try {
      final restored =
          await ref.read(revenueCatRepositoryProvider).restorePurchases();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(restored
                ? l10n.paywallPurchasesRestored
                : l10n.paywallNoSubscription),
          ),
        );
        if (restored) Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final packages = widget.offering.availablePackages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            l10n.paywallTitle,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paywallSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 32),
          ...packages.map((pkg) => _PackageTile(
                package: pkg,
                selected: _selected == pkg,
                onTap: () => setState(() => _selected = pkg),
              )),
          const Spacer(),
          if (_loading)
            const CircularProgressIndicator()
          else
            FilledButton(
              onPressed: _purchase,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                l10n.paywallContinue,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          TextButton(
            onPressed: _loading ? null : _restore,
            child: Text(l10n.paywallRestorePurchases),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({
    required this.package,
    required this.selected,
    required this.onTap,
  });

  final Package package;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = package.packageType == PackageType.weekly
        ? l10n.paywallWeekly
        : package.packageType == PackageType.annual
            ? l10n.paywallYearly
            : package.identifier;
    final subtitle = package.packageType == PackageType.weekly
        ? l10n.paywallWeeklySubtitle(package.storeProduct.priceString)
        : package.packageType == PackageType.annual
            ? l10n.paywallYearlySubtitle(package.storeProduct.priceString)
            : package.storeProduct.priceString;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          color: selected ? AppColors.primary.withAlpha(15) : const Color(0x00000000),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
