import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../models/tour_model.dart';
import '../../models/city_model.dart';
import '../../data/dummy_data.dart';

class TravelProvider with ChangeNotifier {
  final Set<String> _favoriteCityIds = {};
  final Set<String> _favoritePlaceIds = {};
  final Set<String> _favoriteTourIds = {};
  final Map<String, List<Place>> _cityTripPlans = {};

  // Геттеры для списков (нужны для экрана Saved)
  List<Place> get favoritePlaces => places.where((p) => _favoritePlaceIds.contains(p.id)).toList();
  List<Tour> get favoriteTours => tours.where((t) => _favoriteTourIds.contains(t.id)).toList();

  // Методы для городов
  bool isCityFavorite(String id) => _favoriteCityIds.contains(id);
  void toggleCityFavorite(City city) {
    if (_favoriteCityIds.contains(city.id)) {
      _favoriteCityIds.remove(city.id);
    } else {
      _favoriteCityIds.add(city.id);
    }
    notifyListeners();
  }

  // Методы для мест
  bool isPlaceFavorite(String id) => _favoritePlaceIds.contains(id);
  void togglePlaceFavorite(Place place) {
    if (_favoritePlaceIds.contains(place.id)) {
      _favoritePlaceIds.remove(place.id);
    } else {
      _favoritePlaceIds.add(place.id);
    }
    notifyListeners();
  }

  // Методы для туров
  bool isTourFavorite(String id) => _favoriteTourIds.contains(id);
  void toggleTourFavorite(Tour tour) {
    if (_favoriteTourIds.contains(tour.id)) {
      _favoriteTourIds.remove(tour.id);
    } else {
      _favoriteTourIds.add(tour.id);
    }
    notifyListeners();
  }

  // Логика планировщика
  List<Place> getPlanForCity(String cityId) => _cityTripPlans[cityId] ?? [];
  
  bool isPlaceInPlan(String cityId, String placeId) {
    return (_cityTripPlans[cityId] ?? []).any((p) => p.id == placeId);
  }

  void togglePlaceInPlan(String cityId, Place place) {
    if (!_cityTripPlans.containsKey(cityId)) _cityTripPlans[cityId] = [];
    final plan = _cityTripPlans[cityId]!;
    if (plan.any((p) => p.id == place.id)) {
      plan.removeWhere((p) => p.id == place.id);
    } else {
      plan.add(place);
    }
    notifyListeners();
  }

  void reorderPlan(String cityId, int oldIndex, int newIndex) {
    if (!_cityTripPlans.containsKey(cityId)) return;
    final plan = _cityTripPlans[cityId]!;
    if (newIndex > oldIndex) newIndex -= 1;
    final item = plan.removeAt(oldIndex);
    plan.insert(newIndex, item);
    notifyListeners();
  }
}
