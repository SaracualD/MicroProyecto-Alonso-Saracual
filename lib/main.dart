import 'package:flutter/material.dart';
import 'services/storage_service.dart'; 
import 'screens/splash_screen.dart';
import 'screens/menu_screen.dart'; 
import 'screens/game_screen.dart';
import 'screens/high_scores_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const BuscaMinasApp());
}

class BuscaMinasApp extends StatefulWidget {
  const BuscaMinasApp({super.key});

  @override
  State<BuscaMinasApp> createState() => _BuscaMinasAppState();
}

class _BuscaMinasAppState extends State<BuscaMinasApp> {
  bool isDarkMode = StorageService.getTheme();

  void toggleTheme(bool dark) {
    setState(() {
      isDarkMode = dark;
      StorageService.saveTheme(dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas UNIMET',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode 
          ? ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue) 
          : ThemeData(brightness: Brightness.light, primarySwatch: Colors.blue),
      initialRoute: '/splash', 
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/menu': (context) => MenuScreen(onThemeChanged: toggleTheme), 
        '/game': (context) => const GameScreen(),
        '/scores': (context) => const HighScoresScreen(),
      },
    );
  }
}