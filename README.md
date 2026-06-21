# TourConnect

TourConnect is a Flutter travel app for discovering cities, saving favorites,
exploring places on a map, planning trips, and previewing guided tour bookings.

## Highlights

- Curated destination discovery with 20 cities, search, filters, and featured picks.
- City detail pages with hero imagery, quick stats, sights, tours, agencies, and planner actions.
- Interactive map with city/place markers and destination search.
- Favorites for cities, places, and tours.
- Trip planning state stored locally with `SharedPreferences`.
- Supabase-backed authentication and profile data.
- Polished mobile UI with optimized network images, shimmer loading, and resilient fallback states.
- Data-quality tests that keep city, place, agency, tour, review, and image relationships consistent.

## Configuration

The app supports `--dart-define` overrides for Supabase:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Defaults are kept in `lib/core/config/app_config.dart` for local development.

## Supabase Catalog

Travel catalog data is loaded from Supabase at startup. The local
`lib/data/dummy_data.dart` catalog remains as a fallback and as the seed source.

Run these files in the Supabase SQL editor:

```sql
-- 1. Create tables, indexes, and public read policies.
-- supabase/catalog_schema.sql

-- 2. Seed cities, places, agencies, tours, and reviews.
-- supabase/catalog_seed.sql
```

To regenerate the seed after editing `dummy_data.dart`:

```bash
dart run tool/export_catalog_seed.dart > supabase/catalog_seed.sql
```

## Run

```bash
flutter pub get
flutter run
```

## Quality

Recommended checks:

```bash
flutter analyze
flutter test
```
