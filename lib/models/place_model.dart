class Place {
  final String id;
  final String cityId;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final double rating;
  final String address;
  final int reviewCount;
  final bool isPopular;
  final double? lat;
  final double? lng;

  const Place({
    required this.id,
    required this.cityId,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.address,
    this.reviewCount = 0,
    this.isPopular = false,
    this.lat,
    this.lng,
  });
}
