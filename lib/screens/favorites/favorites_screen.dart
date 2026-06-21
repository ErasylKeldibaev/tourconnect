import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';
import '../../models/tour_model.dart';
import '../../widgets/app_image.dart';
import '../city/city_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final favCities =
            cities.where((city) => provider.isCityFavorite(city.id)).toList();
        final favPlaces = places
            .where((place) => provider.isPlaceFavorite(place.id))
            .toList();
        final favTours =
            tours.where((tour) => provider.isTourFavorite(tour.id)).toList();
        final total = favCities.length + favPlaces.length + favTours.length;

        final filteredCities = favCities.where(_matchesCity).toList();
        final filteredPlaces = favPlaces.where(_matchesPlace).toList();
        final filteredTours = favTours.where(_matchesTour).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: _FavoritesHeader(
                          total: total,
                          citiesCount: favCities.length,
                          placesCount: favPlaces.length,
                          toursCount: favTours.length,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FavoritesSearch(
                        controller: _searchController,
                        enabled: total > 0,
                        onChanged: (value) =>
                            setState(() => _query = value.trim().toLowerCase()),
                        onClear: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                      const SizedBox(height: 14),
                      _FavoritesTabs(
                        controller: _tabController,
                        citiesCount: filteredCities.length,
                        placesCount: filteredPlaces.length,
                        toursCount: filteredTours.length,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: total == 0
                      ? const _EmptyLibraryState()
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _CitiesTab(
                              cities: filteredCities,
                              provider: provider,
                              hasQuery: _query.isNotEmpty,
                            ),
                            _PlacesTab(
                              places: filteredPlaces,
                              provider: provider,
                              hasQuery: _query.isNotEmpty,
                            ),
                            _ToursTab(
                              tours: filteredTours,
                              provider: provider,
                              hasQuery: _query.isNotEmpty,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _matchesCity(City city) {
    if (_query.isEmpty) return true;
    return city.name.toLowerCase().contains(_query) ||
        city.country.toLowerCase().contains(_query) ||
        city.continent.toLowerCase().contains(_query);
  }

  bool _matchesPlace(Place place) {
    if (_query.isEmpty) return true;
    return place.name.toLowerCase().contains(_query) ||
        place.category.toLowerCase().contains(_query) ||
        place.address.toLowerCase().contains(_query);
  }

  bool _matchesTour(Tour tour) {
    if (_query.isEmpty) return true;
    return tour.title.toLowerCase().contains(_query) ||
        tour.duration.toLowerCase().contains(_query) ||
        tour.difficulty.toLowerCase().contains(_query);
  }
}

class _FavoritesHeader extends StatelessWidget {
  final int total;
  final int citiesCount;
  final int placesCount;
  final int toursCount;

  const _FavoritesHeader({
    required this.total,
    required this.citiesCount,
    required this.placesCount,
    required this.toursCount,
  });

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
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saved',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  total == 0
                      ? 'Build your travel library'
                      : '$total saved travel picks',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          _HeaderMetric(
              value: citiesCount,
              label: 'Cities',
              icon: Icons.location_city_rounded),
          _HeaderMetric(
              value: placesCount, label: 'Places', icon: Icons.place_rounded),
          _HeaderMetric(
              value: toursCount, label: 'Tours', icon: Icons.route_rounded),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;

  const _HeaderMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 5),
          Text(
            '$value',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesSearch extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _FavoritesSearch({
    required this.controller,
    required this.enabled,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search saved items...',
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: onClear,
                icon:
                    const Icon(Icons.close_rounded, color: AppColors.textHint),
              ),
      ),
    );
  }
}

class _FavoritesTabs extends StatelessWidget {
  final TabController controller;
  final int citiesCount;
  final int placesCount;
  final int toursCount;

  const _FavoritesTabs({
    required this.controller,
    required this.citiesCount,
    required this.placesCount,
    required this.toursCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.divider),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(11),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textHint,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        dividerColor: Colors.transparent,
        tabs: [
          _favoriteTab('Cities', citiesCount),
          _favoriteTab('Places', placesCount),
          _favoriteTab('Tours', toursCount),
        ],
      ),
    );
  }
}

Tab _favoriteTab(String label, int count) {
  return Tab(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        if (count > 0) ...[
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ],
    ),
  );
}

class _CitiesTab extends StatelessWidget {
  final List<City> cities;
  final TravelProvider provider;
  final bool hasQuery;

  const _CitiesTab({
    required this.cities,
    required this.provider,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return _EmptyTabState(label: 'cities', hasQuery: hasQuery);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
      physics: const BouncingScrollPhysics(),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return FadeInUp(
          delay: Duration(milliseconds: 45 * index),
          child: Dismissible(
            key: ValueKey('city-${city.id}'),
            direction: DismissDirection.endToStart,
            background: const _DismissBackground(),
            onDismissed: (_) => _removeCity(context, city),
            child: _CityFavCard(
              city: city,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CityDetailsScreen(city: city)),
              ),
              onRemove: () => _removeCity(context, city),
            ),
          ),
        );
      },
    );
  }

  void _removeCity(BuildContext context, City city) {
    HapticFeedback.mediumImpact();
    provider.toggleCityFavorite(city);
    ScaffoldMessenger.of(context).showSnackBar(
      _removedSnack(
        city.name,
        onUndo: () => provider.toggleCityFavorite(city),
      ),
    );
  }
}

class _PlacesTab extends StatelessWidget {
  final List<Place> places;
  final TravelProvider provider;
  final bool hasQuery;

  const _PlacesTab({
    required this.places,
    required this.provider,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return _EmptyTabState(label: 'places', hasQuery: hasQuery);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
      physics: const BouncingScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return FadeInUp(
          delay: Duration(milliseconds: 45 * index),
          child: Dismissible(
            key: ValueKey('place-${place.id}'),
            direction: DismissDirection.endToStart,
            background: const _DismissBackground(),
            onDismissed: (_) => _removePlace(context, place),
            child: _GenericFavCard(
              title: place.name,
              subtitle: place.category,
              extra:
                  '${place.rating.toStringAsFixed(1)} rating / ${place.address}',
              imageUrl: place.imageUrl,
              color: AppColors.categoryColor(place.category),
              icon: Icons.place_rounded,
              onRemove: () => _removePlace(context, place),
            ),
          ),
        );
      },
    );
  }

  void _removePlace(BuildContext context, Place place) {
    HapticFeedback.mediumImpact();
    provider.togglePlaceFavorite(place);
    ScaffoldMessenger.of(context).showSnackBar(
      _removedSnack(
        place.name,
        onUndo: () => provider.togglePlaceFavorite(place),
      ),
    );
  }
}

class _ToursTab extends StatelessWidget {
  final List<Tour> tours;
  final TravelProvider provider;
  final bool hasQuery;

  const _ToursTab({
    required this.tours,
    required this.provider,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) {
      return _EmptyTabState(label: 'tours', hasQuery: hasQuery);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 88),
      physics: const BouncingScrollPhysics(),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return FadeInUp(
          delay: Duration(milliseconds: 45 * index),
          child: Dismissible(
            key: ValueKey('tour-${tour.id}'),
            direction: DismissDirection.endToStart,
            background: const _DismissBackground(),
            onDismissed: (_) => _removeTour(context, tour),
            child: _GenericFavCard(
              title: tour.title,
              subtitle: tour.duration,
              extra: '${tour.priceDisplay} / ${tour.difficulty}',
              imageUrl: tour.imageUrl,
              color: AppColors.accent,
              icon: Icons.route_rounded,
              onRemove: () => _removeTour(context, tour),
            ),
          ),
        );
      },
    );
  }

  void _removeTour(BuildContext context, Tour tour) {
    HapticFeedback.mediumImpact();
    provider.toggleTourFavorite(tour);
    ScaffoldMessenger.of(context).showSnackBar(
      _removedSnack(
        tour.title,
        onUndo: () => provider.toggleTourFavorite(tour),
      ),
    );
  }
}

class _CityFavCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _CityFavCard({
    required this.city,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 340;
    return _FavoriteShell(
      onTap: onTap,
      imageUrl: city.imageUrl,
      imageSize: compact ? 82 : 112,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            city.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${city.country} / ${city.continent}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textHint, fontSize: 12),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: AppColors.starColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                city.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              if (!compact)
                const Flexible(
                  child: _MiniBadge(label: 'Explore', color: AppColors.primary),
                ),
            ],
          ),
        ],
      ),
      onRemove: onRemove,
    );
  }
}

class _GenericFavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String extra;
  final String imageUrl;
  final Color color;
  final IconData icon;
  final VoidCallback onRemove;

  const _GenericFavCard({
    required this.title,
    required this.subtitle,
    required this.extra,
    required this.imageUrl,
    required this.color,
    required this.icon,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 340;
    return _FavoriteShell(
      imageUrl: imageUrl,
      imageSize: compact ? 82 : 100,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            extra,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onRemove: onRemove,
    );
  }
}

class _FavoriteShell extends StatelessWidget {
  final String imageUrl;
  final double imageSize;
  final Widget content;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const _FavoriteShell({
    required this.imageUrl,
    required this.imageSize,
    required this.content,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: imageSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(19)),
              child: AppImage(
                imageUrl: imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  imageSize < 90 ? 10 : 14,
                  10,
                  6,
                  10,
                ),
                child: content,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: imageSize < 90 ? 6 : 12),
              child: IconButton(
                tooltip: 'Remove from saved',
                onPressed: onRemove,
                icon: const Icon(Icons.favorite_rounded,
                    color: Colors.red, size: 19),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.08),
                  fixedSize: Size.square(imageSize < 90 ? 34 : 38),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
          SizedBox(height: 4),
          Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLibraryState extends StatelessWidget {
  const _EmptyLibraryState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded,
                size: 58, color: AppColors.primary),
            SizedBox(height: 22),
            Text(
              'Nothing saved yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 9),
            Text(
              'Tap the heart on cities, places and tours to build a personal travel library.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTabState extends StatelessWidget {
  final String label;
  final bool hasQuery;

  const _EmptyTabState({
    required this.label,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasQuery
                  ? Icons.search_off_rounded
                  : Icons.bookmark_border_rounded,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 14),
            Text(
              hasQuery ? 'No matching $label' : 'No saved $label',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              hasQuery
                  ? 'Try another search term.'
                  : 'Save $label to see them here.',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: AppColors.textSecondary, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

SnackBar _removedSnack(String name, {required VoidCallback onUndo}) {
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '$name removed',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    action: SnackBarAction(
      label: 'Undo',
      textColor: Colors.white,
      onPressed: onUndo,
    ),
    backgroundColor: Colors.red.shade700,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
  );
}
