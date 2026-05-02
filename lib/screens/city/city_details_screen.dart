import 'package:flutter/material.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';
import '../places/places_screen.dart';
import '../tours/tours_screen.dart';
import '../agencies/agencies_screen.dart';
import '../trip_planner/trip_planner_screen.dart';
import '../reviews/reviews_screen.dart';
import 'package:animate_do/animate_do.dart';

class CityDetailsScreen extends StatelessWidget {
  final City city;

  const CityDetailsScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: _buildHeaderInfo(context),
                  ),
                  const SizedBox(height: 40),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Explore the City',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildNavigationGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          child: const BackButton(color: Colors.black),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'city-image-${city.id}',
              child: AppImage(imageUrl: city.imageUrl),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 24,
              child: FadeInLeft(
                child: Text(
                  city.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 4),
            Text(
              city.country,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(Icons.star, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            const Text('4.8 (1,240 Reviews)', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'About',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          city.description,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    final navItems = [
      {'icon': Icons.place_rounded, 'title': 'Places', 'color': Colors.blue, 'screen': PlacesScreen(city: city)},
      {'icon': Icons.explore_rounded, 'title': 'Tours', 'color': Colors.orange, 'screen': ToursScreen(city: city)},
      {'icon': Icons.business_rounded, 'title': 'Agencies', 'color': Colors.green, 'screen': AgenciesScreen(city: city)},
      {'icon': Icons.calendar_today_rounded, 'title': 'Planner', 'color': Colors.purple, 'screen': TripPlannerScreen(city: city)},
      {'icon': Icons.rate_review_rounded, 'title': 'Reviews', 'color': Colors.redAccent, 'screen': ReviewsScreen(city: city)},
    ];

    return Column(
      children: List.generate(navItems.length, (index) {
        final item = navItems[index];
        return FadeInUp(
          delay: Duration(milliseconds: 300 + (index * 100)),
          child: _CategoryTile(
            icon: item['icon'] as IconData,
            title: item['title'] as String,
            color: item['color'] as Color,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item['screen'] as Widget),
            ),
          ),
        );
      }),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
