import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../data/dummy_data.dart';
import '../../widgets/app_image.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final favCities = cities.where((c) => provider.isCityFavorite(c.id)).toList();
        final favPlaces = places.where((p) => provider.isPlaceFavorite(p.id)).toList();
        final favTours = tours.where((t) => provider.isTourFavorite(t.id)).toList();
        final total = favCities.length + favPlaces.length + favTours.length;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Saved', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          body: total == 0
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: const Icon(Icons.favorite_border_rounded, size: 56, color: AppColors.primary)),
            const SizedBox(height: 24),
            const Text('Nothing saved yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            const Text('Tap the ♡ on cities, places\nand tours to save them here',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
          ]))
              : ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            physics: const BouncingScrollPhysics(),
            children: [
              if (favCities.isNotEmpty) ...[
                _sectionHeader('Cities', favCities.length),
                const SizedBox(height: 12),
                ...favCities.asMap().entries.map((e) => FadeInUp(
                  delay: Duration(milliseconds: 60 * e.key),
                  child: _FavCard(title: e.value.name, subtitle: e.value.country,
                      imageUrl: e.value.imageUrl, icon: Icons.location_city_rounded,
                      color: AppColors.primary, onRemove: () => provider.toggleCityFavorite(e.value)),
                )),
                const SizedBox(height: 20),
              ],
              if (favPlaces.isNotEmpty) ...[
                _sectionHeader('Places', favPlaces.length),
                const SizedBox(height: 12),
                ...favPlaces.asMap().entries.map((e) => FadeInUp(
                  delay: Duration(milliseconds: 60 * e.key),
                  child: _FavCard(title: e.value.name, subtitle: e.value.category,
                      imageUrl: e.value.imageUrl, icon: Icons.place_rounded,
                      color: AppColors.catSightseeing, onRemove: () => provider.togglePlaceFavorite(e.value)),
                )),
                const SizedBox(height: 20),
              ],
              if (favTours.isNotEmpty) ...[
                _sectionHeader('Tours', favTours.length),
                const SizedBox(height: 12),
                ...favTours.asMap().entries.map((e) => FadeInUp(
                  delay: Duration(milliseconds: 60 * e.key),
                  child: _FavCard(title: e.value.title, subtitle: '${e.value.priceDisplay} · ${e.value.duration}',
                      imageUrl: e.value.imageUrl, icon: Icons.explore_rounded,
                      color: AppColors.accent, onRemove: () => provider.toggleTourFavorite(e.value)),
                )),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title, int count) {
    return Row(children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(width: 8),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Text('$count', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12))),
    ]);
  }
}

class _FavCard extends StatelessWidget {
  final String title, subtitle, imageUrl;
  final IconData icon;
  final Color color;
  final VoidCallback onRemove;

  const _FavCard({required this.title, required this.subtitle, required this.imageUrl,
    required this.icon, required this.color, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Row(children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: AppImage(imageUrl: imageUrl, width: 88, height: 88, fit: BoxFit.cover),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(subtitle, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
        ])),
        IconButton(onPressed: onRemove, icon: const Icon(Icons.favorite_rounded, color: Colors.red, size: 22)),
      ]),
    );
  }
}