import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lullabook/generated/l10n/app_localizations.dart';

enum BuddyType {
  dad('dad', 'Dad', '👨'),
  mom('mom', 'Mom', '👩'),
  sibling('sibling', 'Sibling', '🧒'),
  dog('dog', 'Dog', '🐶'),
  cat('cat', 'Cat', '🐱'),
  grandpa('grandpa', 'Grandpa', '👴'),
  grandma('grandma', 'Grandma', '👵'),
  friend('friend', 'Friend', '🧑');

  const BuddyType(this.id, this.label, this.emoji);
  final String id;
  final String label;
  final String emoji;

  static BuddyType? fromId(String? id) {
    if (id == null) return null;
    for (final t in BuddyType.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}

extension BuddyTypeL10n on BuddyType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case BuddyType.dad: return l10n.buddyDad;
      case BuddyType.mom: return l10n.buddyMom;
      case BuddyType.sibling: return l10n.buddySibling;
      case BuddyType.dog: return l10n.buddyDog;
      case BuddyType.cat: return l10n.buddyCat;
      case BuddyType.grandpa: return l10n.buddyGrandpa;
      case BuddyType.grandma: return l10n.buddyGrandma;
      case BuddyType.friend: return l10n.buddyFriend;
    }
  }
}

class Buddy {
  final String buddyId;
  final BuddyType type;
  final String? name;
  final String? photoUrl;
  final String? photoThumbUrl;
  final String? photoStoragePath;
  final DateTime createdAt;

  const Buddy({
    required this.buddyId,
    required this.type,
    this.name,
    this.photoUrl,
    this.photoThumbUrl,
    this.photoStoragePath,
    required this.createdAt,
  });

  String get displayName => (name != null && name!.isNotEmpty) ? name! : type.label;

  factory Buddy.fromFirestore(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    final type = BuddyType.fromId(m['type'] as String?) ?? BuddyType.friend;
    return Buddy(
      buddyId: m['buddyId'] as String? ?? doc.id,
      type: type,
      name: m['name'] as String?,
      photoUrl: m['photoUrl'] as String?,
      photoThumbUrl: m['photoThumbUrl'] as String? ?? m['photoUrl'] as String?,
      photoStoragePath: m['photoStoragePath'] as String?,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
