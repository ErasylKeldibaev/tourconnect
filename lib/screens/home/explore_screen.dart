import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../data/dummy_data.dart';
import '../../widgets/city_card.dart';
import '../city/city_details_screen.dart';
import '../profile/profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredCities = cities
        .where((city) => city.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore the World',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover the most beautiful cities',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 32),
                    const Text(
                      'Popular Destinations',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final city = filteredCities[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: CityCard(
                      city: city,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CityDetailsScreen(city: city)),
                      ),
                    ),
                  );
                },
                childCount: filteredCities.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          ),
          icon: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchText = value),
        decoration: const InputDecoration(
          hintText: 'Search city...',
          icon: Icon(Icons.search, color: Colors.blue),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
