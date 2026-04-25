class Hero {
  const Hero({
    required this.heroId,
    required this.name,
    required this.age,
    required this.pronouns,
    required this.definingTraits,
    required this.heroAnchorStoragePath,
    required this.heroAnchorImageUrl,
    required this.heroAnchorThumbUrl,
    required this.artStyle,
    required this.regenCount,
    required this.createdAt,
  });

  final String heroId;
  final String name;
  final int age;
  final HeroPronouns pronouns;
  final String definingTraits;
  final String heroAnchorStoragePath;
  final String heroAnchorImageUrl;
  final String heroAnchorThumbUrl;
  final ArtStyle artStyle;
  final int regenCount;
  final DateTime createdAt;

  bool get canRegen => regenCount < 2;

  factory Hero.fromFirestore(Map<String, dynamic> data) {
    return Hero(
      heroId: data['heroId'] as String,
      name: data['name'] as String,
      age: data['age'] as int,
      pronouns: HeroPronouns.fromString(data['pronouns'] as String? ?? 'they/them'),
      definingTraits: data['definingTraits'] as String? ?? '',
      heroAnchorStoragePath: data['heroAnchorStoragePath'] as String,
      heroAnchorImageUrl: data['heroAnchorImageUrl'] as String,
      heroAnchorThumbUrl: data['heroAnchorThumbUrl'] as String,
      artStyle: ArtStyle.fromString(data['artStyle'] as String? ?? 'pixar_3d'),
      regenCount: data['regenCount'] as int? ?? 0,
      createdAt: (data['createdAt'] as dynamic)?.toDate() as DateTime? ?? DateTime.now(),
    );
  }
}

enum HeroPronouns {
  heHim('he/him', 'He/Him'),
  sheHer('she/her', 'She/Her'),
  theyThem('they/them', 'They/Them');

  const HeroPronouns(this.value, this.label);
  final String value;
  final String label;

  static HeroPronouns fromString(String v) =>
      HeroPronouns.values.firstWhere((e) => e.value == v, orElse: () => HeroPronouns.theyThem);
}

enum ArtStyle {
  pixar3d('pixar_3d', 'Pixar Style'),
  watercolor('watercolor', 'Watercolor'),
  flatModern('flat_modern', 'Flat Modern'),
  storybookClassic('storybook_classic', 'Storybook Classic');

  const ArtStyle(this.id, this.label);
  final String id;
  final String label;

  static ArtStyle fromString(String v) =>
      ArtStyle.values.firstWhere((e) => e.id == v, orElse: () => ArtStyle.pixar3d);
}
