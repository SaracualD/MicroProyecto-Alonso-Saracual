import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'config_screen.dart';
import 'instructions_screen.dart'; 
import 'high_scores_screen.dart'; 

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade800],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '💣 BUSCAMINAS 💥',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))],
                  ),
                ),
                const SizedBox(height: 40),
                _buildMenuButton(context, '🕹️ JUGAR', const GameScreen()),
                
                _buildMenuButton(context, '🏆 MARCADORES', const HighScoresScreen()), 
                
                _buildMenuButton(context, '⚙️ CONFIGURACIÓN', const ConfigScreen()),
                _buildMenuButton(context, '📖 CÓMO JUGAR', const InstructionsScreen()), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, Widget targetScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 260,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => targetScreen));
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}