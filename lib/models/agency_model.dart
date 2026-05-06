class Agency {
  final String id;
  final String cityId;
  final String name;
  final String imageUrl;
  final String description;
  final double rating;
  final String phone;
  final int reviewCount;
  final int toursCount;
  final bool isVerified;

  const Agency({
    required this.id,
    required this.cityId,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.phone,
    this.reviewCount = 0,
    this.toursCount = 0,
    this.isVerified = true,
  });
}
