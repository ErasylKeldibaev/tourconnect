create table if not exists public.cities (
  id text primary key,
  name text not null,
  country text not null,
  image_url text not null,
  description text not null,
  rating numeric not null default 4.5,
  review_count integer not null default 0,
  continent text not null default '',
  tags text[] not null default '{}',
  lat double precision,
  lng double precision,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.places (
  id text primary key,
  city_id text not null references public.cities(id) on delete cascade,
  name text not null,
  category text not null,
  image_url text not null,
  description text not null,
  rating numeric not null default 4.5,
  address text not null default '',
  review_count integer not null default 0,
  is_popular boolean not null default false,
  lat double precision,
  lng double precision,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.agencies (
  id text primary key,
  city_id text not null references public.cities(id) on delete cascade,
  name text not null,
  image_url text not null,
  description text not null,
  rating numeric not null default 4.5,
  phone text not null default '',
  review_count integer not null default 0,
  tours_count integer not null default 0,
  is_verified boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tours (
  id text primary key,
  city_id text not null references public.cities(id) on delete cascade,
  agency_id text not null references public.agencies(id) on delete cascade,
  title text not null,
  image_url text not null,
  price numeric not null default 0,
  currency text not null default 'USD',
  duration text not null,
  description text not null,
  rating numeric not null default 4.5,
  review_count integer not null default 0,
  max_group_size integer not null default 15,
  difficulty text not null default 'Easy',
  includes text[] not null default '{}',
  is_instant_book boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.reviews (
  id text primary key,
  city_id text not null references public.cities(id) on delete cascade,
  user_name text not null,
  user_avatar text,
  comment text not null,
  rating numeric not null default 4.5,
  date timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists places_city_id_idx on public.places(city_id);
create index if not exists agencies_city_id_idx on public.agencies(city_id);
create index if not exists tours_city_id_idx on public.tours(city_id);
create index if not exists tours_agency_id_idx on public.tours(agency_id);
create index if not exists reviews_city_id_idx on public.reviews(city_id);

alter table public.cities enable row level security;
alter table public.places enable row level security;
alter table public.agencies enable row level security;
alter table public.tours enable row level security;
alter table public.reviews enable row level security;

drop policy if exists "Catalog cities are public" on public.cities;
create policy "Catalog cities are public" on public.cities
  for select using (true);

drop policy if exists "Catalog places are public" on public.places;
create policy "Catalog places are public" on public.places
  for select using (true);

drop policy if exists "Catalog agencies are public" on public.agencies;
create policy "Catalog agencies are public" on public.agencies
  for select using (true);

drop policy if exists "Catalog tours are public" on public.tours;
create policy "Catalog tours are public" on public.tours
  for select using (true);

drop policy if exists "Catalog reviews are public" on public.reviews;
create policy "Catalog reviews are public" on public.reviews
  for select using (true);
