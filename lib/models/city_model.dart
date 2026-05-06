class City {
  final String id;
  final String name;
  final String country;
  final String imageUrl;
  final String description;
  final double rating;
  final int reviewCount;
  final String continent;
  final List<String> tags;

  const City({
    required this.id,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.description,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.continent = '',
    this.tags = const [],
  });
}
