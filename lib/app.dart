import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'core/theme/app_theme.dart';

class TourConnectApp extends StatelessWidget {
  const TourConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TourConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
