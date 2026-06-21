import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';
import '../../widgets/city_card.dart';
import '../city/city_details_screen.dart';
import '../profile/profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchText = '';
  String _selectedContinent = 'All';
  String _selectedSort = 'rating';

  static const _sorts = {'rating': 'Rating', 'reviews': 'Popular', 'name': 'A-Z'};

  List<City> get _filtered {
    var list = cities.where((c) {
      final matchSearch = c.name.toLowerCase().contains(_searchText.toLowerCase()) ||
          c.country.toLowerCase().contains(_searchText.toLowerCase());
      final matchContinent = _selectedContinent == 'All' ||
          c.continent.contains(_selectedContinent);
      return matchSearch && matchContinent;
    }).toList();

    switch (_selectedSort) {
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case 'reviews':
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case 'name':
        list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  List<City> get _featured =>
      [...cities]..sort((a, b) => b.rating.compareTo(a.rating));

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openCity(City city) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CityDetailsScreen(city: city),
        transitionsBuilder: (context, anim, secondaryAnimation, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final top = MediaQuery.of(context).padding.top;
    final averageRating = cities.isEmpty
        ? 0.0
        : cities.map((city) => city.rating).reduce((a, b) => a + b) /
            cities.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, top + 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _greeting().toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.5),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Explore the\nWorld Today',
                                    style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                        letterSpacing: 0,
                                        height: 1.0),
                                  ),
                                ],
                              ),
                            ),
                            _AvatarButton(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProfileScreen()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      
                      // Search Bar with improved design
                      FadeInDown(
                        delay: const Duration(milliseconds: 100),
                        child: _ModernSearchBar(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchText = v),
                          onClear: () {
                            _searchController.clear();
                            setState(() => _searchText = '');
                          },
                          onSort: _showSortSheet,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Filter chips
                      FadeInDown(
                        delay: const Duration(milliseconds: 200),
                        child: _ContinentFilters(
                          selected: _selectedContinent,
                          onSelect: (c) => setState(() => _selectedContinent = c),
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeInDown(
                        delay: const Duration(milliseconds: 260),
                        child: Consumer<TravelProvider>(
                          builder: (context, provider, child) => _TravelPulsePanel(
                            destinationCount: cities.length,
                            tourCount: tours.length,
                            averageRating: averageRating,
                            savedCount: provider.totalFavoritesCount,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Featured section
              if (_searchText.isEmpty && _selectedContinent == 'All')
                SliverToBoxAdapter(
                  child: FadeInLeft(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Editor\'s Choice',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: 0),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 240,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 16),
                            itemCount: _featured.take(3).length,
                            itemBuilder: (_, i) {
                              final city = _featured[i];
                              return _FeaturedMiniCard(
                                city: city,
                                onTap: () => _openCity(city),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),

              // List header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Row(
                    children: [
                      Text(
                        _searchText.isNotEmpty ? 'Found results' : 'Discover All',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: 0),
                      ),
                      const Spacer(),
                      Text(
                        '${filtered.length} locations',
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              // City list
              filtered.isEmpty
                  ? SliverToBoxAdapter(child: _EmptyState(query: _searchText))
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => FadeInUp(
                            delay: Duration(milliseconds: 100 * i),
                            duration: const Duration(milliseconds: 500),
                            child: CityCard(
                              city: filtered[i],
                              onTap: () => _openCity(filtered[i]),
                            ),
                          ),
                          childCount: filtered.length,
                        ),
                      ),
                    ),
            ],
          ),
          
          // Bottom subtle overlay for navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: 0),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _showSortSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sort Destinations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              ..._sorts.entries.map((e) => ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: _selectedSort == e.key 
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) 
                    : null,
                onTap: () {
                  setState(() => _selectedSort = e.key);
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onSort;

  const _ModernSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search destinations...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 24),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  tooltip: 'Clear search',
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, color: AppColors.textHint),
                ),
              GestureDetector(
                onTap: onSort,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

class _ContinentFilters extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _ContinentFilters({required this.selected, required this.onSelect});

  static const _continents = ['All', 'Asia', 'Europe', 'Americas', 'Africa', 'Oceania'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _continents.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final c = _continents[i];
          final isSelected = c == selected;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onSelect(c);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Center(
                child: Text(
                  c,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TravelPulsePanel extends StatelessWidget {
  final int destinationCount;
  final int tourCount;
  final double averageRating;
  final int savedCount;

  const _TravelPulsePanel({
    required this.destinationCount,
    required this.tourCount,
    required this.averageRating,
    required this.savedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.18),
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
                  Icons.auto_graph_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Travel pulse',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Curated picks, tours and saved ideas',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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
                child: _PulseMetric(
                  label: 'Destinations',
                  value: '$destinationCount',
                  icon: Icons.public_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PulseMetric(
                  label: 'Tours',
                  value: '$tourCount',
                  icon: Icons.local_activity_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PulseMetric(
                  label: 'Rating',
                  value: averageRating.toStringAsFixed(1),
                  icon: Icons.star_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PulseMetric(
                  label: 'Saved',
                  value: '$savedCount',
                  icon: Icons.favorite_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PulseMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PulseMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
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
          const SizedBox(height: 5),
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
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedMiniCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  const _FeaturedMiniCard({required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImage(imageUrl: city.imageUrl, fit: BoxFit.cover),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xAA000000)],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      city.country,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AvatarButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: const CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.person_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(Icons.location_off_rounded, size: 80, color: AppColors.textHint.withValues(alpha: 0.3)),
          const SizedBox(height: 24),
          const Text(
            'No destinations found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            query.trim().isEmpty
                ? 'Try changing filters or sorting'
                : 'No matches for "$query". Try another search.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
