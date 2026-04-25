import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/story.dart';

/// Hive-backed offline story cache.
/// Stores serialized Story JSON keyed by storyId.
/// Only text + URLs are cached (audio/images streamed from network, not downloaded).
class StoryCache {
  static const _boxName = 'stories_cache';
  static const _maxEntries = 20;

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }

  Box<String> get _box => Hive.box<String>(_boxName);

  Future<void> put(Story story) async {
    final map = _storyToMap(story);
    await _box.put(story.storyId, jsonEncode(map));
    await _evictIfNeeded();
  }

  Story? get(String storyId) {
    final raw = _box.get(storyId);
    if (raw == null) return null;
    try {
      return _storyFromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  List<Story> getAll() {
    return _box.values
        .map((raw) {
          try {
            return _storyFromMap(jsonDecode(raw) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<Story>()
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> remove(String storyId) => _box.delete(storyId);

  Future<void> clear() => _box.clear();

  Future<void> _evictIfNeeded() async {
    if (_box.length <= _maxEntries) return;
    // Remove oldest entries by createdAt
    final entries = _box.keys
        .map((k) {
          final raw = _box.get(k as String);
          if (raw == null) return null;
          try {
            final m = jsonDecode(raw) as Map<String, dynamic>;
            return (key: k, createdAt: m['createdAt'] as int? ?? 0);
          } catch (_) {
            return null;
          }
        })
        .whereType<({String key, int createdAt})>()
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final toRemove = entries.take(entries.length - _maxEntries);
    for (final e in toRemove) {
      await _box.delete(e.key);
    }
  }

  Map<String, dynamic> _storyToMap(Story story) => {
        'storyId': story.storyId,
        'heroId': story.heroId,
        'title': story.title,
        'language': story.language,
        'setup': story.setup,
        'pages': story.pages
            .map((p) => {
                  'pageNumber': p.pageNumber,
                  'text': p.text,
                  'imageUrl': p.imageUrl,
                  'audioUrl': p.audioUrl,
                  'imagePrompt': p.imagePrompt,
                  'isReusedFromHeroReveal': p.isReusedFromHeroReveal,
                })
            .toList(),
        'durationSeconds': story.durationSeconds,
        'readCount': story.readCount,
        'lastReadAt': story.lastReadAt?.millisecondsSinceEpoch,
        'favorite': story.favorite,
        'createdAt': story.createdAt.millisecondsSinceEpoch,
      };

  Story _storyFromMap(Map<String, dynamic> m) => Story(
        storyId: m['storyId'] as String,
        heroId: m['heroId'] as String,
        title: m['title'] as String,
        language: m['language'] as String? ?? 'en-US',
        setup: m['setup'] as Map<String, dynamic>? ?? {},
        pages: (m['pages'] as List<dynamic>)
            .map((p) => StoryPage.fromMap(p as Map<String, dynamic>))
            .toList(),
        durationSeconds: (m['durationSeconds'] as num?)?.toInt() ?? 0,
        readCount: (m['readCount'] as num?)?.toInt() ?? 0,
        lastReadAt: m['lastReadAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(m['lastReadAt'] as int)
            : null,
        favorite: m['favorite'] as bool? ?? false,
        createdAt: DateTime.fromMillisecondsSinceEpoch(m['createdAt'] as int),
      );
}

final storyCache = StoryCache();
