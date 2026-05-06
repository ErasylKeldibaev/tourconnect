import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../core/utils/app_utils.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';

class ToursScreen extends StatelessWidget {
  final City city;
  const ToursScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final cityTours = tours.where((t) => t.cityId == city.id).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${city.name} — Tours',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: cityTours.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.explore_outlined, size: 64, color: AppColors.textHint),
        SizedBox(height: 16),
        Text('No tours available yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
      ]))
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        physics: const BouncingScrollPhysics(),
        itemCount: cityTours.length,
        itemBuilder: (context, index) {
          final tour = cityTours[index];
          return FadeInUp(
            delay: Duration(milliseconds: 60 * index),
            child: Consumer<TravelProvider>(
              builder: (_, provider, __) {
                final isFav = provider.isTourFavorite(tour.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AppImage(imageUrl: tour.imageUrl, height: 220, width: double.infinity, borderRadius: 24),
                          Positioned(top: 14, right: 14,
                            child: GestureDetector(
                              onTap: () {
                                provider.toggleTourFavorite(tour);
                                AppUtils.showSnackBar(context, isFav ? 'Removed' : '${tour.title} saved!');
                              },
                              child: Container(padding: const EdgeInsets.all(9),
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      color: isFav ? Colors.red : AppColors.textHint, size: 20)),
                            ),
                          ),
                          if (tour.isInstantBook)
                            Positioned(top: 14, left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: AppColors.successColor, borderRadius: BorderRadius.circular(20)),
                                child: const Text('⚡ Instant Book', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          Positioned(bottom: 14, right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary, borderRadius: BorderRadius.circular(14),
                                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                              ),
                              child: Text(tour.priceDisplay, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                            ),
                          ),
                          Positioned(bottom: 14, left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                const Icon(Icons.star_rounded, color: AppColors.starColor, size: 14),
                                const SizedBox(width: 4),
                                Text('${tour.rating} (${AppUtils.formatReviewCount(tour.reviewCount)})',
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tour.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            const SizedBox(height: 14),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              _badge(Icons.timer_outlined, tour.duration),
                              _badge(Icons.group_outlined, 'Max ${tour.maxGroupSize}'),
                              _badge(Icons.trending_up_rounded, tour.difficulty),
                            ]),
                            const SizedBox(height: 14),
                            Text(tour.description, maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14)),
                            if (tour.includes.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              const Text('Includes:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                              const SizedBox(height: 8),
                              Wrap(spacing: 6, runSpacing: 6,
                                children: tour.includes.map((item) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                                  child: Text('✓ $item', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                                )).toList(),
                              ),
                            ],
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => AppUtils.showSnackBar(context, 'Booking coming soon!'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text('Reserve Your Spot', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _badge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
      ]),
    );
  }
}