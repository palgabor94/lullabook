import 'package:cloud_firestore/cloud_firestore.dart';

class StoryPage {
  final int pageNumber;
  final String text;
  final String imageUrl;
  final String audioUrl;
  final String imagePrompt;
  final bool isReusedFromHeroReveal;

  const StoryPage({
    required this.pageNumber,
    required this.text,
    required this.imageUrl,
    required this.audioUrl,
    required this.imagePrompt,
    required this.isReusedFromHeroReveal,
  });

  factory StoryPage.fromMap(Map<String, dynamic> m) => StoryPage(
        pageNumber: (m['pageNumber'] as num).toInt(),
        text: m['text'] as String,
        imageUrl: m['imageUrl'] as String? ?? '',
        audioUrl: m['audioUrl'] as String? ?? '',
        imagePrompt: m['imagePrompt'] as String? ?? '',
        isReusedFromHeroReveal: m['isReusedFromHeroReveal'] as bool? ?? false,
      );
}

class Story {
  final String storyId;
  final String heroId;
  final String title;
  final String language;
  final Map<String, dynamic> setup;
  final List<StoryPage> pages;
  final int durationSeconds;
  final int readCount;
  final DateTime? lastReadAt;
  final bool favorite;
  final DateTime createdAt;

  const Story({
    required this.storyId,
    required this.heroId,
    required this.title,
    required this.language,
    required this.setup,
    required this.pages,
    required this.durationSeconds,
    required this.readCount,
    this.lastReadAt,
    required this.favorite,
    required this.createdAt,
  });

  factory Story.fromFirestore(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return Story(
      storyId: m['storyId'] as String,
      heroId: m['heroId'] as String,
      title: m['title'] as String,
      language: m['language'] as String? ?? 'en-US',
      setup: m['setup'] as Map<String, dynamic>? ?? {},
      pages: (m['pages'] as List<dynamic>? ?? [])
          .map((p) => StoryPage.fromMap(p as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber)),
      durationSeconds: (m['durationSeconds'] as num?)?.toInt() ?? 0,
      readCount: (m['readCount'] as num?)?.toInt() ?? 0,
      lastReadAt: (m['lastReadAt'] as Timestamp?)?.toDate(),
      favorite: m['favorite'] as bool? ?? false,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
