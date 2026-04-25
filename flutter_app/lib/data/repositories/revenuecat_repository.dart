import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final revenueCatRepositoryProvider = Provider<RevenueCatRepository>((ref) {
  return RevenueCatRepository();
});

final currentOfferingProvider = FutureProvider<Offering?>((ref) async {
  final offerings = await Purchases.getOfferings();
  return offerings.current;
});

final isPremiumProvider = FutureProvider<bool>((ref) async {
  final info = await Purchases.getCustomerInfo();
  return info.entitlements.all['premium']?.isActive ?? false;
});

class RevenueCatRepository {
  Future<bool> purchase(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      return result.entitlements.all['premium']?.isActive ?? false;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  Future<bool> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    return info.entitlements.all['premium']?.isActive ?? false;
  }

  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();
}
