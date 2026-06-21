import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';
import '../../models/tour_model.dart';
import '../../services/supabase_data_service.dart';

typedef CatalogLoader = Future<CatalogData> Function();

class TravelProvider with ChangeNotifier {
  static const _remoteCatalogTimeout = Duration(seconds: 6);

  final CatalogLoader _catalogLoader;
  final bool _reportCatalogErrors;

  Set<String> _favoriteCityIds = {};
  Set<String> _favoritePlaceIds = {};
  Set<String> _favoriteTourIds = {};
  final Map<String, List<Place>> _cityTripPlans = {};

  bool _initialized = false;
  bool _onboardingComplete = false;
  bool _isDisposed = false;
  bool _usingRemoteCatalog = false;
  String _languageCode = 'en';
  Object? _catalogError;

  bool get initialized => _initialized;
  bool get onboardingComplete => _onboardingComplete;
  bool get usingRemoteCatalog => _usingRemoteCatalog;
  String get languageCode => _languageCode;
  Object? get catalogError => _catalogError;

  static const _keyCities = 'fav_cities';
  static const _keyPlaces = 'fav_places';
  static const _keyTours = 'fav_tours';
  static const _keyOnboardingComplete = 'intro_v2_complete';
  static const _keyTripPlans = 'trip_plans';
  static const _keyLanguageCode = 'language_code';

  TravelProvider({
    CatalogLoader? catalogLoader,
    bool reportCatalogErrors = true,
  })  : _catalogLoader = catalogLoader ?? SupabaseDataService().loadCatalog,
        _reportCatalogErrors = reportCatalogErrors {
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _favoriteCityIds = (prefs.getStringList(_keyCities) ?? []).toSet();
      _favoritePlaceIds = (prefs.getStringList(_keyPlaces) ?? []).toSet();
      _favoriteTourIds = (prefs.getStringList(_keyTours) ?? []).toSet();
      _onboardingComplete = prefs.getBool(_keyOnboardingComplete) ?? false;
      _languageCode = _normalizeLanguageCode(
        prefs.getString(_keyLanguageCode),
      );
      await _loadRemoteCatalog();
      _loadTripPlans(prefs);
    } finally {
      _initialized = true;
      _notifyIfActive();
    }
  }

  Future<void> _loadRemoteCatalog() async {
    try {
      final catalog = await _catalogLoader().timeout(_remoteCatalogTimeout);
      if (!catalog.isComplete) {
        _usingRemoteCatalog = false;
        _catalogError = StateError('Supabase catalog is incomplete.');
        return;
      }

      cities = catalog.cities;
      places = catalog.places;
      agencies = catalog.agencies;
      tours = catalog.tours;
      reviews = catalog.reviews;
      _usingRemoteCatalog = true;
      _catalogError = null;
    } catch (error, stackTrace) {
      _usingRemoteCatalog = false;
      _catalogError = error;
      if (!_reportCatalogErrors) return;
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'tourconnect.travel_provider',
          context: ErrorDescription('while loading Supabase catalog'),
        ),
      );
    }
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    _notifyIfActive();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingComplete, true);
  }

  Future<void> setLanguage(String languageCode) async {
    final normalized = _normalizeLanguageCode(languageCode);
    if (_languageCode == normalized) return;

    _languageCode = normalized;
    _notifyIfActive();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, normalized);
  }

  String _normalizeLanguageCode(String? languageCode) {
    return languageCode == 'ru' ? 'ru' : 'en';
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCities, _favoriteCityIds.toList()..sort());
    await prefs.setStringList(_keyPlaces, _favoritePlaceIds.toList()..sort());
    await prefs.setStringList(_keyTours, _favoriteTourIds.toList()..sort());
  }

  void _loadTripPlans(SharedPreferences prefs) {
    final encodedPlans = prefs.getStringList(_keyTripPlans) ?? [];
    final placeById = {for (final place in places) place.id: place};

    _cityTripPlans.clear();
    for (final encoded in encodedPlans) {
      final separatorIndex = encoded.indexOf(':');
      if (separatorIndex <= 0 || separatorIndex == encoded.length - 1) {
        continue;
      }

      final cityId = encoded.substring(0, separatorIndex);
      final placeIds = encoded
          .substring(separatorIndex + 1)
          .split(',')
          .where((id) => id.isNotEmpty);

      final cityPlan = <Place>[];
      for (final placeId in placeIds) {
        final place = placeById[placeId];
        if (place != null && place.cityId == cityId) {
          cityPlan.add(place);
        }
      }

      if (cityPlan.isNotEmpty) {
        _cityTripPlans[cityId] = cityPlan;
      }
    }
  }

  Future<void> _saveTripPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedPlans = _cityTripPlans.entries
        .where((entry) => entry.value.isNotEmpty)
        .map(
          (entry) =>
              '${entry.key}:${entry.value.map((place) => place.id).join(',')}',
        )
        .toList();

    await prefs.setStringList(_keyTripPlans, encodedPlans);
  }

  int get totalFavoritesCount =>
      _favoriteCityIds.length +
      _favoritePlaceIds.length +
      _favoriteTourIds.length;

  int get plannedPlacesCount =>
      _cityTripPlans.values.fold<int>(0, (sum, plan) => sum + plan.length);

  int get plannedCitiesCount =>
      _cityTripPlans.values.where((plan) => plan.isNotEmpty).length;

  List<Place> get favoritePlaces =>
      places.where((place) => _favoritePlaceIds.contains(place.id)).toList();

  List<Tour> get favoriteTours =>
      tours.where((tour) => _favoriteTourIds.contains(tour.id)).toList();

  bool isCityFavorite(String id) => _favoriteCityIds.contains(id);

  void toggleCityFavorite(City city) {
    if (_favoriteCityIds.contains(city.id)) {
      _favoriteCityIds.remove(city.id);
    } else {
      _favoriteCityIds.add(city.id);
    }
    _notifyIfActive();
    _persist(_saveFavorites(), 'saving city favorites');
  }

  bool isPlaceFavorite(String id) => _favoritePlaceIds.contains(id);

  void togglePlaceFavorite(Place place) {
    if (_favoritePlaceIds.contains(place.id)) {
      _favoritePlaceIds.remove(place.id);
    } else {
      _favoritePlaceIds.add(place.id);
    }
    _notifyIfActive();
    _persist(_saveFavorites(), 'saving place favorites');
  }

  bool isTourFavorite(String id) => _favoriteTourIds.contains(id);

  void toggleTourFavorite(Tour tour) {
    if (_favoriteTourIds.contains(tour.id)) {
      _favoriteTourIds.remove(tour.id);
    } else {
      _favoriteTourIds.add(tour.id);
    }
    _notifyIfActive();
    _persist(_saveFavorites(), 'saving tour favorites');
  }

  List<Place> getPlanForCity(String cityId) =>
      UnmodifiableListView(_cityTripPlans[cityId] ?? const <Place>[]);

  bool isPlaceInPlan(String cityId, String placeId) =>
      (_cityTripPlans[cityId] ?? []).any((place) => place.id == placeId);

  void togglePlaceInPlan(String cityId, Place place) {
    _cityTripPlans.putIfAbsent(cityId, () => []);
    final plan = _cityTripPlans[cityId]!;

    if (plan.any((item) => item.id == place.id)) {
      plan.removeWhere((item) => item.id == place.id);
    } else {
      plan.add(place);
    }
    _notifyIfActive();
    _persist(_saveTripPlans(), 'saving trip plan');
  }

  void clearPlan(String cityId) {
    final plan = _cityTripPlans[cityId];
    if (plan == null || plan.isEmpty) return;

    plan.clear();
    _cityTripPlans.remove(cityId);
    _notifyIfActive();
    _persist(_saveTripPlans(), 'clearing trip plan');
  }

  void reorderPlan(String cityId, int oldIndex, int newIndex) {
    final plan = _cityTripPlans[cityId];
    if (plan == null) return;
    if (oldIndex < 0 || oldIndex >= plan.length) return;
    if (newIndex < 0 || newIndex > plan.length) return;

    final targetIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = plan.removeAt(oldIndex);
    plan.insert(targetIndex, item);
    _notifyIfActive();
    _persist(_saveTripPlans(), 'saving reordered trip plan');
  }

  void _notifyIfActive() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _persist(Future<void> future, String operation) {
    unawaited(
      future.catchError((Object error, StackTrace stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'tourconnect.travel_provider',
            context: ErrorDescription('while $operation'),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
