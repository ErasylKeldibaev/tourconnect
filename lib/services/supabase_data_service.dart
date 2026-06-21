import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/agency_model.dart';
import '../models/city_model.dart';
import '../models/place_model.dart';
import '../models/review_model.dart';
import '../models/tour_model.dart';

class CatalogData {
  final List<City> cities;
  final List<Place> places;
  final List<Agency> agencies;
  final List<Tour> tours;
  final List<Review> reviews;

  const CatalogData({
    required this.cities,
    required this.places,
    required this.agencies,
    required this.tours,
    required this.reviews,
  });

  bool get isComplete =>
      cities.isNotEmpty &&
      places.isNotEmpty &&
      agencies.isNotEmpty &&
      tours.isNotEmpty &&
      reviews.isNotEmpty;
}

class SupabaseDataService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<CatalogData> loadCatalog() async {
    final results = await Future.wait([
      getCities(),
      getPlaces(),
      getAgencies(),
      getTours(),
      getReviews(),
    ]);

    return CatalogData(
      cities: results[0] as List<City>,
      places: results[1] as List<Place>,
      agencies: results[2] as List<Agency>,
      tours: results[3] as List<Tour>,
      reviews: results[4] as List<Review>,
    );
  }

  Future<List<City>> getCities() async {
    final response =
        await _client.from('cities').select().order('rating', ascending: false);

    return response.map<City>(_cityFromRow).toList();
  }

  Future<List<Place>> getPlaces({String? cityId}) async {
    var query = _client.from('places').select();
    if (cityId != null) {
      query = query.eq('city_id', cityId);
    }
    final response = await query.order('rating', ascending: false);

    return response.map<Place>(_placeFromRow).toList();
  }

  Future<List<Agency>> getAgencies({String? cityId}) async {
    var query = _client.from('agencies').select();
    if (cityId != null) {
      query = query.eq('city_id', cityId);
    }
    final response = await query.order('rating', ascending: false);

    return response.map<Agency>(_agencyFromRow).toList();
  }

  Future<List<Tour>> getTours({String? cityId}) async {
    var query = _client.from('tours').select();
    if (cityId != null) {
      query = query.eq('city_id', cityId);
    }
    final response = await query.order('rating', ascending: false);

    return response.map<Tour>(_tourFromRow).toList();
  }

  Future<List<Review>> getReviews({String? cityId}) async {
    var query = _client.from('reviews').select();
    if (cityId != null) {
      query = query.eq('city_id', cityId);
    }
    final response = await query.order('date', ascending: false);

    return response.map<Review>(_reviewFromRow).toList();
  }

  Future<void> addFavorite(String cityId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('favorites').insert({
      'user_id': user.id,
      'city_id': cityId,
    });
  }

  Future<void> removeFavorite(String cityId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('city_id', cityId);
  }
}

City _cityFromRow(Map<String, dynamic> row) {
  return City(
    id: row.stringValue('id'),
    name: row.stringValue('name'),
    country: row.stringValue('country'),
    continent: row.stringValue('continent'),
    imageUrl: row.stringValue('image_url'),
    description: row.stringValue('description'),
    rating: row.doubleValue('rating', fallback: 4.5),
    reviewCount: row.intValue('review_count'),
    tags: row.stringListValue('tags'),
    lat: row.nullableDoubleValue('lat'),
    lng: row.nullableDoubleValue('lng'),
  );
}

Place _placeFromRow(Map<String, dynamic> row) {
  return Place(
    id: row.stringValue('id'),
    cityId: row.stringValue('city_id'),
    name: row.stringValue('name'),
    category: row.stringValue('category'),
    imageUrl: row.stringValue('image_url'),
    description: row.stringValue('description'),
    rating: row.doubleValue('rating', fallback: 4.5),
    address: row.stringValue('address'),
    reviewCount: row.intValue('review_count'),
    isPopular: row.boolValue('is_popular'),
    lat: row.nullableDoubleValue('lat'),
    lng: row.nullableDoubleValue('lng'),
  );
}

Agency _agencyFromRow(Map<String, dynamic> row) {
  return Agency(
    id: row.stringValue('id'),
    cityId: row.stringValue('city_id'),
    name: row.stringValue('name'),
    imageUrl: row.stringValue('image_url'),
    description: row.stringValue('description'),
    rating: row.doubleValue('rating', fallback: 4.5),
    phone: row.stringValue('phone'),
    reviewCount: row.intValue('review_count'),
    toursCount: row.intValue('tours_count'),
    isVerified: row.boolValue('is_verified', fallback: true),
  );
}

Tour _tourFromRow(Map<String, dynamic> row) {
  return Tour(
    id: row.stringValue('id'),
    cityId: row.stringValue('city_id'),
    agencyId: row.stringValue('agency_id'),
    title: row.stringValue('title'),
    imageUrl: row.stringValue('image_url'),
    price: row.doubleValue('price'),
    currency: row.stringValue('currency', fallback: 'USD'),
    duration: row.stringValue('duration'),
    description: row.stringValue('description'),
    rating: row.doubleValue('rating', fallback: 4.5),
    reviewCount: row.intValue('review_count'),
    maxGroupSize: row.intValue('max_group_size', fallback: 15),
    difficulty: row.stringValue('difficulty', fallback: 'Easy'),
    includes: row.stringListValue('includes'),
    isInstantBook: row.boolValue('is_instant_book', fallback: true),
  );
}

Review _reviewFromRow(Map<String, dynamic> row) {
  return Review(
    id: row.stringValue('id'),
    cityId: row.stringValue('city_id'),
    userName: row.stringValue('user_name'),
    userAvatar: row.nullableStringValue('user_avatar'),
    comment: row.stringValue('comment'),
    rating: row.doubleValue('rating', fallback: 4.5),
    date: row.dateTimeValue('date') ?? row.dateTimeValue('created_at'),
  );
}

extension _RowValueReader on Map<String, dynamic> {
  String stringValue(String key, {String fallback = ''}) {
    final value = this[key];
    if (value == null) return fallback;
    return value.toString();
  }

  String? nullableStringValue(String key) {
    final value = this[key];
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  int intValue(String key, {int fallback = 0}) {
    final value = this[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double doubleValue(String key, {double fallback = 0}) {
    final value = this[key];
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double? nullableDoubleValue(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  bool boolValue(String key, {bool fallback = false}) {
    final value = this[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return fallback;
  }

  List<String> stringListValue(String key) {
    final value = this[key];
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      return value.split(',').map((item) => item.trim()).toList();
    }
    return const [];
  }

  DateTime? dateTimeValue(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
