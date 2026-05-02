import 'package:flutter/material.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  int selectedRating = 5;
  final List<Review> localReviews = [];

  @override
  Widget build(BuildContext context) {
    final cityReviews = reviews.where((r) => r.cityId == widget.city.id).toList();
    final allReviews = [...localReviews, ...cityReviews];

    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingSummary(allReviews),
            const SizedBox(height: 32),
            _buildAddReviewForm(),
            const SizedBox(height: 40),
            Text(
              'Community Reviews (${allReviews.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildReviewsList(allReviews),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary(List<Review> allReviews) {
    double avg = allReviews.isEmpty ? 0 : allReviews.map((r) => r.rating).reduce((a, b) => a + b) / allReviews.length;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(avg.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
              const Text('out of 5.0', style: TextStyle(color: Colors.white70)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: List.generate(5, (index) => Icon(Icons.star, color: index < avg.round() ? Colors.orange : Colors.white30, size: 20)),
              ),
              const SizedBox(height: 4),
              const Text('Based on traveler feedback', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddReviewForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Write a review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Your full name',
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Share your experience...',
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Your rating:', style: TextStyle(fontWeight: FontWeight.w500)),
              const Spacer(),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedRating = index + 1),
                    child: Icon(Icons.star, color: index < selectedRating ? Colors.orange : Colors.grey[300], size: 28),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitReview,
            child: const Text('Post Review'),
          ),
        ],
      ),
    );
  }

  void _submitReview() {
    if (nameController.text.isEmpty || commentController.text.isEmpty) return;
    setState(() {
      localReviews.insert(0, Review(
        id: DateTime.now().toString(),
        cityId: widget.city.id,
        userName: nameController.text,
        comment: commentController.text,
        rating: selectedRating.toDouble(),
      ));
      nameController.clear();
      commentController.clear();
      selectedRating = 5;
    });
    FocusScope.of(context).unfocus();
  }

  Widget _buildReviewsList(List<Review> allReviews) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allReviews.length,
      itemBuilder: (context, index) {
        final r = allReviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1), child: Text(r.userName[0])),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: List.generate(5, (index) => Icon(Icons.star, color: index < r.rating ? Colors.orange : Colors.grey[300], size: 14)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text('Just now', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Text(r.comment, style: TextStyle(color: Colors.black.withOpacity(0.7), height: 1.4)),
            ],
          ),
        );
      },
    );
  }
}
