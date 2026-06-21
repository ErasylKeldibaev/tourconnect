import '../models/city_model.dart';
import '../models/place_model.dart';
import '../models/agency_model.dart';
import '../models/tour_model.dart';
import '../models/review_model.dart';

List<City> cities = [
  const City(
      id: '1',
      name: 'Bishkek',
      country: 'Kyrgyzstan',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1569429593410-b498b3fb3387?q=80&w=1200',
      description:
          'The vibrant capital of Kyrgyzstan, nestled at the foot of the magnificent Tian Shan mountains. A city of wide Soviet boulevards, lively bazaars, and breathtaking natural escapes just minutes away.',
      rating: 4.7,
      reviewCount: 1240,
      tags: ['Mountains', 'Culture', 'Adventure'],
      lat: 42.8746,
      lng: 74.6122),
  const City(
      id: '2',
      name: 'Munich',
      country: 'Germany',
      continent: 'Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1595853035070-59a39fe84de3?q=80&w=1200',
      description:
          'Bavaria\'s cosmopolitan capital combines world-class museums, cutting-edge technology, and centuries-old traditions. From Oktoberfest to the English Garden, Munich captivates every visitor.',
      rating: 4.8,
      reviewCount: 5820,
      tags: ['Beer', 'Museums', 'Architecture'],
      lat: 48.1374,
      lng: 11.5755),
  const City(
      id: '3',
      name: 'Paris',
      country: 'France',
      continent: 'Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1200',
      description:
          'The City of Light needs no introduction. Iconic art, haute cuisine, romantic riverbanks, and fashion that sets the global agenda - Paris is perpetually at the heart of the world.',
      rating: 4.9,
      reviewCount: 12480,
      tags: ['Romance', 'Art', 'Fashion'],
      lat: 48.8566,
      lng: 2.3522),
  const City(
      id: '4',
      name: 'Rome',
      country: 'Italy',
      continent: 'Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1552832230-c0197dd311b5?q=80&w=1200',
      description:
          'The Eternal City layers 2,800 years of history at every turn. Ancient ruins, Baroque fountains, Vatican treasures, and the finest pasta you\'ll ever taste.',
      rating: 4.8,
      reviewCount: 9340,
      tags: ['History', 'Food', 'Vatican'],
      lat: 41.9028,
      lng: 12.4964),
  const City(
      id: '5',
      name: 'Tokyo',
      country: 'Japan',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=1200',
      description:
          'A city where ancient temples and futuristic skyscrapers coexist seamlessly. Tokyo\'s endless energy, world-class cuisine, and unique pop culture make it utterly unforgettable.',
      rating: 4.9,
      reviewCount: 15600,
      tags: ['Technology', 'Food', 'Culture'],
      lat: 35.6762,
      lng: 139.6503),
  const City(
      id: '6',
      name: 'Istanbul',
      country: 'Turkey',
      continent: 'Asia/Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?q=80&w=1200',
      description:
          'Straddling two continents, Istanbul is where East meets West in the most spectacular fashion. Hagia Sophia, Grand Bazaar, and the Bosphorus create an atmosphere unlike anywhere else.',
      rating: 4.8,
      reviewCount: 8950,
      tags: ['History', 'Culture', 'Food'],
      lat: 41.0082,
      lng: 28.9784),
  const City(
      id: '7',
      name: 'Barcelona',
      country: 'Spain',
      continent: 'Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?q=80&w=1200',
      description:
          'A sunlit Mediterranean city of Gaudi architecture, beach life, tapas bars, and late-night energy. Barcelona mixes art, sport, food, and sea air with effortless style.',
      rating: 4.8,
      reviewCount: 10420,
      tags: ['Architecture', 'Beach', 'Food'],
      lat: 41.3874,
      lng: 2.1686),
  const City(
      id: '8',
      name: 'New York',
      country: 'United States',
      continent: 'Americas',
      imageUrl:
          'https://images.unsplash.com/photo-1485871981521-5b1fd3805eee?q=80&w=1200',
      description:
          'A vertical city of iconic skylines, world-class museums, neighborhood food scenes, Broadway lights, and nonstop urban momentum.',
      rating: 4.7,
      reviewCount: 18240,
      tags: ['Skyline', 'Museums', 'Food'],
      lat: 40.7128,
      lng: -74.0060),
  const City(
      id: '9',
      name: 'Dubai',
      country: 'United Arab Emirates',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?q=80&w=1200',
      description:
          'A desert metropolis of record-breaking towers, luxury shopping, beach resorts, and dramatic dunes just beyond the skyline.',
      rating: 4.7,
      reviewCount: 9400,
      tags: ['Luxury', 'Desert', 'Architecture'],
      lat: 25.2048,
      lng: 55.2708),
  const City(
      id: '10',
      name: 'Cape Town',
      country: 'South Africa',
      continent: 'Africa',
      imageUrl:
          'https://images.unsplash.com/photo-1580060839134-75a5edca2e99?q=80&w=1200',
      description:
          'A dramatic coastal city framed by Table Mountain, beaches, vineyards, colorful neighborhoods, and unforgettable ocean drives.',
      rating: 4.8,
      reviewCount: 7120,
      tags: ['Nature', 'Coast', 'Wine'],
      lat: -33.9249,
      lng: 18.4241),
  const City(
      id: '11',
      name: 'Sydney',
      country: 'Australia',
      continent: 'Oceania',
      imageUrl:
          'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?q=80&w=1200',
      description:
          'Harbor views, surf beaches, coastal walks, and a relaxed outdoor lifestyle make Sydney one of the world\'s most scenic city escapes.',
      rating: 4.8,
      reviewCount: 8360,
      tags: ['Harbor', 'Beaches', 'Lifestyle'],
      lat: -33.8688,
      lng: 151.2093),
  const City(
      id: '12',
      name: 'Bangkok',
      country: 'Thailand',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1508009603885-50cf7c579365?q=80&w=1200',
      description:
          'A vivid city of golden temples, river life, rooftop views, street food, and markets that keep moving long after sunset.',
      rating: 4.7,
      reviewCount: 11680,
      tags: ['Temples', 'Street Food', 'Markets'],
      lat: 13.7563,
      lng: 100.5018),
  const City(
      id: '13',
      name: 'Almaty',
      country: 'Kazakhstan',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1624377632657-3902bfd35958?auto=format&fit=crop&w=1400&q=85',
      description:
          'Kazakhstan\'s leafy mountain city pairs cafe-lined avenues with the snowcapped Zailiyskiy Alatau, alpine lakes, ski slopes, and a polished urban food scene.',
      rating: 4.7,
      reviewCount: 4860,
      tags: ['Mountains', 'Cafes', 'Nature'],
      lat: 43.2389,
      lng: 76.8897),
  const City(
      id: '14',
      name: 'Tashkent',
      country: 'Uzbekistan',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1548115184-bc6544d06a58?auto=format&fit=crop&w=1400&q=85',
      description:
          'A bright Silk Road capital of blue-tiled madrasas, Soviet modernist metro stations, leafy boulevards, bazaars, and generous Uzbek hospitality.',
      rating: 4.6,
      reviewCount: 3920,
      tags: ['Silk Road', 'Markets', 'Architecture'],
      lat: 41.2995,
      lng: 69.2401),
  const City(
      id: '15',
      name: 'Seoul',
      country: 'South Korea',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1538485399081-7191377e8241?auto=format&fit=crop&w=1400&q=85',
      description:
          'A high-energy capital where royal palaces, design districts, mountain trails, K-pop streets, and late-night food alleys move at full speed.',
      rating: 4.8,
      reviewCount: 13420,
      tags: ['Design', 'Food', 'Nightlife'],
      lat: 37.5665,
      lng: 126.9780),
  const City(
      id: '16',
      name: 'Singapore',
      country: 'Singapore',
      continent: 'Asia',
      imageUrl:
          'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1400&q=85',
      description:
          'A compact city-state of garden architecture, hawker food, waterfront skylines, tropical parks, and effortless transit between cultures.',
      rating: 4.8,
      reviewCount: 11980,
      tags: ['Skyline', 'Gardens', 'Food'],
      lat: 1.3521,
      lng: 103.8198),
  const City(
      id: '17',
      name: 'Amsterdam',
      country: 'Netherlands',
      continent: 'Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1512470876302-972faa2aa9a4?auto=format&fit=crop&w=1400&q=85',
      description:
          'A canal-laced city of world-class museums, cycling culture, brick gables, design shops, and relaxed neighborhood cafes.',
      rating: 4.7,
      reviewCount: 9820,
      tags: ['Canals', 'Museums', 'Cycling'],
      lat: 52.3676,
      lng: 4.9041),
  const City(
      id: '18',
      name: 'Prague',
      country: 'Czech Republic',
      continent: 'Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1541849546-216549ae216d?auto=format&fit=crop&w=1400&q=85',
      description:
          'A cinematic capital of castle views, Gothic towers, cobbled lanes, riverside walks, beer halls, and beautifully preserved medieval atmosphere.',
      rating: 4.8,
      reviewCount: 8760,
      tags: ['Castles', 'History', 'Beer'],
      lat: 50.0755,
      lng: 14.4378),
  const City(
      id: '19',
      name: 'London',
      country: 'United Kingdom',
      continent: 'Europe',
      imageUrl:
          'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1400&q=85',
      description:
          'A global capital of royal landmarks, markets, museums, theater, parks, and neighborhoods that feel like many cities stitched together.',
      rating: 4.8,
      reviewCount: 16780,
      tags: ['Museums', 'Theatre', 'Markets'],
      lat: 51.5072,
      lng: -0.1276),
  const City(
      id: '20',
      name: 'Rio de Janeiro',
      country: 'Brazil',
      continent: 'Americas',
      imageUrl:
          'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?auto=format&fit=crop&w=1400&q=85',
      description:
          'A dramatic coastal city of granite peaks, samba energy, golden beaches, forested hills, and sunset views that feel larger than life.',
      rating: 4.8,
      reviewCount: 10340,
      tags: ['Beaches', 'Music', 'Views'],
      lat: -22.9068,
      lng: -43.1729),
];

List<Place> places = [
  const Place(
      id: 'p1',
      cityId: '1',
      isPopular: true,
      name: 'Ala-Too Square',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1516306580123-e6e52b1b7b5f?auto=format&fit=crop&w=1200&q=85',
      description:
          'Bishkek central square with the Manas monument, flag ceremony, State History Museum views, and the city\'s main civic events.',
      rating: 4.7,
      reviewCount: 820,
      address: 'Ala-Too Square, Chuy Ave, Bishkek',
      lat: 42.8764,
      lng: 74.6038),
  const Place(
      id: 'p2',
      cityId: '1',
      isPopular: true,
      name: 'Osh Bazaar',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=85',
      description:
          'One of Bishkek\'s largest bazaars for spices, dried fruit, kurut, textiles, souvenirs, local snacks, and everyday city life.',
      rating: 4.5,
      reviewCount: 640,
      address: 'Beyshenalieva St / Kyiv St, Bishkek',
      lat: 42.8754,
      lng: 74.5787),
  const Place(
      id: 'p3',
      cityId: '1',
      name: 'Panfilov Park',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=85',
      description:
          'A central park near Old Square with shaded walks, family rides, Soviet-era monuments, and an easy break from Chuy Avenue.',
      rating: 4.4,
      reviewCount: 380,
      address: 'Panfilov Park, Bishkek',
      lat: 42.8791,
      lng: 74.6007),
  const Place(
      id: 'p4',
      cityId: '2',
      isPopular: true,
      name: 'Marienplatz',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1555990793-da11153b2473?q=80&w=1000',
      description:
          'Munich\'s central square, home to the famous Glockenspiel carillon.',
      rating: 4.8,
      reviewCount: 2100,
      address: 'Marienplatz, Munich',
      lat: 48.1374,
      lng: 11.5755),
  const Place(
      id: 'p5',
      cityId: '2',
      isPopular: true,
      name: 'English Garden',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=85',
      description:
          'One of the world\'s largest urban parks - even bigger than Central Park.',
      rating: 4.9,
      reviewCount: 3200,
      address: 'Englischer Garten, Munich',
      lat: 48.1642,
      lng: 11.6050),
  const Place(
      id: 'p6',
      cityId: '3',
      isPopular: true,
      name: 'Eiffel Tower',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?q=80&w=1000',
      description:
          'Gustave Eiffel\'s iron lattice masterpiece, Paris\'s defining silhouette since 1889.',
      rating: 4.9,
      reviewCount: 8400,
      address: 'Champ de Mars, Paris',
      lat: 48.8584,
      lng: 2.2945),
  const Place(
      id: 'p7',
      cityId: '3',
      isPopular: true,
      name: 'Louvre Museum',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?q=80&w=1000',
      description:
          'The world\'s largest art museum, home to the Mona Lisa and Venus de Milo.',
      rating: 4.8,
      reviewCount: 6200,
      address: 'Rue de Rivoli, Paris',
      lat: 48.8606,
      lng: 2.3376),
  const Place(
      id: 'p8',
      cityId: '4',
      isPopular: true,
      name: 'Colosseum',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1552832230-c0197dd311b5?q=80&w=1000',
      description:
          'The iconic ancient amphitheatre that once held 80,000 spectators.',
      rating: 4.9,
      reviewCount: 7800,
      address: 'Piazza del Colosseo, Rome',
      lat: 41.8902,
      lng: 12.4924),
  const Place(
      id: 'p9',
      cityId: '4',
      name: 'Trevi Fountain',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1525874684015-58379d421a52?q=80&w=1000',
      description:
          'Rome\'s largest Baroque fountain. Toss a coin to ensure your return.',
      rating: 4.8,
      reviewCount: 5100,
      address: 'Piazza di Trevi, Rome',
      lat: 41.9009,
      lng: 12.4833),
  const Place(
      id: 'p10',
      cityId: '5',
      isPopular: true,
      name: 'Senso-ji Temple',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?q=80&w=1000',
      description:
          'Tokyo\'s oldest and most significant temple, built in 628 AD.',
      rating: 4.8,
      reviewCount: 5400,
      address: 'Asakusa, Tokyo',
      lat: 35.7148,
      lng: 139.7967),
  const Place(
      id: 'p11',
      cityId: '5',
      isPopular: true,
      name: 'Shibuya Crossing',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1542051841857-5f90071e7989?q=80&w=1000',
      description:
          'The world\'s busiest pedestrian crossing - up to 3,000 people cross simultaneously.',
      rating: 4.7,
      reviewCount: 4200,
      address: 'Shibuya, Tokyo',
      lat: 35.6598,
      lng: 139.7004),
  const Place(
      id: 'p12',
      cityId: '6',
      isPopular: true,
      name: 'Hagia Sophia',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?q=80&w=1000',
      description:
          'Built in 537 AD, this architectural marvel has served as cathedral, mosque, and museum.',
      rating: 4.9,
      reviewCount: 6800,
      address: 'Sultanahmet, Istanbul',
      lat: 41.0082,
      lng: 28.9784),
  const Place(
      id: 'p13',
      cityId: '6',
      name: 'Grand Bazaar',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1541432901042-2d8bd64b4a9b?q=80&w=1000',
      description:
          'One of the world\'s largest covered markets with over 4,000 shops.',
      rating: 4.6,
      reviewCount: 4500,
      address: 'Beyazit, Istanbul',
      lat: 41.0107,
      lng: 28.9681),
  const Place(
      id: 'p14',
      cityId: '7',
      isPopular: true,
      name: 'Sagrada Familia',
      category: 'Architecture',
      imageUrl:
          'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?auto=format&fit=crop&w=1200&q=85',
      description:
          'Gaudi\'s unfinished basilica and Barcelona\'s most extraordinary architectural landmark.',
      rating: 4.9,
      reviewCount: 9100,
      address: 'Carrer de Mallorca, Barcelona',
      lat: 41.4036,
      lng: 2.1744),
  const Place(
      id: 'p15',
      cityId: '7',
      name: 'Park Guell',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1578912996078-305d92249aa6?q=80&w=1000',
      description:
          'A colorful hillside park where mosaics, gardens, and city views blend into one playful landscape.',
      rating: 4.7,
      reviewCount: 5300,
      address: 'Gracia, Barcelona',
      lat: 41.4145,
      lng: 2.1527),
  const Place(
      id: 'p16',
      cityId: '8',
      isPopular: true,
      name: 'Central Park',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=1200&q=85',
      description:
          'New York\'s legendary green heart with lakes, lawns, trails, and skyline-framed views.',
      rating: 4.8,
      reviewCount: 12200,
      address: 'Manhattan, New York',
      lat: 40.7829,
      lng: -73.9654),
  const Place(
      id: 'p17',
      cityId: '8',
      isPopular: true,
      name: 'Times Square',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1534430480872-3498386e7856?q=80&w=1000',
      description:
          'Bright billboards, theaters, crowds, and the electric pulse of Midtown Manhattan.',
      rating: 4.5,
      reviewCount: 10800,
      address: 'Midtown Manhattan, New York',
      lat: 40.7580,
      lng: -73.9855),
  const Place(
      id: 'p18',
      cityId: '9',
      isPopular: true,
      name: 'Burj Khalifa',
      category: 'Architecture',
      imageUrl:
          'https://images.unsplash.com/photo-1518684079-3c830dcef090?q=80&w=1000',
      description:
          'The world\'s tallest building, rising above Downtown Dubai with panoramic observation decks.',
      rating: 4.8,
      reviewCount: 8700,
      address: 'Downtown Dubai',
      lat: 25.1972,
      lng: 55.2744),
  const Place(
      id: 'p19',
      cityId: '9',
      name: 'Dubai Creek',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?q=80&w=1000',
      description:
          'The historic waterway where abras, souks, and old trading districts reveal Dubai\'s roots.',
      rating: 4.6,
      reviewCount: 3200,
      address: 'Deira, Dubai',
      lat: 25.2631,
      lng: 55.2972),
  const Place(
      id: 'p20',
      cityId: '10',
      isPopular: true,
      name: 'Table Mountain',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1580060839134-75a5edca2e99?q=80&w=1000',
      description:
          'Cape Town\'s flat-topped icon with cable car access and sweeping views over city and ocean.',
      rating: 4.9,
      reviewCount: 6800,
      address: 'Table Mountain, Cape Town',
      lat: -33.9628,
      lng: 18.4098),
  const Place(
      id: 'p21',
      cityId: '10',
      name: 'V&A Waterfront',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85',
      description:
          'A lively harbor district with restaurants, shops, museums, and mountain views.',
      rating: 4.7,
      reviewCount: 4100,
      address: 'Waterfront, Cape Town',
      lat: -33.9068,
      lng: 18.4222),
  const Place(
      id: 'p22',
      cityId: '11',
      isPopular: true,
      name: 'Sydney Opera House',
      category: 'Architecture',
      imageUrl:
          'https://images.unsplash.com/photo-1523428096881-5bd79d043006?q=80&w=1000',
      description:
          'The sail-shaped performance venue that defines Sydney Harbour.',
      rating: 4.9,
      reviewCount: 7600,
      address: 'Bennelong Point, Sydney',
      lat: -33.8568,
      lng: 151.2153),
  const Place(
      id: 'p23',
      cityId: '11',
      name: 'Bondi Beach',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?q=80&w=1000',
      description:
          'Australia\'s most famous beach, loved for surf, cafes, coastal walks, and golden sand.',
      rating: 4.7,
      reviewCount: 5200,
      address: 'Bondi, Sydney',
      lat: -33.8915,
      lng: 151.2767),
  const Place(
      id: 'p24',
      cityId: '12',
      isPopular: true,
      name: 'Grand Palace',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1528181304800-259b08848526?q=80&w=1000',
      description:
          'A dazzling royal complex of gilded halls, courtyards, and sacred Thai architecture.',
      rating: 4.8,
      reviewCount: 8400,
      address: 'Phra Nakhon, Bangkok',
      lat: 13.7500,
      lng: 100.4913),
  const Place(
      id: 'p25',
      cityId: '12',
      name: 'Chatuchak Market',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1508009603885-50cf7c579365?q=80&w=1000',
      description:
          'A massive weekend market with food stalls, fashion, crafts, antiques, and endless wandering.',
      rating: 4.6,
      reviewCount: 4700,
      address: 'Kamphaeng Phet 2 Rd, Bangkok',
      lat: 13.7999,
      lng: 100.5505),
  const Place(
      id: 'p26',
      cityId: '13',
      isPopular: true,
      name: 'Kok Tobe',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1624377632657-3902bfd35958?auto=format&fit=crop&w=1200&q=85',
      description:
          'A hilltop viewpoint above Almaty with cable car access, city panoramas, cafes, and mountain silhouettes.',
      rating: 4.7,
      reviewCount: 2400,
      address: 'Kok Tobe, Almaty',
      lat: 43.2330,
      lng: 76.9760),
  const Place(
      id: 'p27',
      cityId: '13',
      name: 'Medeu',
      category: 'Adventure',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1200&q=85',
      description:
          'A legendary alpine sports complex and gateway to mountain walks just outside the city.',
      rating: 4.8,
      reviewCount: 3180,
      address: 'Medeu Valley, Almaty',
      lat: 43.1570,
      lng: 77.0580),
  const Place(
      id: 'p28',
      cityId: '14',
      isPopular: true,
      name: 'Chorsu Bazaar',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1604328698692-f76ea9498e76?auto=format&fit=crop&w=1200&q=85',
      description:
          'A landmark domed bazaar for spices, bread, dried fruit, ceramics, and classic Uzbek street snacks.',
      rating: 4.7,
      reviewCount: 2860,
      address: 'Chorsu, Tashkent',
      lat: 41.3268,
      lng: 69.2354),
  const Place(
      id: 'p29',
      cityId: '14',
      name: 'Tashkent Metro',
      category: 'Architecture',
      imageUrl:
          'https://images.unsplash.com/photo-1603988363607-e1e4a66962c6?auto=format&fit=crop&w=1200&q=85',
      description:
          'One of Central Asia\'s most beautiful metro systems, known for ornate station halls and Soviet-era design.',
      rating: 4.8,
      reviewCount: 2190,
      address: 'Tashkent Metro, Tashkent',
      lat: 41.3111,
      lng: 69.2797),
  const Place(
      id: 'p30',
      cityId: '15',
      isPopular: true,
      name: 'Gyeongbokgung Palace',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1538485399081-7191377e8241?auto=format&fit=crop&w=1200&q=85',
      description:
          'Seoul\'s grand Joseon-era palace with ceremonial gates, courtyards, and mountain-backed architecture.',
      rating: 4.8,
      reviewCount: 7300,
      address: 'Jongno-gu, Seoul',
      lat: 37.5796,
      lng: 126.9770),
  const Place(
      id: 'p31',
      cityId: '15',
      name: 'Myeongdong',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1548115184-bc6544d06a58?auto=format&fit=crop&w=1200&q=85',
      description:
          'A neon shopping district for cosmetics, street food, fashion, and energetic evening crowds.',
      rating: 4.6,
      reviewCount: 6800,
      address: 'Myeongdong, Seoul',
      lat: 37.5638,
      lng: 126.9820),
  const Place(
      id: 'p32',
      cityId: '16',
      isPopular: true,
      name: 'Gardens by the Bay',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1200&q=85',
      description:
          'A futuristic garden district with Supertrees, glass conservatories, and evening light shows.',
      rating: 4.9,
      reviewCount: 9200,
      address: 'Marina Gardens Dr, Singapore',
      lat: 1.2816,
      lng: 103.8636),
  const Place(
      id: 'p33',
      cityId: '16',
      name: 'Maxwell Food Centre',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=1200&q=85',
      description:
          'A classic hawker centre for chicken rice, noodles, tropical drinks, and everyday Singapore flavor.',
      rating: 4.7,
      reviewCount: 5100,
      address: 'Kadayanallur St, Singapore',
      lat: 1.2803,
      lng: 103.8448),
  const Place(
      id: 'p34',
      cityId: '17',
      isPopular: true,
      name: 'Rijksmuseum',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1512470876302-972faa2aa9a4?auto=format&fit=crop&w=1200&q=85',
      description:
          'The Dutch national museum with masterpieces, grand galleries, and a landmark building on Museumplein.',
      rating: 4.8,
      reviewCount: 7700,
      address: 'Museumstraat, Amsterdam',
      lat: 52.3600,
      lng: 4.8852),
  const Place(
      id: 'p35',
      cityId: '17',
      name: 'Jordaan Canals',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1534351590666-13e3e96b5017?auto=format&fit=crop&w=1200&q=85',
      description:
          'A photogenic neighborhood of quiet canals, bridges, boutiques, brown cafes, and golden-hour walks.',
      rating: 4.8,
      reviewCount: 5600,
      address: 'Jordaan, Amsterdam',
      lat: 52.3738,
      lng: 4.8807),
  const Place(
      id: 'p36',
      cityId: '18',
      isPopular: true,
      name: 'Charles Bridge',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1541849546-216549ae216d?auto=format&fit=crop&w=1200&q=85',
      description:
          'Prague\'s iconic stone bridge lined with statues, river views, musicians, and castle silhouettes.',
      rating: 4.8,
      reviewCount: 8700,
      address: 'Charles Bridge, Prague',
      lat: 50.0865,
      lng: 14.4114),
  const Place(
      id: 'p37',
      cityId: '18',
      name: 'Prague Castle',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1519677100203-a0e668c92439?auto=format&fit=crop&w=1200&q=85',
      description:
          'A vast castle complex with cathedral spires, courtyards, old streets, and sweeping city views.',
      rating: 4.8,
      reviewCount: 6900,
      address: 'Hradcany, Prague',
      lat: 50.0911,
      lng: 14.4016),
  const Place(
      id: 'p38',
      cityId: '19',
      isPopular: true,
      name: 'Tower Bridge',
      category: 'Architecture',
      imageUrl:
          'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1200&q=85',
      description:
          'A defining London landmark crossing the Thames with Victorian engineering and skyline views.',
      rating: 4.8,
      reviewCount: 10200,
      address: 'Tower Bridge Rd, London',
      lat: 51.5055,
      lng: -0.0754),
  const Place(
      id: 'p39',
      cityId: '19',
      name: 'Borough Market',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1519003722824-194d4455a60c?auto=format&fit=crop&w=1200&q=85',
      description:
          'A historic food market packed with bakeries, produce stalls, coffee, cheese, and global street food.',
      rating: 4.7,
      reviewCount: 7600,
      address: 'Southwark, London',
      lat: 51.5054,
      lng: -0.0908),
  const Place(
      id: 'p40',
      cityId: '20',
      isPopular: true,
      name: 'Christ the Redeemer',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?auto=format&fit=crop&w=1200&q=85',
      description:
          'Rio\'s world-famous mountaintop statue overlooking beaches, bays, forest, and dramatic granite peaks.',
      rating: 4.9,
      reviewCount: 9800,
      address: 'Corcovado, Rio de Janeiro',
      lat: -22.9519,
      lng: -43.2105),
  const Place(
      id: 'p41',
      cityId: '20',
      name: 'Ipanema Beach',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1516306580123-e6e52b1b7b5f?auto=format&fit=crop&w=1200&q=85',
      description:
          'A legendary beach neighborhood for sunsets, surf, music, mountain views, and Rio street life.',
      rating: 4.8,
      reviewCount: 8400,
      address: 'Ipanema, Rio de Janeiro',
      lat: -22.9838,
      lng: -43.2096),
  const Place(
      id: 'p42',
      cityId: '1',
      isPopular: true,
      name: 'Victory Square',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=1200&q=85',
      description:
          'A solemn memorial square with the eternal flame and yurt-shaped monument dedicated to the Second World War victory.',
      rating: 4.4,
      reviewCount: 330,
      address: 'Victory Square, Bishkek',
      lat: 42.8797,
      lng: 74.6172),
  const Place(
      id: 'p43',
      cityId: '2',
      name: 'Viktualienmarkt',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=85',
      description:
          'A beloved food market for produce stalls, beer garden tables, sausages, cheese, flowers, and Bavarian snacks.',
      rating: 4.7,
      reviewCount: 3400,
      address: 'Viktualienmarkt, Munich',
      lat: 48.1351,
      lng: 11.5764),
  const Place(
      id: 'p44',
      cityId: '3',
      name: 'Montmartre',
      category: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=1200&q=85',
      description:
          'A hilltop village of artists, stairways, cafes, Sacre-Coeur views, and some of Paris\'s most atmospheric lanes.',
      rating: 4.8,
      reviewCount: 6100,
      address: 'Montmartre, Paris',
      lat: 48.8867,
      lng: 2.3431),
  const Place(
      id: 'p45',
      cityId: '4',
      name: 'Trastevere',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1529260830199-42c24126f198?auto=format&fit=crop&w=1200&q=85',
      description:
          'A warm evening neighborhood of ivy-covered lanes, trattorias, piazzas, wine bars, and classic Roman nightlife.',
      rating: 4.8,
      reviewCount: 4800,
      address: 'Trastevere, Rome',
      lat: 41.8896,
      lng: 12.4698),
  const Place(
      id: 'p46',
      cityId: '5',
      name: 'Meiji Shrine',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=85',
      description:
          'A tranquil forest shrine near Harajuku with torii gates, gravel paths, and a reset from Tokyo\'s rush.',
      rating: 4.8,
      reviewCount: 6100,
      address: 'Shibuya, Tokyo',
      lat: 35.6764,
      lng: 139.6993),
  const Place(
      id: 'p47',
      cityId: '6',
      name: 'Basilica Cistern',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?auto=format&fit=crop&w=1200&q=85',
      description:
          'An atmospheric underground reservoir of columns, reflections, and Byzantine engineering near Sultanahmet.',
      rating: 4.8,
      reviewCount: 5400,
      address: 'Sultanahmet, Istanbul',
      lat: 41.0084,
      lng: 28.9779),
  const Place(
      id: 'p48',
      cityId: '7',
      name: 'Gothic Quarter',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?auto=format&fit=crop&w=1200&q=85',
      description:
          'A maze of medieval lanes, plazas, cathedral views, tapas bars, boutiques, and Barcelona\'s oldest urban texture.',
      rating: 4.7,
      reviewCount: 6800,
      address: 'Barri Gotic, Barcelona',
      lat: 41.3839,
      lng: 2.1763),
  const Place(
      id: 'p49',
      cityId: '8',
      name: 'Brooklyn Bridge',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1534270804882-6b5048b1c1fc?auto=format&fit=crop&w=1200&q=85',
      description:
          'A classic walk between Manhattan and Brooklyn with skyline views, stone towers, and golden-hour drama.',
      rating: 4.8,
      reviewCount: 13200,
      address: 'Brooklyn Bridge, New York',
      lat: 40.7061,
      lng: -73.9969),
  const Place(
      id: 'p50',
      cityId: '9',
      name: 'Al Fahidi Historical District',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?auto=format&fit=crop&w=1200&q=85',
      description:
          'A restored heritage quarter of wind towers, courtyards, small museums, galleries, and creek-side history.',
      rating: 4.6,
      reviewCount: 2800,
      address: 'Al Fahidi, Dubai',
      lat: 25.2638,
      lng: 55.3000),
  const Place(
      id: 'p51',
      cityId: '10',
      name: 'Kirstenbosch Gardens',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1511497584788-876760111969?auto=format&fit=crop&w=1200&q=85',
      description:
          'A celebrated botanical garden on Table Mountain\'s slopes with indigenous plants, lawns, and canopy walks.',
      rating: 4.9,
      reviewCount: 4600,
      address: 'Kirstenbosch, Cape Town',
      lat: -33.9875,
      lng: 18.4327),
  const Place(
      id: 'p52',
      cityId: '11',
      name: 'The Rocks',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?auto=format&fit=crop&w=1200&q=85',
      description:
          'Sydney\'s historic harbor quarter with sandstone lanes, pubs, markets, galleries, and bridge views.',
      rating: 4.7,
      reviewCount: 4100,
      address: 'The Rocks, Sydney',
      lat: -33.8599,
      lng: 151.2090),
  const Place(
      id: 'p53',
      cityId: '12',
      name: 'Wat Arun',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1528181304800-259b08848526?auto=format&fit=crop&w=1200&q=85',
      description:
          'The Temple of Dawn rises beside the Chao Phraya with porcelain details and some of Bangkok\'s best river views.',
      rating: 4.8,
      reviewCount: 6900,
      address: 'Bangkok Yai, Bangkok',
      lat: 13.7437,
      lng: 100.4889),
  const Place(
      id: 'p54',
      cityId: '13',
      name: 'Green Bazaar',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=85',
      description:
          'A central market for dried fruit, spices, horse-milk products, sweets, and everyday Almaty flavor.',
      rating: 4.6,
      reviewCount: 1800,
      address: 'Zhibek Zholy Ave, Almaty',
      lat: 43.2620,
      lng: 76.9539),
  const Place(
      id: 'p55',
      cityId: '14',
      name: 'Hazrati Imam Complex',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1548115184-bc6544d06a58?auto=format&fit=crop&w=1200&q=85',
      description:
          'A spiritual and architectural complex of madrasas, mosques, blue domes, manuscripts, and calm courtyards.',
      rating: 4.8,
      reviewCount: 2300,
      address: 'Karasaray St, Tashkent',
      lat: 41.3371,
      lng: 69.2402),
  const Place(
      id: 'p56',
      cityId: '15',
      name: 'Bukchon Hanok Village',
      category: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1538485399081-7191377e8241?auto=format&fit=crop&w=1200&q=85',
      description:
          'A preserved hillside neighborhood of hanok houses, craft stops, quiet lanes, and palace-adjacent views.',
      rating: 4.7,
      reviewCount: 4700,
      address: 'Bukchon, Seoul',
      lat: 37.5826,
      lng: 126.9830),
  const Place(
      id: 'p57',
      cityId: '16',
      name: 'Kampong Glam',
      category: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1200&q=85',
      description:
          'A colorful heritage district with Sultan Mosque views, textile lanes, murals, cafes, and boutique shops.',
      rating: 4.7,
      reviewCount: 3600,
      address: 'Kampong Glam, Singapore',
      lat: 1.3028,
      lng: 103.8592),
  const Place(
      id: 'p58',
      cityId: '17',
      name: 'Vondelpark',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=85',
      description:
          'Amsterdam\'s favorite park for cycling breaks, picnics, ponds, open-air theatre, and local weekend rhythm.',
      rating: 4.7,
      reviewCount: 4500,
      address: 'Vondelpark, Amsterdam',
      lat: 52.3579,
      lng: 4.8686),
  const Place(
      id: 'p59',
      cityId: '18',
      name: 'Old Town Square',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1541849546-216549ae216d?auto=format&fit=crop&w=1200&q=85',
      description:
          'A grand historic square with pastel facades, Gothic towers, the astronomical clock, and Prague street life.',
      rating: 4.8,
      reviewCount: 7600,
      address: 'Old Town Square, Prague',
      lat: 50.0870,
      lng: 14.4213),
  const Place(
      id: 'p60',
      cityId: '19',
      name: 'British Museum',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=85',
      description:
          'A vast free museum of world history, grand halls, ancient collections, and rainy-day London brilliance.',
      rating: 4.8,
      reviewCount: 11800,
      address: 'Great Russell St, London',
      lat: 51.5194,
      lng: -0.1270),
  const Place(
      id: 'p61',
      cityId: '20',
      name: 'Sugarloaf Mountain',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?auto=format&fit=crop&w=1200&q=85',
      description:
          'A cable-car viewpoint over Guanabara Bay, beaches, islands, and Rio\'s unforgettable mountain coastline.',
      rating: 4.9,
      reviewCount: 7600,
      address: 'Urca, Rio de Janeiro',
      lat: -22.9492,
      lng: -43.1545),
  const Place(
      id: 'p62',
      cityId: '1',
      isPopular: true,
      name: 'State History Museum',
      category: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=85',
      description:
          'A central museum stop beside Ala-Too Square for Kyrgyz history, nomadic heritage, Soviet-era context, and national identity.',
      rating: 4.5,
      reviewCount: 420,
      address: 'Ala-Too Square, Bishkek',
      lat: 42.8785,
      lng: 74.6040),
  const Place(
      id: 'p63',
      cityId: '2',
      name: 'Deutsches Museum',
      category: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=85',
      description:
          'One of the world\'s great science and technology museums, packed with aviation, engineering, and hands-on exhibits.',
      rating: 4.8,
      reviewCount: 3900,
      address: 'Museumsinsel, Munich',
      lat: 48.1299,
      lng: 11.5834),
  const Place(
      id: 'p64',
      cityId: '3',
      name: 'Luxembourg Gardens',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=85',
      description:
          'A graceful Left Bank garden for fountains, chairs, statues, palace views, and slow Paris afternoons.',
      rating: 4.8,
      reviewCount: 5200,
      address: 'Rue de Medicis, Paris',
      lat: 48.8462,
      lng: 2.3372),
  const Place(
      id: 'p65',
      cityId: '4',
      name: 'Campo de Fiori',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=85',
      description:
          'A lively market square by day and social evening hub with produce stalls, bakeries, cafes, and Roman street life.',
      rating: 4.6,
      reviewCount: 3100,
      address: 'Campo de Fiori, Rome',
      lat: 41.8956,
      lng: 12.4722),
  const Place(
      id: 'p66',
      cityId: '5',
      name: 'Ueno Park',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1522383225653-ed111181a951?auto=format&fit=crop&w=1200&q=85',
      description:
          'A museum-rich park with ponds, shrines, cherry blossoms, galleries, and easy access to old Tokyo neighborhoods.',
      rating: 4.7,
      reviewCount: 4800,
      address: 'Ueno, Tokyo',
      lat: 35.7156,
      lng: 139.7730),
  const Place(
      id: 'p67',
      cityId: '6',
      name: 'Galata Tower',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?auto=format&fit=crop&w=1200&q=85',
      description:
          'A medieval stone tower with panoramic views across the Golden Horn, Bosphorus, and historic Istanbul rooftops.',
      rating: 4.7,
      reviewCount: 5200,
      address: 'Galata, Istanbul',
      lat: 41.0256,
      lng: 28.9741),
  const Place(
      id: 'p68',
      cityId: '7',
      name: 'Barceloneta Beach',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85',
      description:
          'A city beach for sea air, seafood lunches, bike rides, volleyball, and a quick Mediterranean reset.',
      rating: 4.6,
      reviewCount: 6200,
      address: 'Barceloneta, Barcelona',
      lat: 41.3784,
      lng: 2.1925),
  const Place(
      id: 'p69',
      cityId: '8',
      name: 'The High Line',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=1200&q=85',
      description:
          'An elevated park threading through Manhattan with planting, public art, architecture views, and Chelsea access.',
      rating: 4.7,
      reviewCount: 9800,
      address: 'Chelsea, New York',
      lat: 40.7480,
      lng: -74.0048),
  const Place(
      id: 'p70',
      cityId: '9',
      name: 'Dubai Mall',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1200&q=85',
      description:
          'A vast shopping and entertainment complex beside Burj Khalifa, fountains, aquariums, and downtown dining.',
      rating: 4.7,
      reviewCount: 9600,
      address: 'Downtown Dubai',
      lat: 25.1975,
      lng: 55.2796),
  const Place(
      id: 'p71',
      cityId: '10',
      name: 'Camps Bay',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85',
      description:
          'A scenic beach neighborhood with mountain backdrops, sunset terraces, ocean air, and relaxed coastal energy.',
      rating: 4.8,
      reviewCount: 4400,
      address: 'Camps Bay, Cape Town',
      lat: -33.9509,
      lng: 18.3776),
  const Place(
      id: 'p72',
      cityId: '11',
      name: 'Darling Harbour',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?auto=format&fit=crop&w=1200&q=85',
      description:
          'A waterfront precinct for restaurants, museums, promenades, skyline reflections, and easy evening walks.',
      rating: 4.6,
      reviewCount: 4700,
      address: 'Darling Harbour, Sydney',
      lat: -33.8732,
      lng: 151.2009),
  const Place(
      id: 'p73',
      cityId: '12',
      name: 'Lumphini Park',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=85',
      description:
          'Bangkok\'s central green escape with lakes, skyline views, morning exercise groups, and shaded paths.',
      rating: 4.6,
      reviewCount: 4300,
      address: 'Lumphini, Bangkok',
      lat: 13.7308,
      lng: 100.5418),
  const Place(
      id: 'p74',
      cityId: '13',
      name: 'Big Almaty Lake',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=85',
      description:
          'A turquoise alpine lake framed by peaks, best visited as a scenic nature escape from Almaty.',
      rating: 4.9,
      reviewCount: 2700,
      address: 'Ile-Alatau National Park, Almaty',
      lat: 43.0507,
      lng: 76.9850),
  const Place(
      id: 'p75',
      cityId: '14',
      name: 'Navoi Theater',
      category: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=85',
      description:
          'An elegant opera and ballet landmark with ornate interiors, fountains, and classic Tashkent evening atmosphere.',
      rating: 4.7,
      reviewCount: 1500,
      address: 'Navoi Theater, Tashkent',
      lat: 41.3110,
      lng: 69.2793),
  const Place(
      id: 'p76',
      cityId: '15',
      name: 'N Seoul Tower',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1538485399081-7191377e8241?auto=format&fit=crop&w=1200&q=85',
      description:
          'A hilltop tower on Namsan with city panoramas, cable car access, night views, and Seoul skyline context.',
      rating: 4.7,
      reviewCount: 7300,
      address: 'Namsan, Seoul',
      lat: 37.5512,
      lng: 126.9882),
  const Place(
      id: 'p77',
      cityId: '16',
      name: 'Chinatown Complex',
      category: 'Food',
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?auto=format&fit=crop&w=1200&q=85',
      description:
          'A dense hawker and market complex for local dishes, heritage streets, temples, and everyday Singapore flavor.',
      rating: 4.7,
      reviewCount: 4100,
      address: 'Chinatown, Singapore',
      lat: 1.2823,
      lng: 103.8439),
  const Place(
      id: 'p78',
      cityId: '17',
      name: 'Anne Frank House',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1512470876302-972faa2aa9a4?auto=format&fit=crop&w=1200&q=85',
      description:
          'A deeply moving historic house museum and one of Amsterdam\'s most important cultural visits.',
      rating: 4.8,
      reviewCount: 8600,
      address: 'Prinsengracht, Amsterdam',
      lat: 52.3752,
      lng: 4.8840),
  const Place(
      id: 'p79',
      cityId: '18',
      name: 'Petrin Hill',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=85',
      description:
          'A green hill with gardens, paths, a lookout tower, and wide views over Prague\'s roofs and river bends.',
      rating: 4.7,
      reviewCount: 3400,
      address: 'Petrin, Prague',
      lat: 50.0835,
      lng: 14.3950),
  const Place(
      id: 'p80',
      cityId: '19',
      name: 'Covent Garden',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?auto=format&fit=crop&w=1200&q=85',
      description:
          'A polished district for street performers, boutiques, markets, restaurants, theaters, and central London strolling.',
      rating: 4.7,
      reviewCount: 9200,
      address: 'Covent Garden, London',
      lat: 51.5117,
      lng: -0.1240),
  const Place(
      id: 'p81',
      cityId: '20',
      name: 'Lapa Arches',
      category: 'Culture',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=85',
      description:
          'A nightlife and music district anchored by historic arches, samba clubs, street parties, and colorful steps nearby.',
      rating: 4.6,
      reviewCount: 3900,
      address: 'Lapa, Rio de Janeiro',
      lat: -22.9136,
      lng: -43.1796),
  const Place(
      id: 'p82',
      cityId: '1',
      isPopular: true,
      name: 'Oak Park',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=85',
      description:
          'One of Bishkek\'s oldest leafy parks, known for sculpture walks, quiet benches, and quick access from the city center.',
      rating: 4.5,
      reviewCount: 290,
      address: 'Oak Park, Bishkek',
      lat: 42.8785,
      lng: 74.6088),
  const Place(
      id: 'p83',
      cityId: '1',
      name: 'Erkindik Boulevard',
      category: 'Sightseeing',
      imageUrl:
          'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?auto=format&fit=crop&w=1200&q=85',
      description:
          'A long central green promenade for walking, coffee stops, local rhythm, and an easy north-south city stroll.',
      rating: 4.6,
      reviewCount: 360,
      address: 'Erkindik Boulevard, Bishkek',
      lat: 42.8729,
      lng: 74.6081),
  const Place(
      id: 'p84',
      cityId: '1',
      name: 'Dordoi Plaza',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1519567241046-7f570eee3ce6?auto=format&fit=crop&w=1200&q=85',
      description:
          'A modern central mall with shops, restaurants, cinema, cafes, and a convenient meeting point near the city core.',
      rating: 4.4,
      reviewCount: 510,
      address: 'Ibraimov St, Bishkek',
      lat: 42.8750,
      lng: 74.6206),
  const Place(
      id: 'p85',
      cityId: '1',
      isPopular: true,
      name: 'Ala-Archa National Park',
      category: 'Nature',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=85',
      description:
          'A dramatic alpine gorge south of Bishkek with river trails, juniper slopes, picnic areas, and high mountain views.',
      rating: 4.9,
      reviewCount: 1400,
      address: 'Ala-Archa Gorge, Chuy Region',
      lat: 42.6307,
      lng: 74.4806),
  const Place(
      id: 'p86',
      cityId: '1',
      name: 'Burana Tower',
      category: 'History',
      imageUrl:
          'https://images.unsplash.com/photo-1548115184-bc6544d06a58?auto=format&fit=crop&w=1200&q=85',
      description:
          'An 11th-century Karakhanid minaret near Tokmok, often visited as a half-day history trip from Bishkek.',
      rating: 4.7,
      reviewCount: 760,
      address: 'Burana, near Tokmok',
      lat: 42.7468,
      lng: 75.2504),
  const Place(
      id: 'p87',
      cityId: '1',
      name: 'ZUM Aichurek',
      category: 'Shopping',
      imageUrl:
          'https://images.unsplash.com/photo-1519671482749-fd09be7ccebf?auto=format&fit=crop&w=1200&q=85',
      description:
          'A familiar central department store area for practical shopping, electronics, small boutiques, and city errands.',
      rating: 4.2,
      reviewCount: 410,
      address: 'Chuy Ave / Ibraimov St, Bishkek',
      lat: 42.8764,
      lng: 74.6131),
];

List<Agency> agencies = [
  const Agency(
      id: 'a1',
      cityId: '1',
      name: 'Kyrgyz Travel',
      rating: 4.8,
      reviewCount: 312,
      toursCount: 18,
      imageUrl:
          'https://images.unsplash.com/photo-1521791136064-7986c2920216?q=80&w=500',
      description:
          'The leading local agency for authentic Kyrgyz experiences. From city tours to epic mountain treks.',
      phone: '+996 555 123 456'),
  const Agency(
      id: 'a21',
      cityId: '1',
      name: 'Nomad Kyrgyzstan',
      rating: 4.9,
      reviewCount: 184,
      toursCount: 12,
      imageUrl:
          'https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=800&q=85',
      description:
          'Small-group guides for Ala-Archa hikes, Burana Tower day trips, Issyk-Kul weekends, and yurt camp routes.',
      phone: '+996 700 884 422'),
  const Agency(
      id: 'a22',
      cityId: '1',
      name: 'Bishkek Local Guides',
      rating: 4.7,
      reviewCount: 96,
      toursCount: 9,
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=85',
      description:
          'City walks, food market introductions, museum routes, airport pickup support, and flexible Russian/English guiding.',
      phone: '+996 555 771 202'),
  const Agency(
      id: 'a2',
      cityId: '2',
      name: 'Bavaria Explorer',
      rating: 4.7,
      reviewCount: 580,
      toursCount: 24,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=500',
      description:
          'Your expert guide to Bavaria\'s hidden gems and iconic landmarks.',
      phone: '+49 89 1234 5678'),
  const Agency(
      id: 'a3',
      cityId: '3',
      name: 'Paris Prestige Tours',
      rating: 4.9,
      reviewCount: 1240,
      toursCount: 42,
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=500',
      description:
          'Curated luxury and private tours of Paris. Skip the queues, access exclusive venues.',
      phone: '+33 1 2345 6789'),
  const Agency(
      id: 'a4',
      cityId: '4',
      name: 'Roma Antica Tours',
      rating: 4.8,
      reviewCount: 890,
      toursCount: 31,
      imageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=500',
      description:
          'Expert historians and archaeologists guide you through Rome\'s ancient wonders.',
      phone: '+39 06 1234 5678'),
  const Agency(
      id: 'a5',
      cityId: '5',
      name: 'Tokyo Discovery',
      rating: 4.9,
      reviewCount: 1560,
      toursCount: 55,
      imageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=500',
      description:
          'From hidden izakayas to futuristic Akihabara, we show you the real Tokyo.',
      phone: '+81 3 1234 5678'),
  const Agency(
      id: 'a6',
      cityId: '6',
      name: 'Bosphorus Travel',
      rating: 4.7,
      reviewCount: 720,
      toursCount: 28,
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=500',
      description:
          'Bridging cultures on the Bosphorus. Private boat tours, bazaar experiences, culinary journeys.',
      phone: '+90 212 123 4567'),
  const Agency(
      id: 'a7',
      cityId: '7',
      name: 'Catalonia Routes',
      rating: 4.8,
      reviewCount: 860,
      toursCount: 34,
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=500',
      description:
          'Architecture walks, tapas nights, and coastal escapes led by Barcelona locals.',
      phone: '+34 93 123 4567'),
  const Agency(
      id: 'a8',
      cityId: '8',
      name: 'NYC Urban Guides',
      rating: 4.7,
      reviewCount: 1320,
      toursCount: 48,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=500',
      description:
          'Neighborhood-first tours across Manhattan, Brooklyn, food markets, museums, and skyline viewpoints.',
      phone: '+1 212 555 0148'),
  const Agency(
      id: 'a9',
      cityId: '9',
      name: 'Dubai Desert Co.',
      rating: 4.8,
      reviewCount: 980,
      toursCount: 37,
      imageUrl:
          'https://images.unsplash.com/photo-1521791136064-7986c2920216?q=80&w=500',
      description:
          'Premium Dubai city tours, desert safaris, creek walks, and private transfer experiences.',
      phone: '+971 4 555 0190'),
  const Agency(
      id: 'a10',
      cityId: '10',
      name: 'Cape Compass',
      rating: 4.9,
      reviewCount: 740,
      toursCount: 29,
      imageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=500',
      description:
          'Mountain, coast, wine country, and local culture tours around Cape Town.',
      phone: '+27 21 555 0188'),
  const Agency(
      id: 'a11',
      cityId: '11',
      name: 'Sydney Harbour Tours',
      rating: 4.8,
      reviewCount: 910,
      toursCount: 33,
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=500',
      description:
          'Harbor cruises, coastal walks, surf introductions, and relaxed city highlights.',
      phone: '+61 2 5550 1234'),
  const Agency(
      id: 'a12',
      cityId: '12',
      name: 'Bangkok Local Ways',
      rating: 4.8,
      reviewCount: 1180,
      toursCount: 46,
      imageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=500',
      description:
          'Temples, street food, canals, markets, and night tours with Bangkok-based guides.',
      phone: '+66 2 555 0177'),
  const Agency(
      id: 'a13',
      cityId: '13',
      name: 'Almaty Alpine Co.',
      rating: 4.8,
      reviewCount: 620,
      toursCount: 22,
      imageUrl:
          'https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=700&q=85',
      description:
          'Mountain-first Almaty itineraries with city tastings, Kok Tobe sunsets, Medeu transfers, and alpine day trips.',
      phone: '+7 727 555 0140'),
  const Agency(
      id: 'a14',
      cityId: '14',
      name: 'Silk Road Tashkent',
      rating: 4.7,
      reviewCount: 540,
      toursCount: 19,
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=700&q=85',
      description:
          'Uzbek culture, metro architecture, bazaars, plov tastings, and day routes designed by local storytellers.',
      phone: '+998 71 555 0181'),
  const Agency(
      id: 'a15',
      cityId: '15',
      name: 'Seoul After Hours',
      rating: 4.9,
      reviewCount: 1440,
      toursCount: 52,
      imageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=700&q=85',
      description:
          'Palace mornings, design districts, food alleys, night markets, and flexible private Seoul routes.',
      phone: '+82 2 555 0195'),
  const Agency(
      id: 'a16',
      cityId: '16',
      name: 'Garden City Guides',
      rating: 4.8,
      reviewCount: 1020,
      toursCount: 38,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=700&q=85',
      description:
          'Singapore skyline walks, hawker routes, airport layovers, culture trails, and garden-focused experiences.',
      phone: '+65 6555 0116'),
  const Agency(
      id: 'a17',
      cityId: '17',
      name: 'Amsterdam Canal Club',
      rating: 4.8,
      reviewCount: 980,
      toursCount: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=700&q=85',
      description:
          'Small-group canal walks, museum planning, cycling introductions, and neighborhood food stops.',
      phone: '+31 20 555 0177'),
  const Agency(
      id: 'a18',
      cityId: '18',
      name: 'Prague Old Town Routes',
      rating: 4.8,
      reviewCount: 760,
      toursCount: 30,
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=700&q=85',
      description:
          'Castle routes, riverside evenings, historic beer halls, architecture walks, and photography-friendly timing.',
      phone: '+420 2 555 0188'),
  const Agency(
      id: 'a19',
      cityId: '19',
      name: 'London Layers',
      rating: 4.8,
      reviewCount: 1610,
      toursCount: 58,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=700&q=85',
      description:
          'Museum days, market routes, theatre nights, royal landmarks, and neighborhood-first London planning.',
      phone: '+44 20 5555 0190'),
  const Agency(
      id: 'a20',
      cityId: '20',
      name: 'Rio Vista Tours',
      rating: 4.9,
      reviewCount: 890,
      toursCount: 33,
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=700&q=85',
      description:
          'Beach mornings, viewpoint timing, samba nights, safe transfers, and scenic Rio routes with local guides.',
      phone: '+55 21 5555 0120'),
];

List<Tour> tours = [
  const Tour(
      id: 't1',
      cityId: '1',
      agencyId: 'a1',
      title: 'Kyrgyz Mountains & Lake Issyk-Kul',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=1200',
      price: 89,
      duration: '2 days',
      rating: 4.9,
      reviewCount: 156,
      description: 'Escape Bishkek into the Tian Shan highlands - yurt stays, alpine meadows, and the legendary Issyk-Kul lake.',
      maxGroupSize: 10,
      difficulty: 'Moderate',
      isInstantBook: true,
      includes: ['Transport', 'Yurt accommodation', 'Meals', 'Guide']),
  const Tour(
      id: 't2',
      cityId: '1',
      agencyId: 'a1',
      title: 'Bishkek City Highlights',
      imageUrl:
          'https://images.unsplash.com/photo-1569429593410-b498b3fb3387?q=80&w=1200',
      price: 35,
      duration: '4 hours',
      rating: 4.7,
      reviewCount: 89,
      description: 'Explore Ala-Too Square, the White House, Osh Bazaar and local cafes with a knowledgeable local guide.',
      maxGroupSize: 12,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Entry fees', 'Tea tasting']),
  const Tour(
      id: 't22',
      cityId: '1',
      agencyId: 'a21',
      title: 'Ala-Archa Gorge Day Hike',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=85',
      price: 55,
      duration: '7 hours',
      rating: 4.9,
      reviewCount: 118,
      description:
          'Leave Bishkek for Ala-Archa, walk the river trail, stop at viewpoints, and enjoy a guided mountain picnic.',
      maxGroupSize: 8,
      difficulty: 'Moderate',
      isInstantBook: true,
      includes: ['Transport', 'Park entry', 'Guide', 'Picnic lunch']),
  const Tour(
      id: 't23',
      cityId: '1',
      agencyId: 'a22',
      title: 'Osh Bazaar Food & Crafts Walk',
      imageUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=85',
      price: 29,
      duration: '3 hours',
      rating: 4.8,
      reviewCount: 74,
      description:
          'Taste kurut and fresh bread, navigate Osh Bazaar with a local, and meet sellers of spices, textiles, and souvenirs.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Local guide', 'Market snacks', 'Tea stop']),
  const Tour(
      id: 't24',
      cityId: '1',
      agencyId: 'a21',
      title: 'Burana Tower & Chuy Valley',
      imageUrl:
          'https://images.unsplash.com/photo-1548115184-bc6544d06a58?auto=format&fit=crop&w=1200&q=85',
      price: 49,
      duration: '6 hours',
      rating: 4.7,
      reviewCount: 66,
      description:
          'A half-day history route from Bishkek to the Burana Tower, balbals, small museum, and Chuy Valley viewpoints.',
      maxGroupSize: 9,
      difficulty: 'Easy',
      isInstantBook: false,
      includes: ['Transport', 'Guide', 'Museum ticket']),
  const Tour(
      id: 't3',
      cityId: '2',
      agencyId: 'a2',
      title: 'Classic Munich Walking Tour',
      imageUrl:
          'https://images.unsplash.com/photo-1555990793-da11153b2473?q=80&w=1200',
      price: 45,
      duration: '3 hours',
      rating: 4.8,
      reviewCount: 340,
      description: 'Marienplatz, Viktualienmarkt, Hofbrauhaus - see Munich\'s highlights with a passionate local guide.',
      maxGroupSize: 15,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Beer tasting', 'Pretzels']),
  const Tour(
      id: 't4',
      cityId: '3',
      agencyId: 'a3',
      title: 'Paris Secret Passages Tour',
      imageUrl:
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1200',
      price: 65,
      duration: '3 hours',
      rating: 4.9,
      reviewCount: 520,
      description: 'Discover the hidden covered passages of Paris - a 19th-century world frozen in time.',
      maxGroupSize: 8,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Expert guide', 'Coffee at a hidden cafe', 'Map booklet']),
  const Tour(
      id: 't5',
      cityId: '4',
      agencyId: 'a4',
      title: 'Ancient Rome Underground',
      imageUrl:
          'https://images.unsplash.com/photo-1552832230-c0197dd311b5?q=80&w=1200',
      price: 75,
      duration: '4 hours',
      rating: 4.9,
      reviewCount: 410,
      description: 'Skip-the-line Colosseum + Forum Romanum + Palatine Hill with an archaeologist guide.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: [
        'Skip-the-line tickets',
        'Archaeologist guide',
        'Gelato stop'
      ]),
  const Tour(
      id: 't6',
      cityId: '5',
      agencyId: 'a5',
      title: 'Tokyo After Dark',
      imageUrl:
          'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=1200',
      price: 55,
      duration: '4 hours',
      rating: 4.8,
      reviewCount: 680,
      description: 'Shibuya crossing at night, hidden ramen bars, karaoke, and the neon glow of Shinjuku.',
      maxGroupSize: 8,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Ramen dinner', 'Guide', 'Karaoke session']),
  const Tour(
      id: 't7',
      cityId: '6',
      agencyId: 'a6',
      title: 'Bosphorus Sunset Cruise',
      imageUrl:
          'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?q=80&w=1200',
      price: 60,
      duration: '3 hours',
      rating: 4.9,
      reviewCount: 390,
      description: 'Sail the legendary Bosphorus Strait as the sun sets over two continents. Tea, meze, and magic.',
      maxGroupSize: 20,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Private boat', 'Turkish tea & meze', 'Sunset photos']),
  const Tour(
      id: 't8',
      cityId: '7',
      agencyId: 'a7',
      title: 'Gaudi Icons & Tapas Evening',
      imageUrl:
          'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?q=80&w=1200',
      price: 58,
      duration: '4 hours',
      rating: 4.8,
      reviewCount: 440,
      description: 'Explore Sagrada Familia surroundings, Park Guell viewpoints, and finish with tapas in a local neighborhood bar.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Tapas tasting', 'Metro tips']),
  const Tour(
      id: 't9',
      cityId: '8',
      agencyId: 'a8',
      title: 'New York Skyline & Food Walk',
      imageUrl:
          'https://images.unsplash.com/photo-1485871981521-5b1fd3805eee?q=80&w=1200',
      price: 72,
      duration: '5 hours',
      rating: 4.7,
      reviewCount: 610,
      description: 'Central Park, Midtown lights, classic bites, and skyline viewpoints with a local storyteller.',
      maxGroupSize: 12,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Food samples', 'Subway orientation']),
  const Tour(
      id: 't10',
      cityId: '9',
      agencyId: 'a9',
      title: 'Dubai Skyline & Desert Dunes',
      imageUrl:
          'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?q=80&w=1200',
      price: 95,
      duration: '1 day',
      rating: 4.8,
      reviewCount: 520,
      description: 'Morning downtown icons, Dubai Creek heritage, and an afternoon desert drive with sunset views.',
      maxGroupSize: 8,
      difficulty: 'Moderate',
      isInstantBook: true,
      includes: ['Transport', 'Guide', 'Desert stop', 'Refreshments']),
  const Tour(
      id: 't11',
      cityId: '10',
      agencyId: 'a10',
      title: 'Table Mountain & Coastal Drive',
      imageUrl:
          'https://images.unsplash.com/photo-1580060839134-75a5edca2e99?q=80&w=1200',
      price: 80,
      duration: '6 hours',
      rating: 4.9,
      reviewCount: 350,
      description: 'Ride up Table Mountain, visit scenic viewpoints, and follow the coast through Cape Town\'s most photogenic routes.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Transport', 'Viewpoint stops']),
  const Tour(
      id: 't12',
      cityId: '11',
      agencyId: 'a11',
      title: 'Sydney Harbour & Bondi Walk',
      imageUrl:
          'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?q=80&w=1200',
      price: 68,
      duration: '5 hours',
      rating: 4.8,
      reviewCount: 420,
      description: 'Opera House views, ferry moments, beach culture, and a relaxed Bondi coastal walk.',
      maxGroupSize: 12,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Ferry tips', 'Beach stop']),
  const Tour(
      id: 't13',
      cityId: '12',
      agencyId: 'a12',
      title: 'Bangkok Temples & Street Food',
      imageUrl:
          'https://images.unsplash.com/photo-1508009603885-50cf7c579365?q=80&w=1200',
      price: 49,
      duration: '4 hours',
      rating: 4.8,
      reviewCount: 690,
      description: 'Grand Palace area, river neighborhoods, market snacks, and essential Bangkok street food in one route.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Street food samples', 'Transit tips']),
  const Tour(
      id: 't14',
      cityId: '13',
      agencyId: 'a13',
      title: 'Almaty Peaks & City Cafes',
      imageUrl:
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1400&q=85',
      price: 62,
      duration: '6 hours',
      rating: 4.8,
      reviewCount: 280,
      description: 'Ride up to Kok Tobe, continue toward Medeu, and finish with Almaty\'s best coffee and local pastry stops.',
      maxGroupSize: 8,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Cable car tips', 'Cafe tasting', 'Transport']),
  const Tour(
      id: 't15',
      cityId: '14',
      agencyId: 'a14',
      title: 'Tashkent Metro & Bazaar Route',
      imageUrl:
          'https://images.unsplash.com/photo-1604328698692-f76ea9498e76?auto=format&fit=crop&w=1400&q=85',
      price: 42,
      duration: '4 hours',
      rating: 4.7,
      reviewCount: 210,
      description: 'Explore tiled metro stations, Chorsu Bazaar, old-town courtyards, bread stalls, and essential Uzbek flavors.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Metro tokens', 'Market tasting', 'Photo stops']),
  const Tour(
      id: 't16',
      cityId: '15',
      agencyId: 'a15',
      title: 'Seoul Palace to Night Market',
      imageUrl:
          'https://images.unsplash.com/photo-1548115184-bc6544d06a58?auto=format&fit=crop&w=1400&q=85',
      price: 70,
      duration: '5 hours',
      rating: 4.9,
      reviewCount: 620,
      description: 'Start at Gyeongbokgung, cross into design neighborhoods, then graze through street food and neon evening streets.',
      maxGroupSize: 8,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: [
        'Guide',
        'Street food',
        'Transit orientation',
        'Palace route'
      ]),
  const Tour(
      id: 't17',
      cityId: '16',
      agencyId: 'a16',
      title: 'Singapore Gardens & Hawker Night',
      imageUrl:
          'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1400&q=85',
      price: 64,
      duration: '4 hours',
      rating: 4.8,
      reviewCount: 510,
      description: 'Pair Gardens by the Bay and Marina views with a guided hawker dinner route through essential local dishes.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: [
        'Guide',
        'Hawker tasting',
        'Light show timing',
        'Transit tips'
      ]),
  const Tour(
      id: 't18',
      cityId: '17',
      agencyId: 'a17',
      title: 'Amsterdam Canals & Masters',
      imageUrl:
          'https://images.unsplash.com/photo-1534351590666-13e3e96b5017?auto=format&fit=crop&w=1400&q=85',
      price: 59,
      duration: '4 hours',
      rating: 4.8,
      reviewCount: 430,
      description: 'Walk the Jordaan canals, decode Dutch Golden Age history, and plan a polished museum afternoon.',
      maxGroupSize: 10,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Canal route', 'Museum planning', 'Coffee stop']),
  const Tour(
      id: 't19',
      cityId: '18',
      agencyId: 'a18',
      title: 'Prague Castle & Riverside Evening',
      imageUrl:
          'https://images.unsplash.com/photo-1519677100203-a0e668c92439?auto=format&fit=crop&w=1400&q=85',
      price: 54,
      duration: '4 hours',
      rating: 4.8,
      reviewCount: 360,
      description: 'Follow castle lanes down to Charles Bridge and finish along the river with old-town stories and beer-hall tips.',
      maxGroupSize: 12,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Castle route', 'Viewpoints', 'Local tips']),
  const Tour(
      id: 't20',
      cityId: '19',
      agencyId: 'a19',
      title: 'London Icons & Borough Bites',
      imageUrl:
          'https://images.unsplash.com/photo-1519003722824-194d4455a60c?auto=format&fit=crop&w=1400&q=85',
      price: 76,
      duration: '5 hours',
      rating: 4.8,
      reviewCount: 740,
      description: 'Connect Tower Bridge, the Thames, hidden lanes, and Borough Market into a smart first-day London route.',
      maxGroupSize: 12,
      difficulty: 'Easy',
      isInstantBook: true,
      includes: ['Guide', 'Food samples', 'Tube orientation', 'Market stops']),
  const Tour(
      id: 't21',
      cityId: '20',
      agencyId: 'a20',
      title: 'Rio Viewpoints & Ipanema Sunset',
      imageUrl:
          'https://images.unsplash.com/photo-1516306580123-e6e52b1b7b5f?auto=format&fit=crop&w=1400&q=85',
      price: 82,
      duration: '6 hours',
      rating: 4.9,
      reviewCount: 410,
      description: 'Time Corcovado views, coastal neighborhoods, beach walks, and a golden-hour finish near Ipanema.',
      maxGroupSize: 8,
      difficulty: 'Moderate',
      isInstantBook: true,
      includes: ['Guide', 'Transport', 'Viewpoint timing', 'Beach stop']),
];

List<Review> reviews = [
  Review(
    id: 'r1',
    cityId: '1',
    userName: 'Sarah M.',
    rating: 5.0,
    comment:
        'Bishkek surprised me completely - the mountains on the horizon, the buzzing bazaars. A hidden gem!',
    date: DateTime(2024, 5, 12),
    userAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
  ),
  Review(
    id: 'r2',
    cityId: '1',
    userName: 'Alex K.',
    rating: 4.5,
    comment:
        'Incredible trekking access from the city. Booked through Kyrgyz Travel and had a perfect trip.',
    date: DateTime(2024, 6, 3),
    userAvatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200',
  ),
  Review(
    id: 'r3',
    cityId: '3',
    userName: 'Emma L.',
    rating: 5.0,
    comment:
        'Paris will always be Paris. Every corner is a postcard. The secret passages tour was unforgettable.',
    date: DateTime(2024, 7, 18),
    userAvatar:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200',
  ),
  Review(
    id: 'r4',
    cityId: '5',
    userName: 'James T.',
    rating: 5.0,
    comment:
        'Tokyo is sensory overload in the best possible way. The Tokyo After Dark tour blew my mind.',
    date: DateTime(2024, 8, 25),
    userAvatar:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
  ),
  Review(
    id: 'r5',
    cityId: '7',
    userName: 'Marta V.',
    rating: 5.0,
    comment:
        'Barcelona was all color, food, and architecture. Park Guell at sunset was a perfect stop.',
    date: DateTime(2024, 9, 9),
    userAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
  ),
  Review(
    id: 'r6',
    cityId: '8',
    userName: 'Daniel R.',
    rating: 4.5,
    comment:
        'New York felt huge but easy to explore with the saved places. Central Park was my reset button.',
    date: DateTime(2024, 10, 2),
    userAvatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200',
  ),
  Review(
    id: 'r7',
    cityId: '9',
    userName: 'Nadia A.',
    rating: 4.8,
    comment:
        'Dubai surprised me most around the creek. The skyline is impressive, but the old districts are special.',
    date: DateTime(2024, 10, 19),
    userAvatar:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200',
  ),
  Review(
    id: 'r8',
    cityId: '10',
    userName: 'Liam C.',
    rating: 5.0,
    comment:
        'Cape Town is one of the most scenic cities I have ever visited. Table Mountain is unforgettable.',
    date: DateTime(2024, 11, 5),
    userAvatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200',
  ),
  Review(
    id: 'r9',
    cityId: '11',
    userName: 'Grace W.',
    rating: 4.8,
    comment:
        'Sydney is easy to love. Opera House views, ferries, Bondi, and sunshine everywhere.',
    date: DateTime(2024, 11, 22),
    userAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
  ),
  Review(
    id: 'r10',
    cityId: '12',
    userName: 'Kenji S.',
    rating: 4.7,
    comment:
        'Bangkok has incredible food and temple details. The market stops were the highlight.',
    date: DateTime(2024, 12, 4),
    userAvatar:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
  ),
  Review(
    id: 'r11',
    cityId: '13',
    userName: 'Aigerim N.',
    rating: 4.8,
    comment:
        'Almaty felt polished but still close to wild mountains. Medeu and the cafe stops made the day easy.',
    date: DateTime(2025, 1, 14),
    userAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r12',
    cityId: '14',
    userName: 'Oliver P.',
    rating: 4.7,
    comment:
        'Tashkent was warmer and more stylish than I expected. The metro stations and Chorsu route were excellent.',
    date: DateTime(2025, 2, 3),
    userAvatar:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r13',
    cityId: '15',
    userName: 'Min J.',
    rating: 5.0,
    comment:
        'Seoul is perfect for travelers who like history by day and food streets by night. The route had great pacing.',
    date: DateTime(2025, 2, 21),
    userAvatar:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r14',
    cityId: '16',
    userName: 'Priya R.',
    rating: 4.8,
    comment:
        'Singapore was effortless to explore. Gardens by the Bay plus hawker food at night was a perfect combination.',
    date: DateTime(2025, 3, 7),
    userAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r15',
    cityId: '17',
    userName: 'Noah V.',
    rating: 4.8,
    comment:
        'Amsterdam is best when you slow down. The Jordaan canal walk and museum planning saved us a lot of time.',
    date: DateTime(2025, 3, 28),
    userAvatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r16',
    cityId: '18',
    userName: 'Klara M.',
    rating: 4.9,
    comment:
        'Prague looked unreal at sunset from the castle side. The route avoided the worst crowds and felt thoughtful.',
    date: DateTime(2025, 4, 12),
    userAvatar:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r17',
    cityId: '19',
    userName: 'Sophie W.',
    rating: 4.8,
    comment:
        'London can feel overwhelming, but the market and Thames route made it click on the first day.',
    date: DateTime(2025, 5, 5),
    userAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r18',
    cityId: '20',
    userName: 'Mateo C.',
    rating: 5.0,
    comment:
        'Rio was pure scenery and music. Ending near Ipanema at sunset was the best travel moment of the trip.',
    date: DateTime(2025, 5, 24),
    userAvatar:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r19',
    cityId: '2',
    userName: 'Hannah B.',
    rating: 4.8,
    comment:
        'Munich was clean, walkable, and full of character. Marienplatz and the English Garden were both easy wins.',
    date: DateTime(2025, 6, 8),
    userAvatar:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r20',
    cityId: '4',
    userName: 'Marco D.',
    rating: 4.9,
    comment:
        'Rome feels like an open-air museum. The ancient route had the right pace and the food stops were excellent.',
    date: DateTime(2025, 6, 19),
    userAvatar:
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=85',
  ),
  Review(
    id: 'r21',
    cityId: '6',
    userName: 'Leyla A.',
    rating: 4.8,
    comment:
        'Istanbul was unforgettable: ferries, mosques, markets, and sunset on the Bosphorus in one beautifully layered day.',
    date: DateTime(2025, 7, 2),
    userAvatar:
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=300&q=85',
  ),
];
