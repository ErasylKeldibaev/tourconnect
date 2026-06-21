import 'dart:io';

import 'package:tourconnect/data/dummy_data.dart';

void main() {
  final buffer = StringBuffer()
    ..writeln('-- Generated from lib/data/dummy_data.dart')
    ..writeln('-- Run supabase/catalog_schema.sql before this file.')
    ..writeln('begin;')
    ..writeln()
    ..writeln(_deleteExistingData())
    ..writeln()
    ..writeln(_insertCities())
    ..writeln()
    ..writeln(_insertPlaces())
    ..writeln()
    ..writeln(_insertAgencies())
    ..writeln()
    ..writeln(_insertTours())
    ..writeln()
    ..writeln(_insertReviews())
    ..writeln()
    ..writeln('commit;');

  stdout.write(buffer.toString());
}

String _deleteExistingData() {
  return [
    'delete from public.reviews;',
    'delete from public.tours;',
    'delete from public.agencies;',
    'delete from public.places;',
    'delete from public.cities;',
  ].join('\n');
}

String _insertCities() {
  final rows = cities.map((city) {
    return [
      city.id.sql,
      city.name.sql,
      city.country.sql,
      city.imageUrl.sql,
      city.description.sql,
      city.rating.sqlNumber,
      city.reviewCount.sqlNumber,
      city.continent.sql,
      city.tags.sqlArray,
      city.lat.sqlNullableNumber,
      city.lng.sqlNullableNumber,
    ].row;
  }).join(',\n');

  return '''
insert into public.cities (
  id, name, country, image_url, description, rating, review_count, continent, tags, lat, lng
) values
$rows;''';
}

String _insertPlaces() {
  final rows = places.map((place) {
    return [
      place.id.sql,
      place.cityId.sql,
      place.name.sql,
      place.category.sql,
      place.imageUrl.sql,
      place.description.sql,
      place.rating.sqlNumber,
      place.address.sql,
      place.reviewCount.sqlNumber,
      place.isPopular.sqlBool,
      place.lat.sqlNullableNumber,
      place.lng.sqlNullableNumber,
    ].row;
  }).join(',\n');

  return '''
insert into public.places (
  id, city_id, name, category, image_url, description, rating, address, review_count, is_popular, lat, lng
) values
$rows;''';
}

String _insertAgencies() {
  final rows = agencies.map((agency) {
    return [
      agency.id.sql,
      agency.cityId.sql,
      agency.name.sql,
      agency.imageUrl.sql,
      agency.description.sql,
      agency.rating.sqlNumber,
      agency.phone.sql,
      agency.reviewCount.sqlNumber,
      agency.toursCount.sqlNumber,
      agency.isVerified.sqlBool,
    ].row;
  }).join(',\n');

  return '''
insert into public.agencies (
  id, city_id, name, image_url, description, rating, phone, review_count, tours_count, is_verified
) values
$rows;''';
}

String _insertTours() {
  final rows = tours.map((tour) {
    return [
      tour.id.sql,
      tour.cityId.sql,
      tour.agencyId.sql,
      tour.title.sql,
      tour.imageUrl.sql,
      tour.price.sqlNumber,
      tour.currency.sql,
      tour.duration.sql,
      tour.description.sql,
      tour.rating.sqlNumber,
      tour.reviewCount.sqlNumber,
      tour.maxGroupSize.sqlNumber,
      tour.difficulty.sql,
      tour.includes.sqlArray,
      tour.isInstantBook.sqlBool,
    ].row;
  }).join(',\n');

  return '''
insert into public.tours (
  id, city_id, agency_id, title, image_url, price, currency, duration, description, rating,
  review_count, max_group_size, difficulty, includes, is_instant_book
) values
$rows;''';
}

String _insertReviews() {
  final rows = reviews.map((review) {
    return [
      review.id.sql,
      review.cityId.sql,
      review.userName.sql,
      review.userAvatar.sqlNullable,
      review.comment.sql,
      review.rating.sqlNumber,
      review.date?.toIso8601String().sql ?? 'null',
    ].row;
  }).join(',\n');

  return '''
insert into public.reviews (
  id, city_id, user_name, user_avatar, comment, rating, date
) values
$rows;''';
}

extension _SqlString on String {
  String get sql => "'${replaceAll("'", "''")}'";
}

extension _SqlNullableString on String? {
  String get sqlNullable => this == null ? 'null' : this!.sql;
}

extension _SqlNumber on num {
  String get sqlNumber => toString();
}

extension _SqlNullableNumber on num? {
  String get sqlNullableNumber => this == null ? 'null' : this!.toString();
}

extension _SqlBool on bool {
  String get sqlBool => this ? 'true' : 'false';
}

extension _SqlArray on List<String> {
  String get sqlArray => 'array[${map((item) => item.sql).join(',')}]::text[]';
}

extension _SqlRow on List<String> {
  String get row => '  (${join(', ')})';
}
