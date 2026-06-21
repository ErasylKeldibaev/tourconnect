import 'package:flutter_test/flutter_test.dart';
import 'package:tourconnect/data/dummy_data.dart';

void main() {
  group('travel content data', () {
    test('uses unique ids across all catalog collections', () {
      expect(_hasUniqueIds(cities.map((city) => city.id)), isTrue);
      expect(_hasUniqueIds(places.map((place) => place.id)), isTrue);
      expect(_hasUniqueIds(agencies.map((agency) => agency.id)), isTrue);
      expect(_hasUniqueIds(tours.map((tour) => tour.id)), isTrue);
      expect(_hasUniqueIds(reviews.map((review) => review.id)), isTrue);
    });

    test('gives every city enough content to feel complete', () {
      for (final city in cities) {
        expect(
          places.where((place) => place.cityId == city.id),
          hasLength(greaterThanOrEqualTo(4)),
          reason: '${city.name} should have at least four places',
        );
        expect(
          agencies.where((agency) => agency.cityId == city.id),
          isNotEmpty,
          reason: '${city.name} should have a local agency',
        );
        expect(
          tours.where((tour) => tour.cityId == city.id),
          isNotEmpty,
          reason: '${city.name} should have a bookable tour',
        );
        expect(
          reviews.where((review) => review.cityId == city.id),
          isNotEmpty,
          reason: '${city.name} should have traveler reviews',
        );
      }
    });

    test('keeps tours linked to valid agencies and cities', () {
      final cityIds = cities.map((city) => city.id).toSet();
      final agencyIds = agencies.map((agency) => agency.id).toSet();

      for (final tour in tours) {
        expect(cityIds, contains(tour.cityId));
        expect(agencyIds, contains(tour.agencyId));
        expect(
          agencies.firstWhere((agency) => agency.id == tour.agencyId).cityId,
          tour.cityId,
          reason: '${tour.title} agency should belong to the same city',
        );
      }
    });

    test('uses production-friendly image urls', () {
      final imageUrls = [
        ...cities.map((city) => city.imageUrl),
        ...places.map((place) => place.imageUrl),
        ...agencies.map((agency) => agency.imageUrl),
        ...tours.map((tour) => tour.imageUrl),
        ...reviews.map((review) => review.userAvatar).whereType<String>(),
      ];

      for (final imageUrl in imageUrls) {
        final uri = Uri.parse(imageUrl);
        expect(uri.scheme, 'https');
        expect(uri.host, isNotEmpty);
        expect(imageUrl, isNot(contains('example.com')));
      }
    });
  });
}

bool _hasUniqueIds(Iterable<String> ids) => ids.toSet().length == ids.length;
