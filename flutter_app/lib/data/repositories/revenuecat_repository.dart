import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../main.dart' show revenueCatConfigured;

final revenueCatRepositoryProvider = Provider<RevenueCatRepository>((ref) {
  return RevenueCatRepository();
});

final currentOfferingProvider = FutureProvider<Offering?>((ref) async {
  if (!revenueCatConfigured) return null;
  final offerings = await Purchases.getOfferings();
  return offerings.current;
});

final isPremiumProvider = FutureProvider<bool>((ref) async {
  if (!revenueCatConfigured) return false;
  final info = await Purchases.getCustomerInfo();
  return info.entitlements.all['premium']?.isActive ?? false;
});

class RevenueCatRepository {
  Future<bool> purchase(Package package) async {
    if (!revenueCatConfigured) return false;
    try {
      final result = await Purchases.purchasePackage(package);
      return result.entitlements.all['premium']?.isActive ?? false;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  Future<bool> restorePurchases() async {
    if (!revenueCatConfigured) return false;
    final info = await Purchases.restorePurchases();
    return info.entitlements.all['premium']?.isActive ?? false;
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    if (!revenueCatConfigured) return null;
    return Purchases.getCustomerInfo();
  }
}
