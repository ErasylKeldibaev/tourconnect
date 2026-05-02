import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/providers/travel_provider.dart';

void main() {
  // Убрали Firebase для стабильного запуска без конфиг-файлов
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TravelProvider()),
      ],
      child: const TourConnectApp(),
    ),
  );
}
