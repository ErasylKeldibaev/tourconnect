class Tour {
  final String id;
  final String cityId;
  final String agencyId;
  final String title;
  final String imageUrl;
  final double price;
  final String currency;
  final String duration;
  final String description;
  final double rating;
  final int reviewCount;
  final int maxGroupSize;
  final String difficulty;
  final List<String> includes;
  final bool isInstantBook;

  const Tour({
    required this.id,
    required this.cityId,
    required this.agencyId,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.currency = 'USD',
    required this.duration,
    required this.description,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.maxGroupSize = 15,
    this.difficulty = 'Easy',
    this.includes = const [],
    this.isInstantBook = true,
  });

  String get priceDisplay => '\$${price.toStringAsFixed(0)}';
}
