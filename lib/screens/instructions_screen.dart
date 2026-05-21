import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CÓMO JUGAR'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInstructionCard(
              '🎯 Objetivo del Juego',
              'Descubre todas las casillas del tablero que no contengan minas ocultas. Si revelas una mina, pierdes inmediatamente.',
              Icons.stars,
            ),
            _buildInstructionCard(
              '🔍 Revelar Casillas',
              'Haz un toque corto sobre cualquier celda para descubrir qué hay debajo. Los números indican cuántas minas hay en las 8 casillas adyacentes.',
              Icons.touch_app,
            ),
            _buildInstructionCard(
              '🚩 Colocar Banderas',
              'Mantén presionada una casilla (toque largo) para colocar una bandera roja en las celdas donde sospeches fuertemente que hay una mina.',
              Icons.flag,
            ),
            _buildInstructionCard(
              '🌊 Expansión Automática',
              'Si revelas una casilla vacía (0 minas adyacentes), el juego descubrirá automáticamente todas las casillas vecinas seguras.',
              Icons.waves,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard(String title, String content, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: Colors.blue.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}