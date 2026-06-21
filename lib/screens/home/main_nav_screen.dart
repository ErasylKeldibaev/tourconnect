import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/travel_provider.dart';
import 'explore_screen.dart';
import '../favorites/favorites_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  static final List<Widget> _screens = [
    const ExploreScreen(),
    const MapScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  void _onTabTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.mediumImpact();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial for floating navbar effect
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _FloatingBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }
}

class _FloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingBottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final items = [
      _TabItem(Icons.explore_rounded, Icons.explore_outlined, strings.navExplore),
      _TabItem(Icons.map_rounded, Icons.map_outlined, strings.navMap),
      _TabItem(
        Icons.favorite_rounded,
        Icons.favorite_border_rounded,
        strings.navSaved,
      ),
      _TabItem(Icons.person_rounded, Icons.person_outline_rounded, strings.navProfile),
    ];

    return Container(
      margin: EdgeInsets.fromLTRB(24, 0, 24, bottomPad > 0 ? bottomPad : 20),
      height: 72,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isSelected = i == currentIndex;

                return Tooltip(
                  message: item.label,
                  child: Semantics(
                    label: item.label,
                    selected: isSelected,
                    button: true,
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _NavItemIcon(
                            item: item,
                            isSelected: isSelected,
                            isSaved: i == 2,
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isSelected ? 4 : 0,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemIcon extends StatelessWidget {
  final _TabItem item;
  final bool isSelected;
  final bool isSaved;

  const _NavItemIcon({
    required this.item,
    required this.isSelected,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon;
    if (isSaved) {
      icon = Consumer<TravelProvider>(
        builder: (context, provider, child) => _BadgedIcon(
          icon: isSelected ? item.activeIcon : item.icon,
          isSelected: isSelected,
          count: provider.totalFavoritesCount,
        ),
      );
    } else {
      icon = Icon(
        isSelected ? item.activeIcon : item.icon,
        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
        size: 26,
      );
    }

    return AnimatedScale(
      scale: isSelected ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: icon,
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final int count;
  const _BadgedIcon({required this.icon, required this.isSelected, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
          size: 26,
        ),
        if (count > 0)
          Positioned(
            top: -2,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text(
                count > 9 ? '9+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TabItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  const _TabItem(this.activeIcon, this.icon, this.label);
}
