class Review {
  final String id;
  final String cityId;
  final String userName;
  final String? userAvatar;
  final String comment;
  final double rating;
  final DateTime? date;

  const Review({
    required this.id,
    required this.cityId,
    required this.userName,
    this.userAvatar,
    required this.comment,
    required this.rating,
    this.date,
  });
}
