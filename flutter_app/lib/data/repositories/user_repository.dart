import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final currentUserDocProvider = StreamProvider.family<AppUser?, String>((ref, uid) {
  return ref.read(userRepositoryProvider).watchUser(uid);
});

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Stream<AppUser?> watchUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      return AppUser.fromFirestore(snap.data()!);
    });
  }

  Future<AppUser?> getUser(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    return AppUser.fromFirestore(snap.data()!);
  }

  Future<void> updateReadStats(String uid, String storyId) async {
    await _db.collection('users').doc(uid).collection('stories').doc(storyId).update({
      'readCount': FieldValue.increment(1),
      'lastReadAt': FieldValue.serverTimestamp(),
    });
  }
}
