import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/providers/travel_provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/home/main_nav_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';

class TourConnectApp extends StatelessWidget {
  const TourConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final travel = context.watch<TravelProvider>();

    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      locale: Locale(travel.languageCode),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      theme: AppTheme.lightTheme,
      home: const _AppGate(),
    );
  }
}

class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    final travel = context.watch<TravelProvider>();

    if (!travel.initialized) return const SplashScreen();
    if (!travel.onboardingComplete) return const OnboardingScreen();

    return const AnimatedSwitcher(
      duration: Duration(milliseconds: 250),
      child: MainNavScreen(),
    );
  }
}
