import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/review_model.dart';

class ReviewsScreen extends StatefulWidget {
  final City city;

  const ReviewsScreen({super.key, required this.city});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final List<Review> _localReviews = [];

  int _selectedRating = 5;
  bool _showForm = false;
  bool _loadingLocalReviews = true;

  String get _storageKey => 'local_reviews_${widget.city.id}';

  @override
  void initState() {
    super.initState();
    _loadLocalReviews();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityReviews = reviews.where((review) => review.cityId == widget.city.id).toList();
    final allReviews = [..._localReviews, ...cityReviews];
    final average = _averageRating(allReviews);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '${widget.city.name} Reviews',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              HapticFeedback.selectionClick();
              setState(() => _showForm = !_showForm);
            },
            icon: Icon(_showForm ? Icons.close_rounded : Icons.rate_review_rounded, size: 18),
            label: Text(_showForm ? 'Cancel' : 'Write'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          _ReviewSummary(
            reviews: allReviews,
            average: average,
            loading: _loadingLocalReviews,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _showForm
                ? Padding(
                    key: const ValueKey('review-form'),
                    padding: const EdgeInsets.only(top: 18),
                    child: _ReviewForm(
                      nameController: _nameController,
                      commentController: _commentController,
                      selectedRating: _selectedRating,
                      onRatingChanged: (rating) {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedRating = rating);
                      },
                      onSubmit: _submitReview,
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('no-form')),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Reviews (${allReviews.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (_localReviews.isNotEmpty)
                Text(
                  '${_localReviews.length} saved locally',
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (allReviews.isEmpty)
            const _EmptyReviews()
          else
            ...allReviews.asMap().entries.map(
                  (entry) => _ReviewCard(
                    review: entry.value,
                    isNew: entry.key < _localReviews.length,
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _loadLocalReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_storageKey) ?? [];
      final loaded = <Review>[];

      for (final item in encoded) {
        final data = jsonDecode(item);
        if (data is! Map) continue;

        loaded.add(
          Review(
            id: data['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
            cityId: widget.city.id,
            userName: data['userName']?.toString() ?? 'Traveller',
            comment: data['comment']?.toString() ?? '',
            rating: (data['rating'] as num?)?.toDouble() ?? 5,
            date: DateTime.tryParse(data['date']?.toString() ?? ''),
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _localReviews
          ..clear()
          ..addAll(loaded.where((review) => review.comment.trim().isNotEmpty));
        _loadingLocalReviews = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingLocalReviews = false);
    }
  }

  Future<void> _saveLocalReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _localReviews
        .map(
          (review) => jsonEncode({
            'id': review.id,
            'userName': review.userName,
            'comment': review.comment,
            'rating': review.rating,
            'date': review.date?.toIso8601String(),
          }),
        )
        .toList();

    await prefs.setStringList(_storageKey, encoded);
  }

  void _submitReview() {
    final name = _nameController.text.trim();
    final comment = _commentController.text.trim();

    if (name.isEmpty || comment.isEmpty) {
      _showSnackBar('Please fill in all fields', isError: true);
      return;
    }

    if (comment.length < 12) {
      _showSnackBar('Tell travellers a little more about your experience', isError: true);
      return;
    }

    final review = Review(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      cityId: widget.city.id,
      userName: name,
      comment: comment,
      rating: _selectedRating.toDouble(),
      date: DateTime.now(),
    );

    setState(() {
      _localReviews.insert(0, review);
      _nameController.clear();
      _commentController.clear();
      _selectedRating = 5;
      _showForm = false;
    });

    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();
    _saveLocalReviews();
    _showSnackBar('Review posted and saved');
  }

  double _averageRating(List<Review> items) {
    if (items.isEmpty) return 0;
    return items.fold<double>(0, (sum, review) => sum + review.rating) / items.length;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  final List<Review> reviews;
  final double average;
  final bool loading;

  const _ReviewSummary({
    required this.reviews,
    required this.average,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      average.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loading ? 'Loading local reviews' : '${reviews.length} traveller reviews',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < average.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: index < average.round() ? AppColors.starColor : Colors.white30,
                        size: 23,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Verified feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (var rating = 5; rating >= 1; rating--)
            _RatingDistributionRow(
              rating: rating,
              count: reviews.where((review) => review.rating.round() == rating).length,
              total: reviews.length,
            ),
        ],
      ),
    );
  }
}

class _RatingDistributionRow extends StatelessWidget {
  final int rating;
  final int count;
  final int total;

  const _RatingDistributionRow({
    required this.rating,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : count / total;

    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '$rating',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const Icon(Icons.star_rounded, color: AppColors.starColor, size: 13),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 7,
                value: percent,
                backgroundColor: Colors.white.withValues(alpha: 0.16),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.76),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController commentController;
  final int selectedRating;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  const _ReviewForm({
    required this.nameController,
    required this.commentController,
    required this.selectedRating,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Review',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: commentController,
            minLines: 4,
            maxLines: 6,
            maxLength: 260,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'Share what future travellers should know...',
              alignLabelWithHint: true,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 74),
                child: Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textHint),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Rating',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: '${index + 1} stars',
                    onPressed: () => onRatingChanged(index + 1),
                    icon: Icon(
                      index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: index < selectedRating ? AppColors.starColor : Colors.grey[300],
                      size: 31,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.send_rounded),
              label: const Text('Post Review'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  final bool isNew;

  const _ReviewCard({
    required this.review,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isNew ? AppColors.primary.withValues(alpha: 0.34) : AppColors.divider,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  review.userName.trim().isEmpty ? '?' : review.userName.trim()[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Saved',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: index < review.rating.round() ? AppColors.starColor : Colors.grey[300],
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _formatDate(review.date),
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Recent';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _EmptyReviews extends StatelessWidget {
  const _EmptyReviews();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        children: [
          Icon(Icons.rate_review_outlined, color: AppColors.textHint, size: 42),
          SizedBox(height: 12),
          Text(
            'No reviews yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Be the first traveller to share a note about this destination.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.45),
          ),
        ],
      ),
    );
  }
}
