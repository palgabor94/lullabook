import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/story.dart';
import '../sources/local/story_cache.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) => StoryRepository());

class StoryRepository {
  final _functions = FirebaseFunctions.instance;
  final _firestore = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _storiesCol(String uid) =>
      _firestore.collection('users').doc(uid).collection('stories');

  Future<({String storyId, String title})> generateStory({
    required String heroId,
    required Map<String, dynamic> setup,
    String language = 'en-US',
  }) async {
    final result = await _functions
        .httpsCallable('generateStory')
        .call<Map<dynamic, dynamic>>({
      'heroId': heroId,
      'setup': setup,
      'language': language,
    });

    final data = Map<String, dynamic>.from(result.data);
    return (
      storyId: data['storyId'] as String,
      title: data['title'] as String,
    );
  }

  Future<Story?> get(String storyId) async {
    final uid = _uid;
    if (uid == null) return null;
    final doc = await _storiesCol(uid).doc(storyId).get();
    if (!doc.exists) return null;
    return Story.fromFirestore(doc);
  }

  Stream<Story?> watch(String storyId) {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _storiesCol(uid).doc(storyId).snapshots().map(
          (snap) => snap.exists ? Story.fromFirestore(snap) : null,
        );
  }

  Stream<List<Story>> watchAll() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _storiesCol(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      final stories = snap.docs.map(Story.fromFirestore).toList();
      // Write-through cache: persist latest snapshot for offline reads
      for (final s in stories) {
        storyCache.put(s);
      }
      return stories;
    });
  }

  Stream<List<Story>> watchForHero(String heroId) {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _storiesCol(uid)
        .where('heroId', isEqualTo: heroId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Story.fromFirestore).toList());
  }

  Future<void> markRead(String storyId) async {
    final uid = _uid;
    if (uid == null) return;
    await _storiesCol(uid).doc(storyId).update({
      'readCount': FieldValue.increment(1),
      'lastReadAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleFavorite(String storyId, {required bool favorite}) async {
    final uid = _uid;
    if (uid == null) return;
    await _storiesCol(uid).doc(storyId).update({'favorite': favorite});
  }

  Future<({String imageUrl})> regeneratePage({
    required String storyId,
    required int pageNumber,
  }) async {
    final result = await _functions
        .httpsCallable('regeneratePage')
        .call<Map<dynamic, dynamic>>({
      'storyId': storyId,
      'pageNumber': pageNumber,
    });
    final data = Map<String, dynamic>.from(result.data);
    return (imageUrl: data['imageUrl'] as String);
  }
}

// Providers
final storyListProvider = StreamProvider<List<Story>>((ref) {
  return ref.watch(storyRepositoryProvider).watchAll();
});

final storyProvider = StreamProvider.family<Story?, String>((ref, storyId) {
  return ref.watch(storyRepositoryProvider).watch(storyId);
});
