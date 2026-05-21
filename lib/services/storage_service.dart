import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  
  static Future<void> saveDifficulty(int level) async {
    await _prefs.setInt('difficulty', level);
  }
  
  static int getDifficulty() {
    return _prefs.getInt('difficulty') ?? 1; 
  }

  // Guarda y lee el Tema (true = oscuro, false = claro)
  static Future<void> saveTheme(bool isDark) async {
    await _prefs.setBool('isDark', isDark);
  }
  
  static bool getTheme() {
    return _prefs.getBool('isDark') ?? false; 
  }
}