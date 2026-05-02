import '../models/city_model.dart';
import '../models/place_model.dart';
import '../models/agency_model.dart';
import '../models/tour_model.dart';
import '../models/review_model.dart';

final List<City> cities = [
  City(
    id: '1',
    name: 'Bishkek',
    country: 'Kyrgyzstan',
    imageUrl: 'https://images.unsplash.com/photo-1569429593410-b498b3fb3387?q=80&w=1000&auto=format&fit=crop',
    description: 'The capital of Kyrgyzstan, known for mountains and parks.',
  ),
  City(
    id: '2',
    name: 'Munich',
    country: 'Germany',
    imageUrl: 'https://images.unsplash.com/photo-1595853035070-59a39fe84de3?q=80&w=1000&auto=format&fit=crop',
    description: 'Famous for Oktoberfest and beautiful architecture.',
  ),
  City(
    id: '3',
    name: 'Paris',
    country: 'France',
    imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1000&auto=format&fit=crop',
    description: 'City of love and the Eiffel Tower.',
  ),
  City(
    id: '4',
    name: 'Rome',
    country: 'Italy',
    imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?q=80&w=1000&auto=format&fit=crop',
    description: 'Ancient city full of history and culture.',
  ),
];

final List<Place> places = [
  Place(
    id: 'p1',
    cityId: '1',
    name: 'Ala-Too Square',
    category: 'Sightseeing',
    imageUrl: 'https://images.unsplash.com/photo-1624606707329-3715dfc37a6b?q=80&w=1000&auto=format&fit=crop',
    description: 'The main square of Bishkek and one of the city symbols.',
    rating: 4.7,
    address: 'Ala-Too Square, Bishkek',
  ),
  Place(
    id: 'p5',
    cityId: '3',
    name: 'Eiffel Tower',
    category: 'Landmark',
    imageUrl: 'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?q=80&w=1000&auto=format&fit=crop',
    description: 'The most famous landmark of Paris.',
    rating: 4.9,
    address: 'Champ de Mars, Paris',
  ),
  Place(
    id: 'p6',
    cityId: '4',
    name: 'Colosseum',
    category: 'History',
    imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?q=80&w=1000&auto=format&fit=crop',
    description: 'Ancient Roman amphitheatre and world-famous monument.',
    rating: 4.9,
    address: 'Piazza del Colosseo, Rome',
  ),
];

final List<Agency> agencies = [
  Agency(
    id: 'a1',
    cityId: '1',
    name: 'Kyrgyz Travel',
    imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=500&auto=format&fit=crop',
    description: 'Local travel agency offering city and mountain tours.',
    rating: 4.6,
    phone: '+996 555 123 456',
  ),
];

final List<Tour> tours = [
  Tour(
    id: 't1',
    cityId: '1',
    agencyId: 'a1',
    title: 'Bishkek City Tour',
    imageUrl: 'https://images.unsplash.com/photo-1596464716127-f2a82984de30?q=80&w=1000&auto=format&fit=crop',
    price: '\$25',
    duration: '3 hours',
    description: 'Explore Ala-Too Square, parks and main city attractions.',
  ),
];

final List<Review> reviews = [
  Review(
    id: 'r1',
    cityId: '1',
    userName: 'Aidar',
    comment: 'Bishkek is a calm and beautiful city with mountain views.',
    rating: 4.6,
  ),
];
