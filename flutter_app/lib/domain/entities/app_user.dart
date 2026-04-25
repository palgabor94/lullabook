class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.subscription,
    required this.dailyUsage,
    required this.totalStoriesCreated,
    required this.totalHeroesCreated,
  });

  final String uid;
  final String email;
  final String? displayName;
  final UserSubscription subscription;
  final DailyUsage dailyUsage;
  final int totalStoriesCreated;
  final int totalHeroesCreated;

  bool get isPremium => subscription.tier != SubscriptionTier.free;

  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    final sub = data['subscription'] as Map<String, dynamic>? ?? {};
    final usage = data['dailyUsage'] as Map<String, dynamic>? ?? {};
    return AppUser(
      uid: data['uid'] as String,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      subscription: UserSubscription(
        tier: SubscriptionTier.fromString(sub['tier'] as String? ?? 'free'),
        isInTrial: sub['isInTrial'] as bool? ?? false,
        expiresAt: (sub['expiresAt'] as dynamic)?.toDate() as DateTime?,
      ),
      dailyUsage: DailyUsage(
        date: usage['date'] as String? ?? '',
        storiesGenerated: usage['storiesGenerated'] as int? ?? 0,
      ),
      totalStoriesCreated: data['totalStoriesCreated'] as int? ?? 0,
      totalHeroesCreated: data['totalHeroesCreated'] as int? ?? 0,
    );
  }
}

class UserSubscription {
  const UserSubscription({
    required this.tier,
    required this.isInTrial,
    this.expiresAt,
  });

  final SubscriptionTier tier;
  final bool isInTrial;
  final DateTime? expiresAt;

  int get dailyStoryCap {
    switch (tier) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.weekly:
        return 3;
      case SubscriptionTier.yearly:
        return 1;
    }
  }
}

class DailyUsage {
  const DailyUsage({required this.date, required this.storiesGenerated});
  final String date;
  final int storiesGenerated;
}

enum SubscriptionTier {
  free,
  weekly,
  yearly;

  static SubscriptionTier fromString(String value) {
    return SubscriptionTier.values.firstWhere(
      (t) => t.name == value,
      orElse: () => SubscriptionTier.free,
    );
  }
}
