import 'package:flutter/material.dart';
import '../../models/place_model.dart';
import '../../models/tour_model.dart';

class TravelProvider with ChangeNotifier {
  final Set<String> _favoritePlaceIds = {};
  final Set<String> _favoriteTourIds = {};
  final Map<String, List<Place>> _cityTripPlans = {};

  bool isPlaceFavorite(String id) => _favoritePlaceIds.contains(id);
  bool isTourFavorite(String id) => _favoriteTourIds.contains(id);

  void togglePlaceFavorite(Place place) {
    if (_favoritePlaceIds.contains(place.id)) {
      _favoritePlaceIds.remove(place.id);
    } else {
      _favoritePlaceIds.add(place.id);
    }
    notifyListeners();
  }

  void toggleTourFavorite(Tour tour) {
    if (_favoriteTourIds.contains(tour.id)) {
      _favoriteTourIds.remove(tour.id);
    } else {
      _favoriteTourIds.add(tour.id);
    }
    notifyListeners();
  }

  List<Place> getPlanForCity(String cityId) => _cityTripPlans[cityId] ?? [];

  void togglePlaceInPlan(String cityId, Place place) {
    if (!_cityTripPlans.containsKey(cityId)) {
      _cityTripPlans[cityId] = [];
    }
    
    final plan = _cityTripPlans[cityId]!;
    if (plan.contains(place)) {
      plan.remove(place);
    } else {
      plan.add(place);
    }
    notifyListeners();
  }
}
