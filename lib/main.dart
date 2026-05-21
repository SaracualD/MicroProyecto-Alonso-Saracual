import 'package:flutter/material.dart';
import 'services/storage_service.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await StorageService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscaminas UNIMET',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: StorageService.getTheme() ? Brightness.dark : Brightness.light, // Lee el tema real
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}