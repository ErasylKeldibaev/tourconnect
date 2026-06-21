import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/travel_provider.dart';
import '../../data/dummy_data.dart';
import '../../models/city_model.dart';
import '../../models/place_model.dart';
import '../../widgets/app_image.dart';

class TripPlannerScreen extends StatelessWidget {
  final City city;
  const TripPlannerScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final cityPlaces = places.where((place) => place.cityId == city.id).toList()
      ..sort((a, b) {
        if (a.isPopular != b.isPopular) return a.isPopular ? -1 : 1;
        final rating = b.rating.compareTo(a.rating);
        if (rating != 0) return rating;
        return b.reviewCount.compareTo(a.reviewCount);
      });

    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        final plan = provider.getPlanForCity(city.id);
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              '${city.name} Planner',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              if (plan.isNotEmpty)
                PopupMenuButton<_PlannerAction>(
                  tooltip: 'Planner actions',
                  icon: const Icon(Icons.more_horiz_rounded),
                  onSelected: (action) {
                    switch (action) {
                      case _PlannerAction.copy:
                        _showItinerarySheet(context, city, plan);
                        break;
                      case _PlannerAction.clear:
                        _confirmClearPlan(context, provider);
                        break;
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _PlannerAction.copy,
                      child: ListTile(
                        leading: Icon(Icons.copy_rounded),
                        title: Text('Copy itinerary'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: _PlannerAction.clear,
                      child: ListTile(
                        leading: Icon(Icons.delete_outline_rounded),
                        title: Text('Clear plan'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;
              final content = _PlannerContent(
                city: city,
                cityPlaces: cityPlaces,
                plan: plan,
                isWide: isWide,
                onTogglePlace: (place) => _togglePlace(context, provider, place),
                onReorder: (oldIndex, newIndex) =>
                    provider.reorderPlan(city.id, oldIndex, newIndex),
                onCopy: plan.isEmpty
                    ? null
                    : () => _showItinerarySheet(context, city, plan),
                onClear: plan.isEmpty
                    ? null
                    : () => _confirmClearPlan(context, provider),
              );

              if (isWide) return content;
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    _PlannerHeader(city: city, plan: plan),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: _PlannerTabs(),
                    ),
                    Expanded(child: content),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _togglePlace(
    BuildContext context,
    TravelProvider provider,
    Place place,
  ) {
    final inPlan = provider.isPlaceInPlan(city.id, place.id);
    HapticFeedback.selectionClick();
    provider.togglePlaceInPlan(city.id, place);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(inPlan ? '${place.name} removed' : '${place.name} added'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _confirmClearPlan(
    BuildContext context,
    TravelProvider provider,
  ) async {
    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear this plan?'),
        content: Text('Remove every saved stop from your ${city.name} route.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    provider.clearPlan(city.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Plan cleared'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showItinerarySheet(BuildContext context, City city, List<Place> plan) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ItinerarySheet(city: city, plan: plan),
    );
  }
}

enum _PlannerAction { copy, clear }

class _PlannerContent extends StatelessWidget {
  final City city;
  final List<Place> cityPlaces;
  final List<Place> plan;
  final bool isWide;
  final ValueChanged<Place> onTogglePlace;
  final ReorderCallback onReorder;
  final VoidCallback? onCopy;
  final VoidCallback? onClear;

  const _PlannerContent({
    required this.city,
    required this.cityPlaces,
    required this.plan,
    required this.isWide,
    required this.onTogglePlace,
    required this.onReorder,
    required this.onCopy,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (!isWide) {
      return TabBarView(
        children: [
          _AvailablePlacesPane(
            city: city,
            places: cityPlaces,
            onTogglePlace: onTogglePlace,
          ),
          _PlanPane(
            city: city,
            plan: plan,
            onReorder: onReorder,
            onCopy: onCopy,
            onClear: onClear,
          ),
        ],
      );
    }

    return Column(
      children: [
        _PlannerHeader(city: city, plan: plan),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _AvailablePlacesPane(
                  city: city,
                  places: cityPlaces,
                  onTogglePlace: onTogglePlace,
                ),
              ),
              Container(
                width: 1,
                color: AppColors.divider,
                margin: const EdgeInsets.symmetric(vertical: 12),
              ),
              Expanded(
                child: _PlanPane(
                  city: city,
                  plan: plan,
                  onReorder: onReorder,
                  onCopy: onCopy,
                  onClear: onClear,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlannerHeader extends StatelessWidget {
  final City city;
  final List<Place> plan;

  const _PlannerHeader({required this.city, required this.plan});

  @override
  Widget build(BuildContext context) {
    final hasPlan = plan.isNotEmpty;
    final categories = plan.map((place) => place.category).toSet().length;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasPlan
                      ? '${plan.length} stop${plan.length == 1 ? '' : 's'} in your ${city.name} route'
                      : 'Build your ${city.name} route',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    height: 1.16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                hasPlan ? '~${plan.length * 2}h' : '0h',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _HeaderMetric(
                icon: Icons.place_rounded,
                label: hasPlan ? '${plan.length} stops' : 'No stops',
              ),
              const SizedBox(width: 8),
              _HeaderMetric(
                icon: Icons.category_rounded,
                label: hasPlan ? '$categories types' : 'Pick places',
              ),
              const SizedBox(width: 8),
              _HeaderMetric(
                icon: Icons.drag_handle_rounded,
                label: hasPlan ? 'Drag order' : 'Then reorder',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderMetric({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 15),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlannerTabs extends StatelessWidget {
  const _PlannerTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: const TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_location_alt_rounded, size: 18),
                SizedBox(width: 6),
                Text('Add'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.route_rounded, size: 18),
                SizedBox(width: 6),
                Text('Plan'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailablePlacesPane extends StatelessWidget {
  final City city;
  final List<Place> places;
  final ValueChanged<Place> onTogglePlace;

  const _AvailablePlacesPane({
    required this.city,
    required this.places,
    required this.onTogglePlace,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Add to Plan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: places.isEmpty
                  ? const _PlannerEmptyState(
                      icon: Icons.place_outlined,
                      title: 'No places yet',
                      body: 'This destination has no catalog places.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: places.length,
                      itemBuilder: (_, index) {
                        final place = places[index];
                        final inPlan = provider.isPlaceInPlan(city.id, place.id);
                        return _AvailablePlaceTile(
                          place: place,
                          inPlan: inPlan,
                          onTap: () => onTogglePlace(place),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _AvailablePlaceTile extends StatelessWidget {
  final Place place;
  final bool inPlan;
  final VoidCallback onTap;

  const _AvailablePlaceTile({
    required this.place,
    required this.inPlan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              child: AppImage(
                imageUrl: place.imageUrl,
                width: 76,
                height: 78,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          place.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star_rounded,
                          color: AppColors.starColor, size: 13),
                      const SizedBox(width: 2),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Tooltip(
                message: inPlan ? 'In plan' : 'Add to plan',
                child: Icon(
                  inPlan ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                  color: inPlan ? AppColors.primary : AppColors.textHint,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanPane extends StatelessWidget {
  final City city;
  final List<Place> plan;
  final ReorderCallback onReorder;
  final VoidCallback? onCopy;
  final VoidCallback? onClear;

  const _PlanPane({
    required this.city,
    required this.plan,
    required this.onReorder,
    required this.onCopy,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              const Text(
                'Your Plan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              if (plan.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${plan.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              const Spacer(),
              if (plan.isNotEmpty) ...[
                IconButton(
                  tooltip: 'Copy itinerary',
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded),
                  color: AppColors.primary,
                ),
                IconButton(
                  tooltip: 'Clear plan',
                  onPressed: onClear,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: AppColors.textHint,
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: plan.isEmpty
              ? const _PlannerEmptyState(
                  icon: Icons.add_location_alt_outlined,
                  title: 'No stops yet',
                  body: 'Add places, then drag them into the order you want.',
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: plan.length,
                  onReorder: onReorder,
                  itemBuilder: (_, index) {
                    final place = plan[index];
                    return _PlanStopTile(
                      key: ValueKey(place.id),
                      index: index,
                      place: place,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _PlanStopTile extends StatelessWidget {
  final int index;
  final Place place;

  const _PlanStopTile({
    super.key,
    required this.index,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  place.address,
                  style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.drag_handle_rounded, color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }
}

class _PlannerEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _PlannerEmptyState({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItinerarySheet extends StatelessWidget {
  final City city;
  final List<Place> plan;

  const _ItinerarySheet({required this.city, required this.plan});

  String get _summary {
    final buffer = StringBuffer()
      ..writeln('${city.name} itinerary')
      ..writeln('${plan.length} places / approx. ${plan.length * 2}h')
      ..writeln();

    for (var i = 0; i < plan.length; i++) {
      final place = plan[i];
      buffer.writeln('${i + 1}. ${place.name} - ${place.category}');
      buffer.writeln('   ${place.address}');
    }
    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, bottom + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              '${city.name} itinerary',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${plan.length} places / approx. ${plan.length * 2}h total',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.42,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: plan.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final place = plan[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${place.category} / ${place.address}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _summary));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Itinerary copied'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copy itinerary'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
