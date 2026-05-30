import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/providers/travel_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yjgwwviuacwwlcdtpbei.supabase.co',          // <- замени на свой URL
    anonKey: 'sb_publishable_YHqcR7GbCAKjWvFjgG5saw_ej5-WVVS', // <- замени на свой anon key
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TravelProvider()),
      ],
      child: const TourConnectApp(),
    ),
  );
}