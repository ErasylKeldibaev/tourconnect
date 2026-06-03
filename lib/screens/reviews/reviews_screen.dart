import 'package:flutter/material.dart';
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
  int _selectedRating = 5;
  final List<Review> _localReviews = [];
  bool _showForm = false;

  @override
  void dispose() { _nameController.dispose(); _commentController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cityReviews = reviews.where((r) => r.cityId == widget.city.id).toList();
    final allReviews = [..._localReviews, ...cityReviews];
    final avg = allReviews.isEmpty ? 0.0 : allReviews.map((r) => r.rating).reduce((a, b) => a + b) / allReviews.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.city.name} Reviews',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _showForm = !_showForm),
            icon: Icon(_showForm ? Icons.close : Icons.edit_rounded, size: 18),
            label: Text(_showForm ? 'Cancel' : 'Write'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          // Rating summary
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(avg.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w800, height: 1)),
                  const Text('out of 5.0', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ]),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(children: List.generate(5, (i) => Icon(
                      i < avg.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: i < avg.round() ? AppColors.starColor : Colors.white30, size: 22))),
                  const SizedBox(height: 8),
                  Text('${allReviews.length} traveller reviews',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              ],
            ),
          ),

          // Write review form
          if (_showForm) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Review', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Your name',
                        prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.textHint)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Share your experience...',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textHint),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Rating:', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const Spacer(),
                      Row(children: List.generate(5, (i) => GestureDetector(
                        onTap: () => setState(() => _selectedRating = i + 1),
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                                i < _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: i < _selectedRating ? AppColors.starColor : Colors.grey[300], size: 30)),
                      ))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Post Review', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          Text('Reviews (${allReviews.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          ...allReviews.asMap().entries.map((e) => _ReviewCard(review: e.value, isNew: e.key < _localReviews.length)),
        ],
      ),
    );
  }

  void _submitReview() {
    if (_nameController.text.trim().isEmpty || _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill in all fields'),
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
      return;
    }
    setState(() {
      _localReviews.insert(0, Review(
        id: DateTime.now().toString(), cityId: widget.city.id,
        userName: _nameController.text.trim(), comment: _commentController.text.trim(),
        rating: _selectedRating.toDouble(), date: DateTime.now(),
      ));
      _nameController.clear(); _commentController.clear();
      _selectedRating = 5; _showForm = false;
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Review posted! Thank you 🙏'),
      backgroundColor: AppColors.successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  final bool isNew;
  const _ReviewCard({required this.review, this.isNew = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: isNew ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(review.userName[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    if (isNew) ...[
                      const SizedBox(width: 8),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                          child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))),
                    ],
                  ]),
                  Row(children: List.generate(5, (i) => Icon(
                      i < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: i < review.rating ? AppColors.starColor : Colors.grey[300], size: 14))),
                ],
              )),
              Text(
                  review.date != null ? '${review.date!.day}/${review.date!.month}/${review.date!.year}' : 'Recent',
                  style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment, style: const TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14)),
        ],
      ),
    );
  }
}