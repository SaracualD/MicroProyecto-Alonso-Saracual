import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
  static const String _scoresKey = 'high_scores';

  static Future<void> saveScore(String difficulty, String name, int time, String date) async {
    final String? scoresString = _prefs.getString(_scoresKey);
    Map<String, dynamic> allScores = {};
    
    if (scoresString != null) {
      allScores = Map<String, dynamic>.from(json.decode(scoresString));
    }

    if (!allScores.containsKey(difficulty)) {
      allScores[difficulty] = [];
    }

    List<dynamic> diffScores = List.from(allScores[difficulty]);
    diffScores.add({
      'name': name,
      'time': time,
      'date': date,
    });

    diffScores.sort((a, b) => (a['time'] as int).compareTo(b['time'] as int));
    allScores[difficulty] = diffScores;

    await _prefs.setString(_scoresKey, json.encode(allScores));
  }

  static Map<String, List<Map<String, dynamic>>> loadScores() {
    final String? scoresString = _prefs.getString(_scoresKey);
    if (scoresString == null) {
      return {'Fácil': [], 'Medio': [], 'Difícil': []};
    }

    final Map<String, dynamic> decoded = json.decode(scoresString);
    Map<String, List<Map<String, dynamic>>> result = {};

    decoded.forEach((key, value) {
      result[key] = List<Map<String, dynamic>>.from(value);
    });
    return result;
  }

  static Future<void> clearAllScores() async {
    await _prefs.remove(_scoresKey);
  }

}