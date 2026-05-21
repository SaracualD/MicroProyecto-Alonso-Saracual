import 'package:flutter/material.dart';
import 'services/storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await StorageService.init(); 
  runApp(const BuscaMinasApp());
}

class BuscaMinasApp extends StatefulWidget {
  const BuscaMinasApp({Key? key}) : super(key: key);

  @override
  State<BuscaMinasApp> createState() => _BuscaMinasAppState();
}

class _BuscaMinasAppState extends State<BuscaMinasApp> {
  bool isDarkMode = StorageService.getTheme();

  // Función para cambiar el tema en tiempo real
  void toggleTheme(bool dark) {
    setState(() {
      isDarkMode = dark;
      StorageService.saveTheme(dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      
      // La ruta inicial del juego
      initialRoute: '/splash', 
      
      // El mapa de rutas (Comentado temporalmente para que no dé error de compilación)
      routes: {
        // '/splash': (context) => const SplashScreen(),
        // '/menu': (context) => MainMenu(onThemeChanged: toggleTheme),
      },
    );
  }
}