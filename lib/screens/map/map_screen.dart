import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';
import '../city/city_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openRoute(double lat, double lng) async {
  final url = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
  );
  await launchUrl(url, mode: LaunchMode.externalApplication);
}

// Категории для фильтра
const List<String> _allCategories = [
  'All', 'Sightseeing', 'Nature', 'Food', 'History', 'Shopping', 'Adventure',
];

const Map<String, IconData> _categoryIcons = {
  'All': Icons.apps_rounded,
  'Sightseeing': Icons.photo_camera_rounded,
  'Nature': Icons.park_rounded,
  'Food': Icons.restaurant_rounded,
  'History': Icons.account_balance_rounded,
  'Shopping': Icons.shopping_bag_rounded,
  'Adventure': Icons.terrain_rounded,
};

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  City? _selectedCity;
  Place? _selectedPlace;
  bool _showPlaces = false;
  String _searchText = '';
  String _activeCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Бишкек — "Мой город" (первый в списке)
  final City _myCity = cities.first;

  List<City> get _filteredCities => cities
      .where((c) =>
  c.name.toLowerCase().contains(_searchText.toLowerCase()) ||
      c.country.toLowerCase().contains(_searchText.toLowerCase()))
      .toList();

  List<Place> get _selectedPlaces {
    if (_selectedCity == null) return [];
    final all = places.where((p) => p.cityId == _selectedCity!.id).toList();
    if (_activeCategory == 'All') return all;
    return all.where((p) => p.category == _activeCategory).toList();
  }

  void _flyToCity(City city) {
    if (city.lat == null || city.lng == null) return;
    setState(() {
      _selectedCity = city;
      _selectedPlace = null;
      _showPlaces = true;
      _activeCategory = 'All';
    });
    _animatedMapMove(LatLng(city.lat!, city.lng!), 13.0);
  }

  void _flyToPlace(Place place) {
    if (place.lat == null || place.lng == null) return;
    setState(() => _selectedPlace = place);
    _animatedMapMove(LatLng(place.lat!, place.lng!), 16.0);
    _showPlaceCard(place);
  }

  void _animatedMapMove(LatLng dest, double zoom) {
    final camera = _mapController.camera;
    final latT = Tween<double>(begin: camera.center.latitude, end: dest.latitude);
    final lngT = Tween<double>(begin: camera.center.longitude, end: dest.longitude);
    final zoomT = Tween<double>(begin: camera.zoom, end: zoom);

    final ctrl = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    final anim = CurvedAnimation(parent: ctrl, curve: Curves.easeInOut);

    ctrl.addListener(() {
      _mapController.move(
        LatLng(latT.evaluate(anim), lngT.evaluate(anim)),
        zoomT.evaluate(anim),
      );
    });
    ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        ctrl.dispose();
      }
    });
    ctrl.forward();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Иконка маркера по категории ────────────────────────────────────
  IconData _markerIcon(String category) {
    switch (category) {
      case 'Nature':     return Icons.park_rounded;
      case 'Food':       return Icons.restaurant_rounded;
      case 'History':    return Icons.account_balance_rounded;
      case 'Shopping':   return Icons.shopping_bag_rounded;
      case 'Adventure':  return Icons.terrain_rounded;
      default:           return Icons.photo_camera_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          // ── КАРТА ────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(30.0, 20.0),
              initialZoom: 2.5,
              minZoom: 2.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.tourconnect',
              ),

              // Маркеры городов
              MarkerLayer(
                markers: cities.where((c) => c.lat != null).map((city) {
                  final isSelected = _selectedCity?.id == city.id;
                  final isMy = city.id == _myCity.id;
                  return Marker(
                    point: LatLng(city.lat!, city.lng!),
                    width: isSelected ? 140 : 48,
                    height: 48,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () => _flyToCity(city),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: isSelected
                            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                            : const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : isMy
                              ? AppColors.accent
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(isSelected ? 22 : 50),
                          boxShadow: [
                            BoxShadow(
                              color: (isSelected
                                  ? AppColors.primary
                                  : isMy
                                  ? AppColors.accent
                                  : Colors.black)
                                  .withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                city.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        )
                            : Icon(
                          isMy
                              ? Icons.home_rounded
                              : Icons.location_on_rounded,
                          color: isSelected
                              ? Colors.white
                              : isMy
                              ? Colors.white
                              : AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Маркеры мест (цветные с иконкой)
              if (_showPlaces && _selectedCity != null)
                MarkerLayer(
                  markers: _selectedPlaces
                      .where((p) => p.lat != null)
                      .map((place) {
                    final isActive = _selectedPlace?.id == place.id;
                    final color = AppColors.categoryColor(place.category);
                    return Marker(
                      point: LatLng(place.lat!, place.lng!),
                      width: isActive ? 48 : 38,
                      height: isActive ? 48 : 38,
                      child: GestureDetector(
                        onTap: () => _flyToPlace(place),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isActive ? color : color.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white,
                                width: isActive ? 3 : 2),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: isActive ? 0.5 : 0.3),
                                blurRadius: isActive ? 14 : 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            _markerIcon(place.category),
                            color: Colors.white,
                            size: isActive ? 22 : 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),

          // ── СТРОКА ПОИСКА ─────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 72, // место под кнопки справа
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 6)),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchText = v),
                    decoration: InputDecoration(
                      hintText: 'Поиск города или страны…',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.primary),
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
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
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
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4)),
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

          // ── КНОПКИ СПРАВА ────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: Column(
              children: [
                // Мой город
                _MapButton(
                  icon: Icons.home_rounded,
                  color: AppColors.accent,
                  tooltip: 'Мой город',
                  onTap: () => _flyToCity(_myCity),
                ),
                const SizedBox(height: 8),
                // Zoom +
                _MapButton(
                  icon: Icons.add_rounded,
                  onTap: () {
                    final z = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, z + 1);
                  },
                ),
                const SizedBox(height: 8),
                // Zoom −
                _MapButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    final z = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, z - 1);
                  },
                ),
                const SizedBox(height: 8),
                // Весь мир
                _MapButton(
                  icon: Icons.public_rounded,
                  onTap: () =>
                      _animatedMapMove(const LatLng(30.0, 20.0), 2.5),
                ),
              ],
            ),
          ),

          // ── ФИЛЬТР КАТЕГОРИЙ (показывается когда город выбран) ────────
          if (_showPlaces && _selectedCity != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _allCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = _allCategories[i];
                    final isActive = cat == _activeCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _activeCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _categoryIcons[cat] ?? Icons.place_rounded,
                              size: 14,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // ── НИЖНЯЯ ЧАСТЬ ─────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Баннер выбранного города
                if (_selectedCity != null)
                  _SelectedCityBanner(
                    city: _selectedCity!,
                    places: _selectedPlaces,
                    onClose: () => setState(() {
                      _selectedCity = null;
                      _selectedPlace = null;
                      _showPlaces = false;
                      _activeCategory = 'All';
                    }),
                    onExplore: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              CityDetailsScreen(city: _selectedCity!)),
                    ),
                  ),

                // Метка "Destinations"
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16, bottom: 6, top: 8),
                  child: Text(
                    'Destinations',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                      shadows: [
                        Shadow(
                            color:
                            Colors.black.withValues(alpha: 0.4),
                            blurRadius: 6),
                      ],
                    ),
                  ),
                ),

                // Горизонтальный список городов
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: cities.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final isSelected = _selectedCity?.id == city.id;
                      final isMy = city.id == _myCity.id;
                      return GestureDetector(
                        onTap: () => _flyToCity(city),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 140,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: isSelected
                                ? null
                                : Border.all(
                                color: Colors.white
                                    .withValues(alpha: 0.6),
                                width: 1),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4)),
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
                                      ? Colors.white
                                      .withValues(alpha: 0.2)
                                      : isMy
                                      ? AppColors.accent
                                      .withValues(alpha: 0.15)
                                      : AppColors.primary
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isMy
                                      ? Icons.home_rounded
                                      : Icons.location_on_rounded,
                                  color: isSelected
                                      ? Colors.white
                                      : isMy
                                      ? AppColors.accent
                                      : AppColors.primary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    if (isMy)
                                      Text(
                                        'Мой город',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? Colors.white
                                              .withValues(alpha: 0.8)
                                              : AppColors.accent,
                                        ),
                                      ),
                                    Text(
                                      city.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      city.country,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isSelected
                                            ? Colors.white
                                            .withValues(alpha: 0.7)
                                            : AppColors.textHint,
                                      ),
                                    ),
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
        ],
      ),
    );
  }

  // ── Карточка места (bottom sheet) ─────────────────────────────────────────
  void _showPlaceCard(Place place) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
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
              // Категория + рейтинг
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.categoryColor(place.category)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _markerIcon(place.category),
                          size: 12,
                          color: AppColors.categoryColor(place.category),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          place.category,
                          style: TextStyle(
                            color: AppColors.categoryColor(place.category),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded,
                      color: AppColors.starColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    place.rating.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${place.reviewCount})',
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Название
              Text(
                place.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),

              // Описание
              Text(
                place.description,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5),
              ),
              const SizedBox(height: 10),

              // Адрес
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      place.address,
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 12),
                    ),
                  ),
                ],
              ),

              // Кнопка маршрута
              if (place.lat != null && place.lng != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => openRoute(place.lat!, place.lng!),
                    icon: const Icon(Icons.directions_rounded),
                    label: const Text(
                      'Построить маршрут',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding:
                      const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── _SelectedCityBanner ───────────────────────────────────────────────────────

class _SelectedCityBanner extends StatelessWidget {
  final City city;
  final List<Place> places;
  final VoidCallback onClose;
  final VoidCallback onExplore;

  const _SelectedCityBanner({
    required this.city,
    required this.places,
    required this.onClose,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, -4)),
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
                    Text(
                      city.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary),
                    ),
                    Text(
                      '${city.country} · ${city.continent}',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Row(children: [
                const Icon(Icons.star_rounded,
                    color: AppColors.starColor, size: 16),
                const SizedBox(width: 4),
                Text(city.rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 16, color: AppColors.textHint),
                ),
              ),
            ],
          ),
          if (places.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: places
                  .take(4)
                  .map((p) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.categoryColor(p.category)
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.categoryColor(p.category)
                          .withValues(alpha: 0.3)),
                ),
                child: Text(
                  p.name,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                      AppColors.categoryColor(p.category)),
                ),
              ))
                  .toList(),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
              ),
              child: const Text('Explore City',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── _MapButton ────────────────────────────────────────────────────────────────

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final String? tooltip;

  const _MapButton({
    required this.icon,
    required this.onTap,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final btn = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: (color ?? Colors.black).withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Icon(
          icon,
          size: 22,
          color: color != null ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }
}