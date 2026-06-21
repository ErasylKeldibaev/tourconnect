import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../core/utils/app_utils.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';
import '../../widgets/app_image.dart';
import '../places/places_screen.dart';
import '../tours/tours_screen.dart';
import '../agencies/agencies_screen.dart';
import '../trip_planner/trip_planner_screen.dart';
import '../map/map_screen.dart';

class CityDetailsScreen extends StatefulWidget {
  final City city;
  const CityDetailsScreen({super.key, required this.city});

  @override
  State<CityDetailsScreen> createState() => _CityDetailsScreenState();
}

class _CityDetailsScreenState extends State<CityDetailsScreen> {
  final ScrollController _scroll = ScrollController();
  bool _headerCollapsed = false;

  List<Place> get _cityPlaces =>
      places.where((p) => p.cityId == widget.city.id).toList();
  List<Place> get _popularPlaces =>
      _cityPlaces.where((p) => p.isPopular).toList();
  Map<String, int> get _categoryCounts {
    final counts = <String, int>{};
    for (final place in _cityPlaces) {
      counts.update(place.category, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final collapsed = _scroll.offset > 300;
      if (collapsed != _headerCollapsed) {
        setState(() => _headerCollapsed = collapsed);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scroll,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 480,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
            child: _GlassIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
          isDark: _headerCollapsed,
        )),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _FavoriteButton(city: widget.city, isDark: _headerCollapsed),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
                tag: 'city-image-${widget.city.id}',
                child: AppImage(imageUrl: widget.city.imageUrl)),
            // Multi-layer gradient for depth
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TagBadge(text: widget.city.continent),
                    const SizedBox(height: 12),
                    Text(
                      widget.city.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: AppColors.accent, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.city.country,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _RatingInfo(city: widget.city),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: _QuickStatsGrid(city: widget.city, places: _cityPlaces)),
          const SizedBox(height: 32),
          FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _AboutSection(city: widget.city)),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 260),
            child: _CityDiscoverySection(
              city: widget.city,
              places: _cityPlaces,
              categoryCounts: _categoryCounts,
              onSeeAll: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PlacesScreen(city: widget.city)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (_popularPlaces.isNotEmpty)
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: _PopularPlacesSection(
                places: _popularPlaces,
                onSeeAll: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PlacesScreen(city: widget.city))),
              ),
            ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: _MainActionsGrid(city: widget.city),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _GlassIconButton(
      {required this.icon, required this.onTap, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon,
                color: isDark ? AppColors.textPrimary : Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final City city;
  final bool isDark;
  const _FavoriteButton({required this.city, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelProvider>(
      builder: (context, provider, child) {
        final isFav = provider.isCityFavorite(city.id);
        return _GlassIconButton(
          icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          onTap: () => provider.toggleCityFavorite(city),
          isDark: isDark,
        );
      },
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String text;
  const _TagBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Text(text.toUpperCase(),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1)),
    );
  }
}

class _RatingInfo extends StatelessWidget {
  final City city;
  const _RatingInfo({required this.city});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: AppColors.starColor, size: 20),
        const SizedBox(width: 4),
        Text(city.rating.toStringAsFixed(1),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(width: 4),
        Text('(${AppUtils.formatReviewCount(city.reviewCount)})',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
      ],
    );
  }
}

class _QuickStatsGrid extends StatelessWidget {
  final City city;
  final List<Place> places;
  const _QuickStatsGrid({required this.city, required this.places});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
              label: 'PLACES',
              value: '${places.length}',
              icon: Icons.explore_outlined,
              color: AppColors.catSightseeing),
          _StatItem(
              label: 'RATING',
              value: city.rating.toStringAsFixed(1),
              icon: Icons.star_border_rounded,
              color: AppColors.accent),
          _StatItem(
              label: 'REVIEWS',
              value: AppUtils.formatReviewCount(city.reviewCount),
              icon: Icons.chat_bubble_outline_rounded,
              color: AppColors.successColor),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatItem(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _AboutSection extends StatefulWidget {
  final City city;
  const _AboutSection({required this.city});
  @override
  State<_AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<_AboutSection> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0)),
          const SizedBox(height: 12),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(widget.city.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 16, height: 1.6)),
            secondChild: Text(widget.city.description,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 16, height: 1.6)),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Read Less' : 'Read More',
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

class _CityDiscoverySection extends StatelessWidget {
  final City city;
  final List<Place> places;
  final Map<String, int> categoryCounts;
  final VoidCallback onSeeAll;

  const _CityDiscoverySection({
    required this.city,
    required this.places,
    required this.categoryCounts,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPlaces = [...places]..sort((a, b) {
        final rating = b.rating.compareTo(a.rating);
        if (rating != 0) return rating;
        return b.reviewCount.compareTo(a.reviewCount);
      });
    final routeIdeas = sortedPlaces.take(4).toList();
    final categories = categoryCounts.entries.toList()
      ..sort((a, b) {
        final count = b.value.compareTo(a.value);
        if (count != 0) return count;
        return a.key.compareTo(b.key);
      });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'City Guide',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 0,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text('All places'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _GuideSummaryCard(city: city, places: places, categories: categories),
          const SizedBox(height: 18),
          if (categories.isNotEmpty) _CategoryCoverage(categories: categories),
          if (routeIdeas.isNotEmpty) ...[
            const SizedBox(height: 18),
            _RouteIdeas(city: city, places: routeIdeas),
          ],
        ],
      ),
    );
  }
}

class _GuideSummaryCard extends StatelessWidget {
  final City city;
  final List<Place> places;
  final List<MapEntry<String, int>> categories;

  const _GuideSummaryCard({
    required this.city,
    required this.places,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final popularCount = places.where((place) => place.isPopular).length;
    final topCategory =
        categories.isEmpty ? 'Highlights' : categories.first.key;
    final tagText = city.tags.take(3).join(' / ');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$topCategory first',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tagText.isEmpty ? city.continent : tagText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GuideMetric(
                  value: '${places.length}',
                  label: 'Places',
                  icon: Icons.place_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _GuideMetric(
                  value: '${categories.length}',
                  label: 'Themes',
                  icon: Icons.category_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _GuideMetric(
                  value: '$popularCount',
                  label: 'Must-see',
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideMetric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _GuideMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accentLight, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCoverage extends StatelessWidget {
  final List<MapEntry<String, int>> categories;

  const _CategoryCoverage({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((entry) {
        final color = AppColors.categoryColor(entry.key);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_categoryIcon(entry.key), color: color, size: 16),
              const SizedBox(width: 7),
              Text(
                entry.key,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${entry.value}',
                style: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RouteIdeas extends StatelessWidget {
  final City city;
  final List<Place> places;

  const _RouteIdeas({required this.city, required this.places});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: AppColors.accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Perfect first route in ${city.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(places.length, (index) {
            final place = places[index];
            final color = AppColors.categoryColor(place.category);
            return Padding(
              padding:
                  EdgeInsets.only(bottom: index == places.length - 1 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${place.category} / ${place.rating.toStringAsFixed(1)} rating',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

IconData _categoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'sightseeing':
      return Icons.explore_rounded;
    case 'nature':
      return Icons.park_rounded;
    case 'food':
      return Icons.restaurant_rounded;
    case 'history':
      return Icons.account_balance_rounded;
    case 'shopping':
      return Icons.shopping_bag_rounded;
    case 'adventure':
      return Icons.terrain_rounded;
    case 'culture':
      return Icons.palette_rounded;
    case 'architecture':
      return Icons.apartment_rounded;
    default:
      return Icons.place_rounded;
  }
}

class _PopularPlacesSection extends StatelessWidget {
  final List<Place> places;
  final VoidCallback onSeeAll;
  const _PopularPlacesSection({required this.places, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Popular Sights',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 0)),
              GestureDetector(
                  onTap: onSeeAll,
                  child: const Text('See All',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: places.length,
            itemBuilder: (_, i) => _PlaceCard(place: places[i]),
          ),
        ),
      ],
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Place place;
  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(imageUrl: place.imageUrl),
            const DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xAA000000)],
                        stops: [0.5, 1.0]))),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.2)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.starColor, size: 12),
                    const SizedBox(width: 4),
                    Text(place.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainActionsGrid extends StatelessWidget {
  final City city;
  const _MainActionsGrid({required this.city});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActionItem(Icons.map_rounded, 'Map View', 'Explore city map',
          AppColors.catSightseeing, MapScreen(initialCity: city)),
      _ActionItem(Icons.local_activity_rounded, 'Tours', 'Guided bookings',
          AppColors.accent, ToursScreen(city: city)),
      _ActionItem(Icons.hotel_rounded, 'Agencies', 'Travel partners',
          AppColors.successColor, AgenciesScreen(city: city)),
      _ActionItem(Icons.calendar_month_rounded, 'Planner', 'Trip itinerary',
          AppColors.catHistory, TripPlannerScreen(city: city)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4),
        itemCount: items.length,
        itemBuilder: (_, i) => _ActionCard(item: items[i]),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final Widget screen;
  _ActionItem(this.icon, this.title, this.subtitle, this.color, this.screen);
}

class _ActionCard extends StatelessWidget {
  final _ActionItem item;
  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(item.icon, color: item.color, size: 20)),
            const Spacer(),
            Text(item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            Text(item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
