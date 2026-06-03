import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../core/utils/app_utils.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../widgets/app_image.dart';

class TripPlannerScreen extends StatelessWidget {
  final City city;
  const TripPlannerScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final cityPlaces = places.where((p) => p.cityId == city.id).toList();

    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final plan = provider.getPlanForCity(city.id);
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('${city.name} Planner',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            actions: [
              if (plan.isNotEmpty)
                TextButton(
                  onPressed: () => AppUtils.showSnackBar(context, 'Exporting itinerary...'),
                  child: const Text('Export', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          body: Column(
            children: [
              if (plan.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text('${plan.length} place${plan.length != 1 ? 's' : ''} in your itinerary',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                      const Spacer(),
                      Text('~${plan.length * 2}h total', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              Expanded(
                child: Row(
                  children: [
                    // Left: Available places
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text('Add to Plan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          ),
                          Expanded(
                            child: cityPlaces.isEmpty
                                ? const Center(child: Text('No places', style: TextStyle(color: AppColors.textHint)))
                                : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              physics: const BouncingScrollPhysics(),
                              itemCount: cityPlaces.length,
                              itemBuilder: (_, i) {
                                final place = cityPlaces[i];
                                final inPlan = provider.isPlaceInPlan(city.id, place.id);
                                return GestureDetector(
                                  onTap: () {
                                    provider.togglePlaceInPlan(city.id, place);
                                    AppUtils.showSnackBar(context,
                                        inPlan ? '${place.name} removed' : '${place.name} added!');
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: inPlan ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: inPlan ? AppColors.primary : AppColors.divider,
                                        width: inPlan ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(13)),
                                          child: AppImage(imageUrl: place.imageUrl, width: 64, height: 64, fit: BoxFit.cover),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            Text(place.category, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                                          ],
                                        )),
                                        Padding(padding: const EdgeInsets.only(right: 10),
                                            child: Icon(
                                                inPlan ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                                                color: inPlan ? AppColors.primary : AppColors.textHint, size: 22)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, color: AppColors.divider, margin: const EdgeInsets.symmetric(vertical: 12)),
                    // Right: Your plan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(children: [
                              const Text('Your Plan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              const SizedBox(width: 6),
                              if (plan.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                                  child: Text('${plan.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                            ]),
                          ),
                          Expanded(
                            child: plan.isEmpty
                                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.add_location_alt_outlined, size: 40, color: Colors.grey[300]),
                              const SizedBox(height: 10),
                              const Text('Add places\nfrom the left', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textHint, fontSize: 13)),
                            ]))
                                : ReorderableListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              physics: const BouncingScrollPhysics(),
                              itemCount: plan.length,
                              onReorder: (oldIndex, newIndex) => provider.reorderPlan(city.id, oldIndex, newIndex),
                              itemBuilder: (_, i) {
                                final place = plan[i];
                                return Container(
                                  key: ValueKey(place.id),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.divider)),
                                  child: Row(children: [
                                    Container(
                                      width: 24, height: 24,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                      child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                    const Icon(Icons.drag_handle_rounded, color: AppColors.textHint, size: 18),
                                  ]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}