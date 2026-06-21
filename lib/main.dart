import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/providers/travel_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await _initializeSupabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TravelProvider()),
      ],
      child: const TourConnectApp(),
    ),
  );
}

Future<void> _initializeSupabase() async {
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'tourconnect.bootstrap',
        context: ErrorDescription('while initializing Supabase'),
      ),
    );
  }
}
