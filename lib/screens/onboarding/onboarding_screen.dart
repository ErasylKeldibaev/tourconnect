import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../home/main_nav_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardPage> _pages = [
    _OnboardPage(image: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=1200',
        emoji: '🌍', title: 'Discover\nAmazing Places',
        subtitle: 'Explore hand-picked destinations across\nthe globe, curated by local experts.'),
    _OnboardPage(image: 'https://images.unsplash.com/photo-1506929562872-bb421503ef21?q=80&w=1200',
        emoji: '🗺️', title: 'Plan Your\nPerfect Trip',
        subtitle: 'Build a personalised itinerary for every\ncity with our intuitive trip planner.'),
    _OnboardPage(image: 'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?q=80&w=1200',
        emoji: '🤝', title: 'Connect with\nLocal Guides',
        subtitle: 'Book verified tours and connect with\ntrusted local agencies instantly.'),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _goToMain();
    }
  }

  void _goToMain() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const MainNavScreen(),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, index) => _OnboardPageView(page: _pages[index]),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16, right: 24,
            child: TextButton(
              onPressed: _goToMain,
              child: Text('Skip', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
            ),
          ),
          Positioned(
            bottom: 50, left: 32, right: 32,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController, count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withValues(alpha: 0.4),
                    dotHeight: 8, dotWidth: 8, expansionFactor: 3,
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                      style: const TextStyle(color: AppColors.primary, fontSize: 17, fontWeight: FontWeight.w700),
                    ),
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

class _OnboardPage {
  final String image, emoji, title, subtitle;
  const _OnboardPage({required this.image, required this.emoji, required this.title, required this.subtitle});
}

class _OnboardPageView extends StatelessWidget {
  final _OnboardPage page;
  const _OnboardPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(page.image, fit: BoxFit.cover),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0x55000000), Color(0xEE000000)], stops: [0.3, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 180, left: 32, right: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(page.emoji, style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 16),
              Text(page.title, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -0.5)),
              const SizedBox(height: 16),
              Text(page.subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 16, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}