import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';
import '../city/city_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  City? _selectedCity;
  bool _showPlaces = false;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  List<City> get _filteredCities => cities.where((c) =>
  c.name.toLowerCase().contains(_searchText.toLowerCase()) ||
      c.country.toLowerCase().contains(_searchText.toLowerCase())).toList();

  List<Place> get _selectedPlaces =>
      _selectedCity == null ? [] : places.where((p) => p.cityId == _selectedCity!.id).toList();

  void _flyToCity(City city) {
    if (city.lat == null || city.lng == null) return;
    setState(() {
      _selectedCity = city;
      _showPlaces = true;
    });
    _animatedMapMove(LatLng(city.lat!, city.lng!), 13.0);
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── FULL-SCREEN MAP ──────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(30.0, 20.0),
              initialZoom: 2.5,
              minZoom: 2.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.tourconnect',
              ),
              // City markers
              MarkerLayer(
                markers: cities.where((c) => c.lat != null).map((city) {
                  final isSelected = _selectedCity?.id == city.id;
                  return Marker(
                    point: LatLng(city.lat!, city.lng!),
                    width: isSelected ? 130 : 44,
                    height: 44,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () => _flyToCity(city),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: isSelected
                            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                            : const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(isSelected ? 22 : 50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: isSelected
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(city.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        )
                            : const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Place markers when city selected
              if (_showPlaces && _selectedCity != null)
                MarkerLayer(
                  markers: _selectedPlaces.where((p) => p.lat != null).map((place) {
                    return Marker(
                      point: LatLng(place.lat!, place.lng!),
                      width: 36,
                      height: 36,
                      child: GestureDetector(
                        onTap: () => _showPlaceCard(place),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.categoryColor(place.category),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(0, 2))
                            ],
                          ),
                          child: const Icon(Icons.place_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),

          // ── TOP SEARCH BAR ───────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 20, offset: const Offset(0, 6))
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchText = v),
                    decoration: InputDecoration(
                      hintText: 'Search city or country…',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                      suffixIcon: _searchText.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchText = '');
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                if (_searchText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredCities.length,
                      separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 56),
                      itemBuilder: (context, i) {
                        final city = _filteredCities[i];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_city_rounded,
                                color: AppColors.primary, size: 20),
                          ),
                          title: Text(city.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          subtitle: Text(city.country,
                              style: const TextStyle(
                                  color: AppColors.textHint, fontSize: 12)),
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchText = '');
                            _flyToCity(city);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── BOTTOM CITY CARDS ────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selected city detail banner
                if (_selectedCity != null)
                  _SelectedCityBanner(
                    city: _selectedCity!,
                    places: _selectedPlaces,
                    onClose: () => setState(() {
                      _selectedCity = null;
                      _showPlaces = false;
                    }),
                    onExplore: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CityDetailsScreen(city: _selectedCity!)),
                    ),
                  ),
                // Horizontal city list
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
                  child: Text('Destinations',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                          shadows: [
                            Shadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 6)
                          ])),
                ),
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: cities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final isSelected = _selectedCity?.id == city.id;
                      return GestureDetector(
                        onTap: () => _flyToCity(city),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 130,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: isSelected
                                ? null
                                : Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.location_on_rounded,
                                    color: isSelected ? Colors.white : AppColors.primary,
                                    size: 18),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(city.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: isSelected ? Colors.white : AppColors.textPrimary)),
                                    Text(city.country,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: isSelected
                                                ? Colors.white.withValues(alpha: 0.7)
                                                : AppColors.textHint)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── TOP-RIGHT CONTROLS ────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 74,
            right: 16,
            child: Column(
              children: [
                _MapButton(
                  icon: Icons.add_rounded,
                  onTap: () {
                    final z = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, z + 1);
                  },
                ),
                const SizedBox(height: 8),
                _MapButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    final z = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, z - 1);
                  },
                ),
                const SizedBox(height: 8),
                _MapButton(
                  icon: Icons.public_rounded,
                  onTap: () => _animatedMapMove(const LatLng(30.0, 20.0), 2.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceCard(Place place) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.categoryColor(place.category).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(place.category,
                    style: TextStyle(
                        color: AppColors.categoryColor(place.category),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              Icon(Icons.star_rounded, color: AppColors.starColor, size: 16),
              const SizedBox(width: 4),
              Text(place.rating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
            const SizedBox(height: 12),
            Text(place.name,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(place.description,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(place.address,
                  style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Subwidgets ────────────────────────────────────────────────────────────────

class _SelectedCityBanner extends StatelessWidget {
  final City city;
  final List<Place> places;
  final VoidCallback onClose;
  final VoidCallback onExplore;

  const _SelectedCityBanner(
      {required this.city, required this.places, required this.onClose, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 20, offset: const Offset(0, -4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(city.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text('${city.country} · ${city.continent}',
                        style: const TextStyle(color: AppColors.textHint, fontSize: 13)),
                  ],
                ),
              ),
              Row(children: [
                const Icon(Icons.star_rounded, color: AppColors.starColor, size: 16),
                const SizedBox(width: 4),
                Text(city.rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, size: 16, color: AppColors.textHint),
                ),
              ),
            ],
          ),
          if (places.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: places.take(4).map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.categoryColor(p.category).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.categoryColor(p.category).withValues(alpha: 0.3)),
                ),
                child: Text(p.name,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.categoryColor(p.category))),
              )).toList(),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onExplore,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: const Text('Explore City', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10, offset: const Offset(0, 3))
          ],
        ),
        child: Icon(icon, size: 22, color: AppColors.textPrimary),
      ),
    );
  }
}
