import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../core/utils/app_utils.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';

class PlacesScreen extends StatefulWidget {
  final City city;
  const PlacesScreen({super.key, required this.city});
  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final cityPlaces = places.where((p) => p.cityId == widget.city.id).toList();
    final categories = ['All', ...{...cityPlaces.map((p) => p.category)}];
    final filtered = _selectedCategory == 'All' ? cityPlaces : cityPlaces.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${widget.city.name} — Places',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          if (categories.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final isSelected = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.categoryColor(cat) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? AppColors.categoryColor(cat) : AppColors.divider),
                        ),
                        child: Text(cat, style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, fontSize: 13)),
                      ),
                    );
                  },
                ),
              ),
            ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.place_outlined, size: 64, color: AppColors.textHint),
              SizedBox(height: 16),
              Text('No places in this category', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            ]))
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final place = filtered[index];
                return FadeInUp(
                  delay: Duration(milliseconds: 60 * index),
                  child: Consumer<TravelProvider>(
                    builder: (_, provider, __) {
                      final isFav = provider.isPlaceFavorite(place.id);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                AppImage(imageUrl: place.imageUrl, height: 210, width: double.infinity, borderRadius: 24),
                                Positioned(top: 14, right: 14,
                                  child: GestureDetector(
                                    onTap: () {
                                      provider.togglePlaceFavorite(place);
                                      AppUtils.showSnackBar(context, isFav ? 'Removed' : '${place.name} saved!');
                                    },
                                    child: Container(padding: const EdgeInsets.all(9),
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                        child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                            color: isFav ? Colors.red : AppColors.textHint, size: 20)),
                                  ),
                                ),
                                Positioned(top: 14, left: 14,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(color: AppColors.categoryColor(place.category), borderRadius: BorderRadius.circular(20)),
                                    child: Text(place.category, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                Positioned(bottom: 14, left: 14,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(12)),
                                    child: Row(children: [
                                      const Icon(Icons.star_rounded, color: AppColors.starColor, size: 14),
                                      const SizedBox(width: 4),
                                      Text('${place.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                                      const SizedBox(width: 4),
                                      Text('(${AppUtils.formatReviewCount(place.reviewCount)})', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                    ]),
                                  ),
                                ),
                                if (place.isPopular)
                                  Positioned(bottom: 14, right: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
                                      child: const Text('🔥 Popular', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(place.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                  const SizedBox(height: 6),
                                  Row(children: [
                                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textHint),
                                    const SizedBox(width: 4),
                                    Expanded(child: Text(place.address, style: const TextStyle(color: AppColors.textHint, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  ]),
                                  const SizedBox(height: 10),
                                  Text(place.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: AppColors.textSecondary, height: 1.5, fontSize: 14)),
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
          ),
        ],
      ),
    );
  }
}