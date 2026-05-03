import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/hero.dart';

final heroRepositoryProvider = Provider<HeroRepository>((ref) => HeroRepository());

final heroListProvider = StreamProvider.family<List<Hero>, String>((ref, uid) {
  return ref.read(heroRepositoryProvider).watchHeroes(uid);
});

final firstHeroProvider = StreamProvider.family<Hero?, String>((ref, uid) {
  return ref.read(heroRepositoryProvider).watchHeroes(uid).map(
        (list) => list.isEmpty ? null : list.first,
      );
});

class CreateHeroResult {
  const CreateHeroResult({required this.heroId, required this.heroAnchorImageUrl});
  final String heroId;
  final String heroAnchorImageUrl;

  factory CreateHeroResult.fromMap(Map<String, dynamic> m) => CreateHeroResult(
        heroId: m['heroId'] as String,
        heroAnchorImageUrl: m['heroAnchorImageUrl'] as String,
      );
}

class RegenResult {
  const RegenResult({required this.heroAnchorImageUrl, required this.regenCount});
  final String heroAnchorImageUrl;
  final int regenCount;

  factory RegenResult.fromMap(Map<String, dynamic> m) => RegenResult(
        heroAnchorImageUrl: m['heroAnchorImageUrl'] as String,
        regenCount: m['regenCount'] as int,
      );
}

class HeroRepository {
  final _db = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instance;

  Stream<List<Hero>> watchHeroes(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('heroes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Hero.fromFirestore(d.data())).toList());
  }

  Future<CreateHeroResult> createHero({
    required String name,
    required int age,
    required HeroPronouns pronouns,
    required String definingTraits,
    required ArtStyle artStyle,
    File? photo,
    String? previewId,
    bool debugMode = false,
  }) async {
    final callable = _functions.httpsCallable(
      'createHero',
      options: HttpsCallableOptions(timeout: const Duration(minutes: 3)),
    );

    final Map<String, dynamic> data = {
      'name': name,
      'age': age,
      'pronouns': pronouns.value,
      'definingTraits': definingTraits,
      'artStyle': artStyle.id,
      'debugMode': debugMode,
    };

    if (previewId != null) {
      data['previewId'] = previewId;
    } else if (photo != null) {
      final bytes = await photo.readAsBytes();
      data['photoBase64'] = base64Encode(bytes);
    }

    final result = await callable.call(data);
    return CreateHeroResult.fromMap(Map<String, dynamic>.from(result.data as Map));
  }

  Future<void> deleteHero(String heroId) async {
    final callable = _functions.httpsCallable(
      'deleteHero',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
    );
    await callable.call({'heroId': heroId});
  }

  Future<RegenResult> regenerateHeroAnchor(String heroId) async {
    final callable = _functions.httpsCallable(
      'regenerateHeroAnchor',
      options: HttpsCallableOptions(timeout: const Duration(minutes: 3)),
    );
    final result = await callable.call({'heroId': heroId});
    return RegenResult.fromMap(Map<String, dynamic>.from(result.data as Map));
  }
}
