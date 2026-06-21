import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourconnect/core/providers/travel_provider.dart';
import 'package:tourconnect/data/dummy_data.dart';
import 'package:tourconnect/services/supabase_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<TravelProvider> createProvider({
    Map<String, Object> initialValues = const {},
    CatalogLoader? catalogLoader,
  }) async {
    SharedPreferences.setMockInitialValues(initialValues);
    final provider = TravelProvider(
      catalogLoader: catalogLoader ?? _localCatalogLoader,
      reportCatalogErrors: false,
    );

    while (!provider.initialized) {
      await Future<void>.delayed(Duration.zero);
    }

    return provider;
  }

  group('TravelProvider', () {
    test('uses remote catalog when a complete catalog loads', () async {
      final provider = await createProvider();

      expect(provider.initialized, isTrue);
      expect(provider.usingRemoteCatalog, isTrue);
      expect(provider.catalogError, isNull);

      provider.dispose();
    });

    test('falls back to bundled catalog when remote catalog fails', () async {
      final provider = await createProvider(
        catalogLoader: () => Future.error(StateError('offline')),
      );

      expect(provider.initialized, isTrue);
      expect(provider.usingRemoteCatalog, isFalse);
      expect(provider.catalogError, isA<StateError>());
      expect(cities, isNotEmpty);

      provider.dispose();
    });

    test('loads persisted favorites and onboarding status', () async {
      final provider = await createProvider(
        initialValues: {
          'fav_cities': <String>['1'],
          'fav_places': <String>['p1'],
          'fav_tours': <String>['t1'],
          'intro_v2_complete': true,
        },
      );

      expect(provider.onboardingComplete, isTrue);
      expect(provider.isCityFavorite('1'), isTrue);
      expect(provider.isPlaceFavorite('p1'), isTrue);
      expect(provider.isTourFavorite('t1'), isTrue);
      expect(provider.totalFavoritesCount, 3);

      provider.dispose();
    });

    test('loads and saves the selected app language', () async {
      final provider = await createProvider(
        initialValues: {
          'language_code': 'ru',
        },
      );

      expect(provider.languageCode, 'ru');

      await provider.setLanguage('en');
      final prefs = await SharedPreferences.getInstance();

      expect(provider.languageCode, 'en');
      expect(prefs.getString('language_code'), 'en');

      provider.dispose();
    });

    test('restores valid trip plans and ignores invalid place ids', () async {
      final provider = await createProvider(
        initialValues: {
          'trip_plans': <String>['1:p1,p2,missing', '2:p1,p4'],
        },
      );

      expect(
        provider.getPlanForCity('1').map((place) => place.id),
        ['p1', 'p2'],
      );
      expect(provider.getPlanForCity('2').map((place) => place.id), ['p4']);

      provider.dispose();
    });

    test('returns immutable city plans', () async {
      final provider = await createProvider();

      provider.togglePlaceInPlan('1', places.first);
      final plan = provider.getPlanForCity('1');

      expect(plan, hasLength(1));
      expect(() => plan.add(places[1]), throwsUnsupportedError);

      provider.dispose();
    });

    test('reorderPlan handles invalid indexes without changing the plan',
        () async {
      final provider = await createProvider();

      provider.togglePlaceInPlan('1', places[0]);
      provider.togglePlaceInPlan('1', places[1]);
      provider.reorderPlan('1', -1, 1);
      provider.reorderPlan('1', 0, 99);

      expect(
        provider.getPlanForCity('1').map((place) => place.id),
        ['p1', 'p2'],
      );

      provider.dispose();
    });

    test('clearPlan removes saved stops for one city only', () async {
      final provider = await createProvider();

      provider.togglePlaceInPlan('1', places[0]);
      provider.togglePlaceInPlan('1', places[1]);
      provider.togglePlaceInPlan('2', places[3]);

      provider.clearPlan('1');

      expect(provider.getPlanForCity('1'), isEmpty);
      expect(provider.getPlanForCity('2').map((place) => place.id), ['p4']);
      expect(provider.plannedPlacesCount, 1);

      provider.dispose();
    });
  });
}

Future<CatalogData> _localCatalogLoader() async {
  return CatalogData(
    cities: cities,
    places: places,
    agencies: agencies,
    tours: tours,
    reviews: reviews,
  );
}
