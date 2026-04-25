import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/revenuecat_repository.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        error: (_, __) => const Center(child: Text('Could not load offers')),
        data: (offering) {
          if (offering == null) {
            return const Center(child: Text('No offers available'));
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
    // Default selection: weekly package, fall back to first available
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
          const SnackBar(content: Text('Purchase failed. Please try again.')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(restored
                ? 'Purchases restored!'
                : 'No active subscription found.'),
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
    final packages = widget.offering.availablePackages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Unlock Lullabook',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlimited personalized bedtime stories',
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
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          TextButton(
            onPressed: _loading ? null : _restore,
            child: const Text('Restore purchases'),
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

  String get _title {
    if (package.packageType == PackageType.weekly) return 'Weekly';
    if (package.packageType == PackageType.annual) return 'Yearly';
    return package.identifier;
  }

  String get _subtitle {
    if (package.packageType == PackageType.weekly) {
      return '3-day free trial, then ${package.storeProduct.priceString}/week';
    }
    if (package.packageType == PackageType.annual) {
      return '${package.storeProduct.priceString}/year — best value';
    }
    return package.storeProduct.priceString;
  }

  @override
  Widget build(BuildContext context) {
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
                Text(_title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text(_subtitle,
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
