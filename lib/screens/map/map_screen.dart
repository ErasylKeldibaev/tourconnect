import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/travel_provider.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';
import '../../widgets/app_image.dart';
import '../city/city_details_screen.dart';
import '../trip_planner/trip_planner_screen.dart';

class MapScreen extends StatefulWidget {
  final City? initialCity;

  const MapScreen({super.key, this.initialCity});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

enum _TileStyle {
  standard(
    label: 'Standard',
    template: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    subdomains: const [],
  ),
  light(
    label: 'Light',
    template:
        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
    subdomains: const ['a', 'b', 'c', 'd'],
  ),
  voyager(
    label: 'Voyager',
    template:
        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    subdomains: const ['a', 'b', 'c', 'd'],
  );

  final String label;
  final String template;
  final List<String> subdomains;

  const _TileStyle({
    required this.label,
    required this.template,
    required this.subdomains,
  });

  _TileStyle get next {
    final all = _TileStyle.values;
    return all[(index + 1) % all.length];
  }
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  AnimationController? _moveController;

  City? _selectedCity;
  Place? _selectedPlace;
  String _query = '';
  String _category = 'All';
  bool _showPlaces = true;
  bool _isCityPanelCollapsed = false;
  _TileStyle _tileStyle = _TileStyle.standard;

  static const _worldCenter = LatLng(25, 30);

  @override
  void initState() {
    super.initState();
    final initialCity = widget.initialCity;
    if (initialCity != null) {
      _selectedCity = initialCity;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpToCity(initialCity, animated: false);
      });
    }
  }

  @override
  void dispose() {
    _moveController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<City> get _citiesWithCoords =>
      cities.where((city) => city.lat != null && city.lng != null).toList();

  List<City> get _cityResults {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return _citiesWithCoords
        .where(
          (city) =>
              city.name.toLowerCase().contains(query) ||
              city.country.toLowerCase().contains(query) ||
              city.continent.toLowerCase().contains(query) ||
              city.tags.any((tag) => tag.toLowerCase().contains(query)),
        )
        .take(6)
        .toList();
  }

  List<Place> get _placeResults {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return places
        .where((place) => place.lat != null && place.lng != null)
        .where(
          (place) =>
              place.name.toLowerCase().contains(query) ||
              place.category.toLowerCase().contains(query) ||
              place.address.toLowerCase().contains(query),
        )
        .take(6)
        .toList();
  }

  List<Place> get _cityPlaces {
    final city = _selectedCity;
    if (city == null) return const [];

    final result = places
        .where((place) => place.cityId == city.id)
        .where((place) => place.lat != null && place.lng != null)
        .where((place) => _category == 'All' || place.category == _category)
        .toList();

    result.sort((a, b) {
      if (a.isPopular != b.isPopular) return a.isPopular ? -1 : 1;
      final rating = b.rating.compareTo(a.rating);
      if (rating != 0) return rating;
      return b.reviewCount.compareTo(a.reviewCount);
    });
    return result;
  }

  List<String> get _categories {
    final city = _selectedCity;
    if (city == null) return const ['All'];
    final values = places
        .where((place) => place.cityId == city.id)
        .map((place) => place.category)
        .toSet()
        .toList()
      ..sort();
    return ['All', ...values];
  }

  City? _cityForPlace(Place place) {
    for (final city in cities) {
      if (city.id == place.cityId) return city;
    }
    return null;
  }

  void _selectCity(City city) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCity = city;
      _selectedPlace = null;
      _category = 'All';
      _showPlaces = true;
      _isCityPanelCollapsed = false;
      _query = '';
      _searchController.clear();
    });
    _jumpToCity(city);
  }

  void _selectPlace(Place place) {
    final city = _cityForPlace(place);
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCity = city;
      _selectedPlace = place;
      _category = place.category;
      _showPlaces = true;
      _isCityPanelCollapsed = false;
      _query = '';
      _searchController.clear();
    });
    _moveTo(LatLng(place.lat!, place.lng!), 15.5);
  }

  void _jumpToCity(City city, {bool animated = true}) {
    final point = LatLng(city.lat!, city.lng!);
    if (animated) {
      _moveTo(point, 12.3);
    } else {
      _mapController.move(point, 12.3);
    }
  }

  void _moveTo(LatLng target, double zoom) {
    _moveController?.dispose();

    final camera = _mapController.camera;
    final lat = Tween<double>(
      begin: camera.center.latitude,
      end: target.latitude,
    );
    final lng = Tween<double>(
      begin: camera.center.longitude,
      end: target.longitude,
    );
    final zoomTween = Tween<double>(
      begin: camera.zoom,
      end: zoom.clamp(2.0, 17.0).toDouble(),
    );

    final controller = AnimationController(
      duration: const Duration(milliseconds: 520),
      vsync: this,
    );
    _moveController = controller;
    final curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    controller.addListener(() {
      _mapController.move(
        LatLng(lat.evaluate(curve), lng.evaluate(curve)),
        zoomTween.evaluate(curve),
      );
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (_moveController == controller) _moveController = null;
        controller.dispose();
      }
    });
    controller.forward();
  }

  void _resetMap() {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedCity = null;
      _selectedPlace = null;
      _category = 'All';
      _showPlaces = true;
      _isCityPanelCollapsed = false;
      _query = '';
      _searchController.clear();
    });
    _moveTo(_worldCenter, 2.4);
  }

  void _zoomBy(double delta) {
    final camera = _mapController.camera;
    _moveTo(camera.center, camera.zoom + delta);
  }

  Future<void> _openDirectionsToPlace(Place place) async {
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${place.lat},${place.lng}',
    });
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openPlanRoute(List<Place> routePlaces) async {
    final points = routePlaces
        .where((place) => place.lat != null && place.lng != null)
        .toList();
    if (points.length < 2) return;

    final waypoints = points.length > 2
        ? points
            .sublist(1, points.length - 1)
            .map((place) => '${place.lat},${place.lng}')
            .join('|')
        : '';

    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'origin': '${points.first.lat},${points.first.lng}',
      'destination': '${points.last.lat},${points.last.lng}',
      if (waypoints.isNotEmpty) 'waypoints': waypoints,
    });
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final strings = context.strings;
    final panelIsCollapsed = _selectedCity != null && _isCityPanelCollapsed;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _InstantMapBackdrop(),
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _worldCenter,
              initialZoom: 2.4,
              minZoom: 2,
              maxZoom: 17,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                key: ValueKey(_tileStyle),
                urlTemplate: _tileStyle.template,
                subdomains: _tileStyle.subdomains,
                userAgentPackageName: 'com.example.tourconnect',
                maxNativeZoom: 18,
              ),
              _buildPlanLayer(),
              MarkerLayer(markers: _buildCityMarkers()),
              if (_showPlaces) MarkerLayer(markers: _buildPlaceMarkers()),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                children: [
                  _SearchPanel(
                    controller: _searchController,
                    query: _query,
                    strings: strings,
                    cityResults: _cityResults,
                    placeResults: _placeResults,
                    onChanged: (value) => setState(() => _query = value),
                    onClear: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    onCityTap: _selectCity,
                    onPlaceTap: _selectPlace,
                  ),
                  const SizedBox(height: 10),
                  _TopChips(
                    styleLabel: _tileStyle.label,
                    strings: strings,
                    selectedCity: _selectedCity,
                    selectedCategory: _category,
                    categories: _categories,
                    onCategory: (value) => setState(() => _category = value),
                    onStyle: () {
                      HapticFeedback.selectionClick();
                      setState(() => _tileStyle = _tileStyle.next);
                    },
                    onTogglePlaces: _selectedCity == null
                        ? null
                        : () => setState(() => _showPlaces = !_showPlaces),
                    showPlaces: _showPlaces,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: math.max(
              bottomInset + (panelIsCollapsed ? 150 : 280),
              panelIsCollapsed ? 150 : 280,
            ),
            child: _MapButtons(
              onZoomIn: () => _zoomBy(1),
              onZoomOut: () => _zoomBy(-1),
              onReset: _resetMap,
              onTopCity: () => _selectCity(_topRatedCity()),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: bottomInset + 104,
            child: _BottomMapPanel(
              strings: strings,
              selectedCity: _selectedCity,
              selectedPlace: _selectedPlace,
              collapsed: _isCityPanelCollapsed,
              places: _cityPlaces,
              onCity: _selectCity,
              onPlace: _selectPlace,
              onClose: _resetMap,
              onToggleCollapsed: () {
                HapticFeedback.selectionClick();
                setState(() => _isCityPanelCollapsed = !_isCityPanelCollapsed);
              },
              onDetails: _selectedCity == null
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CityDetailsScreen(city: _selectedCity!),
                        ),
                      ),
              onPlanner: _selectedCity == null
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TripPlannerScreen(city: _selectedCity!),
                        ),
                      ),
              onDirections: _selectedPlace == null
                  ? null
                  : () => _openDirectionsToPlace(_selectedPlace!),
              onPlanRoute: (routePlaces) => _openPlanRoute(routePlaces),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanLayer() {
    final city = _selectedCity;
    if (city == null) return const SizedBox.shrink();

    return Consumer<TravelProvider>(
      builder: (context, provider, child) {
        final routePlaces = provider
            .getPlanForCity(city.id)
            .where((place) => place.lat != null && place.lng != null)
            .toList();

        if (routePlaces.length < 2) return const SizedBox.shrink();

        return Stack(
          children: [
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePlaces
                      .map((place) => LatLng(place.lat!, place.lng!))
                      .toList(),
                  color: AppColors.primary,
                  strokeWidth: 5,
                  borderColor: Colors.white,
                  borderStrokeWidth: 2,
                ),
              ],
            ),
            MarkerLayer(
              markers: List.generate(routePlaces.length, (index) {
                final place = routePlaces[index];
                return Marker(
                  point: LatLng(place.lat!, place.lng!),
                  width: 34,
                  height: 34,
                  child: _RouteMarker(number: index + 1),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  List<Marker> _buildCityMarkers() {
    return _citiesWithCoords.map((city) {
      final selected = _selectedCity?.id == city.id;
      return Marker(
        point: LatLng(city.lat!, city.lng!),
        width: selected ? 122 : 58,
        height: 54,
        child: _CityMarker(
          city: city,
          selected: selected,
          onTap: () => _selectCity(city),
        ),
      );
    }).toList();
  }

  List<Marker> _buildPlaceMarkers() {
    final city = _selectedCity;
    if (city == null) return const [];

    return _cityPlaces.map((place) {
      final selected = _selectedPlace?.id == place.id;
      return Marker(
        point: LatLng(place.lat!, place.lng!),
        width: selected ? 50 : 42,
        height: selected ? 50 : 42,
        child: _PlaceMarker(
          place: place,
          selected: selected,
          onTap: () => _selectPlace(place),
        ),
      );
    }).toList();
  }

  City _topRatedCity() {
    final sorted = [..._citiesWithCoords]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.first;
  }
}

class _InstantMapBackdrop extends StatelessWidget {
  const _InstantMapBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _MapBackdropPainter(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.accent.withValues(alpha: 0.08),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final water = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final road = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawOval(
      Rect.fromLTWH(-size.width * 0.15, size.height * 0.12,
          size.width * 0.72, size.height * 0.28),
      water,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.52, size.height * 0.56,
          size.width * 0.62, size.height * 0.32),
      water,
    );

    for (var i = -2; i < 8; i++) {
      final y = size.height * (0.12 + i * 0.13);
      canvas.drawLine(Offset(-20, y), Offset(size.width + 20, y + 90), road);
    }
    for (var i = -1; i < 7; i++) {
      final x = size.width * (0.08 + i * 0.17);
      canvas.drawLine(Offset(x, -20), Offset(x + 80, size.height + 20), road);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SearchPanel extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final AppStrings strings;
  final List<City> cityResults;
  final List<Place> placeResults;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<City> onCityTap;
  final ValueChanged<Place> onPlaceTap;

  const _SearchPanel({
    required this.controller,
    required this.query,
    required this.strings,
    required this.cityResults,
    required this.placeResults,
    required this.onChanged,
    required this.onClear,
    required this.onCityTap,
    required this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasResults = cityResults.isNotEmpty || placeResults.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GlassBox(
          radius: 18,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: strings.searchMapHint,
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: strings.clearSearch,
                      onPressed: onClear,
                      icon: const Icon(Icons.close_rounded),
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        if (hasResults)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 310),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.13),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                for (final city in cityResults)
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.location_city_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      city.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text('${city.country} / ${city.continent}'),
                    onTap: () => onCityTap(city),
                  ),
                for (final place in placeResults)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      _placeIcon(place.category),
                      color: AppColors.categoryColor(place.category),
                    ),
                    title: Text(
                      place.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(place.address),
                    onTap: () => onPlaceTap(place),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TopChips extends StatelessWidget {
  final String styleLabel;
  final AppStrings strings;
  final City? selectedCity;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategory;
  final VoidCallback onStyle;
  final VoidCallback? onTogglePlaces;
  final bool showPlaces;

  const _TopChips({
    required this.styleLabel,
    required this.strings,
    required this.selectedCity,
    required this.selectedCategory,
    required this.categories,
    required this.onCategory,
    required this.onStyle,
    required this.onTogglePlaces,
    required this.showPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: selectedCity == null ? 38 : 82,
      child: Column(
        children: [
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _ActionChipButton(
                  icon: Icons.layers_rounded,
                  label: styleLabel,
                  onTap: onStyle,
                ),
                const SizedBox(width: 8),
                if (onTogglePlaces != null)
                  _ActionChipButton(
                    icon: showPlaces
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    label: showPlaces ? strings.sights : strings.hidden,
                    onTap: onTogglePlaces!,
                  ),
              ],
            ),
          ),
          if (selectedCity != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected = category == selectedCategory;
                  return GestureDetector(
                    onTap: () => onCategory(category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? AppColors.primary : Colors.white,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category == 'All'
                            ? (strings.isRu ? 'Все' : 'All')
                            : category,
                        style: TextStyle(
                          color:
                              selected ? Colors.white : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _GlassBox(
        radius: 14,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 17),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapButtons extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;
  final VoidCallback onTopCity;

  const _MapButtons({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
    required this.onTopCity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoundButton(
          icon: Icons.add_rounded,
          tooltip: 'Zoom in',
          onTap: onZoomIn,
        ),
        const SizedBox(height: 8),
        _RoundButton(
          icon: Icons.remove_rounded,
          tooltip: 'Zoom out',
          onTap: onZoomOut,
        ),
        const SizedBox(height: 8),
        _RoundButton(
          icon: Icons.auto_awesome_rounded,
          tooltip: 'Top city',
          onTap: onTopCity,
        ),
        const SizedBox(height: 8),
        _RoundButton(
          icon: Icons.public_rounded,
          tooltip: 'Reset map',
          onTap: onReset,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: _GlassBox(
          radius: 16,
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(icon, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _BottomMapPanel extends StatelessWidget {
  final AppStrings strings;
  final City? selectedCity;
  final Place? selectedPlace;
  final bool collapsed;
  final List<Place> places;
  final ValueChanged<City> onCity;
  final ValueChanged<Place> onPlace;
  final VoidCallback onClose;
  final VoidCallback onToggleCollapsed;
  final VoidCallback? onDetails;
  final VoidCallback? onPlanner;
  final VoidCallback? onDirections;
  final ValueChanged<List<Place>> onPlanRoute;

  const _BottomMapPanel({
    required this.strings,
    required this.selectedCity,
    required this.selectedPlace,
    required this.collapsed,
    required this.places,
    required this.onCity,
    required this.onPlace,
    required this.onClose,
    required this.onToggleCollapsed,
    required this.onDetails,
    required this.onPlanner,
    required this.onDirections,
    required this.onPlanRoute,
  });

  @override
  Widget build(BuildContext context) {
    final city = selectedCity;
    if (city == null) {
      return _OverviewPanel(strings: strings, onCity: onCity);
    }

    if (collapsed) {
      return _CollapsedCityPanel(
        city: city,
        strings: strings,
        placesCount: places.length,
        onExpand: onToggleCollapsed,
        onClose: onClose,
      );
    }

    return _GlassBox(
      radius: 24,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AppImage(
                    imageUrl: city.imageUrl,
                    width: 64,
                    height: 64,
                    borderRadius: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        city.country,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.starColor,
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            city.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            strings.sightsCount(places.length),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: strings.close,
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
                IconButton(
                  tooltip: strings.isRu ? 'Свернуть' : 'Collapse',
                  onPressed: onToggleCollapsed,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer<TravelProvider>(
              builder: (context, provider, child) {
                final routePlaces = provider.getPlanForCity(city.id);
                return Row(
                  children: [
                    Expanded(
                      child: _PanelActionButton(
                        icon: const Icon(Icons.info_outline_rounded),
                        label: strings.details,
                        onTap: onDetails,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PanelActionButton(
                        icon: const Icon(Icons.route_rounded),
                        label: strings.plan,
                        badge: routePlaces.isEmpty ? null : '${routePlaces.length}',
                        onTap: onPlanner,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PanelActionButton(
                        icon: const Icon(Icons.directions_rounded),
                        label: strings.route,
                        filled: routePlaces.length >= 2,
                        onTap: routePlaces.length < 2
                            ? null
                            : () => onPlanRoute(routePlaces),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (places.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: places.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return _PlaceCard(
                      place: place,
                      selected: selectedPlace?.id == place.id,
                      onTap: () => onPlace(place),
                    );
                  },
                ),
              ),
            ],
            if (selectedPlace != null) ...[
              const SizedBox(height: 12),
              _SelectedPlaceBar(
                place: selectedPlace!,
                strings: strings,
                onDirections: onDirections,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CollapsedCityPanel extends StatelessWidget {
  final City city;
  final AppStrings strings;
  final int placesCount;
  final VoidCallback onExpand;
  final VoidCallback onClose;

  const _CollapsedCityPanel({
    required this.city,
    required this.strings,
    required this.placesCount,
    required this.onExpand,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      radius: 22,
      color: Colors.white,
      child: InkWell(
        onTap: onExpand,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AppImage(
                  imageUrl: city.imageUrl,
                  width: 48,
                  height: 48,
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.starColor,
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          city.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            strings.sightsCount(placesCount),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: strings.isRu ? 'Раскрыть' : 'Expand',
                onPressed: onExpand,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  foregroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
              IconButton(
                tooltip: strings.close,
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;
  final bool filled;

  const _PanelActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final foreground = filled
        ? Colors.white
        : enabled
            ? AppColors.primary
            : AppColors.textHint;
    final background = filled
        ? AppColors.primary
        : enabled
            ? Colors.white
            : AppColors.inputFill;

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: filled ? AppColors.primary : AppColors.divider,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconTheme(
                    data: IconThemeData(color: foreground, size: 19),
                    child: icon,
                  ),
                  if (badge != null)
                    Positioned(
                      top: -8,
                      right: -10,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: foreground,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewPanel extends StatelessWidget {
  final AppStrings strings;
  final ValueChanged<City> onCity;

  const _OverviewPanel({required this.strings, required this.onCity});

  @override
  Widget build(BuildContext context) {
    final topCities = [...cities]
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return _GlassBox(
      radius: 24,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.travel_explore_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.exploreMap,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        strings.mapQuickStart,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _Metric(label: strings.cities, value: '${cities.length}'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Metric(label: strings.sights, value: '${places.length}'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Metric(label: strings.tours, value: '${tours.length}'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: math.min(6, topCities.length),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final city = topCities[index];
                  return ActionChip(
                    avatar: const Icon(Icons.place_rounded, size: 16),
                    label: Text(city.name),
                    onPressed: () => onCity(city),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Place place;
  final bool selected;
  final VoidCallback onTap;

  const _PlaceCard({
    required this.place,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColor(place.category);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 238,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                imageUrl: place.imageUrl,
                width: 48,
                height: 48,
                borderRadius: 12,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(_placeIcon(place.category), color: color, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.starColor,
                        size: 13,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedPlaceBar extends StatelessWidget {
  final Place place;
  final AppStrings strings;
  final VoidCallback? onDirections;

  const _SelectedPlaceBar({
    required this.place,
    required this.strings,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            _placeIcon(place.category),
            color: AppColors.accent,
            size: 20,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  place.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: onDirections,
            icon: const Icon(Icons.directions_rounded, size: 18),
            label: Text(strings.go),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _CityMarker extends StatelessWidget {
  final City city;
  final bool selected;
  final VoidCallback onTap;

  const _CityMarker({
    required this.city,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: selected ? 10 : 0),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          shape: selected ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: selected ? BorderRadius.circular(999) : null,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: selected
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_city_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      city.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              )
            : const Icon(Icons.location_city_rounded, color: AppColors.primary),
      ),
    );
  }
}

class _PlaceMarker extends StatelessWidget {
  final Place place;
  final bool selected;
  final VoidCallback onTap;

  const _PlaceMarker({
    required this.place,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColor(place.category);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.12 : 1,
        duration: const Duration(milliseconds: 180),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.38),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            _placeIcon(place.category),
            color: selected ? Colors.white : color,
            size: selected ? 23 : 20,
          ),
        ),
      ),
    );
  }
}

class _RouteMarker extends StatelessWidget {
  final int number;

  const _RouteMarker({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color? color;

  const _GlassBox({
    required this.child,
    required this.radius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

IconData _placeIcon(String category) {
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
