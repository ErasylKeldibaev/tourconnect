import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_strings.dart';
import '../../core/providers/travel_provider.dart';
import '../../widgets/app_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.88);

  Future<void> _enterApp() async {
    HapticFeedback.mediumImpact();
    await context.read<TravelProvider>().completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final introCards = [
      _IntroCardData(
        icon: Icons.travel_explore_rounded,
        title: strings.onboardingExploreTitle,
        text: strings.onboardingExploreBody,
        color: AppColors.primary,
      ),
      _IntroCardData(
        icon: Icons.map_rounded,
        title: strings.onboardingMapTitle,
        text: strings.onboardingMapBody,
        color: AppColors.catSightseeing,
      ),
      _IntroCardData(
        icon: Icons.route_rounded,
        title: strings.onboardingPlanTitle,
        text: strings.onboardingPlanBody,
        color: AppColors.accent,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.36),
                    AppColors.primaryDark.withValues(alpha: 0.94),
                  ],
                  stops: const [0, 0.46, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, top > 0 ? 8 : 20, 24, 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 700;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.explore_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'TourConnect',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        strings.onboardingTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 34 : 42,
                          height: 1.02,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: compact ? 10 : 14),
                      Text(
                        strings.onboardingBody,
                        maxLines: compact ? 3 : 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: compact ? 14 : 16,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: compact ? 16 : 24),
                      SizedBox(
                        height: compact ? 124 : 148,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: introCards.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _IntroCard(data: introCards[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: compact ? 12 : 16),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: introCards.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.accent,
                            dotColor: Colors.white.withValues(alpha: 0.25),
                            dotHeight: 6,
                            dotWidth: 6,
                            expansionFactor: 4,
                            spacing: 8,
                          ),
                        ),
                      ),
                      SizedBox(height: compact ? 16 : 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _enterApp,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(strings.exploreAsGuest),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.primaryDark,
                            padding: EdgeInsets.symmetric(
                              vertical: compact ? 14 : 17,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: compact ? 4 : 10),
                      Center(
                        child: TextButton(
                          onPressed: _enterApp,
                          child: Text(
                            strings.skipIntro,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: bottom + 8),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroCardData {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const _IntroCardData({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });
}

class _IntroCard extends StatelessWidget {
  final _IntroCardData data;

  const _IntroCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(data.icon, color: data.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  data.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
