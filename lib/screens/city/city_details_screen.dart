import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../core/utils/app_utils.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';
import '../places/places_screen.dart';
import '../tours/tours_screen.dart';
import '../agencies/agencies_screen.dart';
import '../trip_planner/trip_planner_screen.dart';
import '../reviews/reviews_screen.dart';

class CityDetailsScreen extends StatelessWidget {
  final City city;
  const CityDetailsScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(duration: const Duration(milliseconds: 400), child: _buildHeaderInfo()),
                  const SizedBox(height: 12),
                  FadeInUp(delay: const Duration(milliseconds: 100), child: _buildTagsRow()),
                  const SizedBox(height: 28),
                  FadeInUp(delay: const Duration(milliseconds: 150),
                      child: const Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                  const SizedBox(height: 10),
                  FadeInUp(delay: const Duration(milliseconds: 200),
                      child: Text(city.description,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.65))),
                  const SizedBox(height: 32),
                  FadeInUp(delay: const Duration(milliseconds: 250),
                      child: const Text('Explore the City', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                  const SizedBox(height: 16),
                  _buildNavigationGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.95),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
          child: Consumer<TravelProvider>(
            builder: (_, provider, __) {
              final isFav = provider.isCityFavorite(city.id);
              return GestureDetector(
                onTap: () {
                  provider.toggleCityFavorite(city);
                  AppUtils.showSnackBar(context, isFav ? 'Removed from saved' : '${city.name} saved!');
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.95),
                  child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : AppColors.textPrimary, size: 20),
                ),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(tag: 'city-image-${city.id}', child: AppImage(imageUrl: city.imageUrl)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0x22000000), Color(0xCC000000)], stops: [0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 28, left: 24, right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(city.name,
                      style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.0)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(city.country, style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w500)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: AppColors.starColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.star_rounded, color: AppColors.starColor, size: 18),
            const SizedBox(width: 5),
            Text('${city.rating}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
          ]),
        ),
        const SizedBox(width: 10),
        Text('(${AppUtils.formatReviewCount(city.reviewCount)} reviews)',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(city.continent,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildTagsRow() {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: city.tags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(20)),
        child: Text('# $tag', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
      )).toList(),
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    final items = [
      _NavItem(Icons.place_rounded, 'Places', 'Top spots to visit', AppColors.catSightseeing, PlacesScreen(city: city)),
      _NavItem(Icons.explore_rounded, 'Tours', 'Guided experiences', AppColors.accent, ToursScreen(city: city)),
      _NavItem(Icons.business_rounded, 'Agencies', 'Local tour operators', AppColors.successColor, AgenciesScreen(city: city)),
      _NavItem(Icons.calendar_today_rounded, 'Trip Planner', 'Build your itinerary', AppColors.catHistory, TripPlannerScreen(city: city)),
      _NavItem(Icons.rate_review_rounded, 'Reviews', 'Traveller stories', AppColors.catFood, ReviewsScreen(city: city)),
    ];
    return Column(
      children: items.asMap().entries.map((e) => FadeInUp(
        delay: Duration(milliseconds: 300 + e.key * 80),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => e.value.screen)),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: e.value.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                      child: Icon(e.value.icon, color: e.value.color, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.value.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text(e.value.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    )),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }
}

class _NavItem {
  final IconData icon; final String title, subtitle; final Color color; final Widget screen;
  _NavItem(this.icon, this.title, this.subtitle, this.color, this.screen);
}