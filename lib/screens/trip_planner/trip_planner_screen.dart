import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/travel_provider.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';

class TripPlannerScreen extends StatelessWidget {
  final City city;
  const TripPlannerScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final cityPlaces = places.where((p) => p.cityId == city.id).toList();
    final travelProvider = Provider.of<TravelProvider>(context);
    final selectedPlaces = travelProvider.getPlanForCity(city.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Planner'),
        actions: [
          if (selectedPlaces.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              onPressed: () {
                // Можно добавить метод очистки в провайдер
              },
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSelection(context, travelProvider, cityPlaces, selectedPlaces),
          const Divider(height: 1),
          Expanded(
            child: selectedPlaces.isEmpty
                ? _buildEmptyPlanner()
                : _buildRouteTimeline(context, travelProvider, selectedPlaces),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSelection(BuildContext context, TravelProvider provider, List<Place> available, List<Place> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text('Add places to your route', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: available.length,
            itemBuilder: (context, index) {
              final place = available[index];
              final isAdded = selected.contains(place);
              return GestureDetector(
                onTap: () => provider.togglePlaceInPlan(city.id, place),
                child: Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 12, bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(place.imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: isAdded ? ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken) : null,
                    ),
                  ),
                  child: isAdded ? const Center(child: Icon(Icons.check_circle, color: Colors.white)) : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildRouteTimeline(BuildContext context, TravelProvider provider, List<Place> selected) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: selected.length,
      itemBuilder: (context, index) {
        final place = selected[index];
        return Row(
          children: [
            Column(
              children: [
                CircleAvatar(radius: 12, backgroundColor: Theme.of(context).primaryColor, child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10))),
                if (index != selected.length - 1) Container(width: 2, height: 40, color: Theme.of(context).primaryColor.withOpacity(0.2)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(place.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => provider.togglePlaceInPlan(city.id, place),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyPlanner() {
    return const Center(child: Text('Your route is empty', style: TextStyle(color: Colors.grey)));
  }
}
