import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/buddy.dart';

final buddyRepositoryProvider = Provider<BuddyRepository>((ref) => BuddyRepository());

final buddyListProvider = StreamProvider<List<Buddy>>((ref) {
  return ref.watch(buddyRepositoryProvider).watchBuddies();
});

class BuddyRepository {
  final _db = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _buddiesCol(String uid) =>
      _db.collection('users').doc(uid).collection('buddies');

  Stream<List<Buddy>> watchBuddies() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _buddiesCol(uid)
        .snapshots()
        .map((snap) => snap.docs.map(Buddy.fromFirestore).toList());
  }

  Future<Buddy> upsertBuddy({
    required BuddyType type,
    String? name,
    File? photo,
  }) async {
    final callable = _functions.httpsCallable(
      'createBuddy',
      options: HttpsCallableOptions(timeout: const Duration(minutes: 2)),
    );
    final payload = <String, dynamic>{
      'buddyId': type.id,
      'type': type.id,
      if (name != null && name.isNotEmpty) 'name': name,
      if (photo != null) 'photoBase64': base64Encode(await photo.readAsBytes()),
    };
    await callable.call(payload);
    final uid = _uid!;
    final doc = await _buddiesCol(uid).doc(type.id).get();
    return Buddy.fromFirestore(doc);
  }
}
