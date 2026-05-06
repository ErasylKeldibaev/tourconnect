import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../widgets/app_image.dart';
import '../city/city_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Explore Map', style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1200',
                      fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                    ),
                  ),
                  ...cities.asMap().entries.map((entry) {
                    final isSelected = entry.key == _selectedIndex;
                    return Positioned(
                      left: 40.0 + (entry.key * 55),
                      top: 60.0 + (entry.key % 3) * 50,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIndex = entry.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: isSelected ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6) : const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(isSelected ? 20 : 50),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))],
                          ),
                          child: isSelected
                              ? Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.location_on_rounded, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(entry.value.name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                          ])
                              : const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                        ),
                      ),
                    );
                  }),
                  Positioned(top: 16, right: 16,
                      child: Container(padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
                          child: const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 20))),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text('All Destinations', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: cities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final isSelected = index == _selectedIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = index);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CityDetailsScreen(city: city)));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider, width: isSelected ? 2 : 1),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                child: AppImage(imageUrl: city.imageUrl, width: double.infinity, fit: BoxFit.cover),
                              )),
                              Padding(padding: const EdgeInsets.all(10), child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(city.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                                  Text(city.country, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                                ],
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}