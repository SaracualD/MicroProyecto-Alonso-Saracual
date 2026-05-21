import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HighScoresScreen extends StatefulWidget {
  const HighScoresScreen({super.key});

  @override
  State<HighScoresScreen> createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  late Map<String, List<Map<String, dynamic>>> _allScores;

  @override
  void initState() {
    super.initState();
    _loadCurrentScores();
  }

  void _loadCurrentScores() {
    setState(() {
      _allScores = StorageService.loadScores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🏆 Récords Mundiales', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Fácil (6x6)'),
              Tab(text: 'Medio (8x8)'),
              Tab(text: 'Difícil (10x10)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildScoresList(_allScores['Fácil'] ?? [], 'Fácil'),
            _buildScoresList(_allScores['Medio'] ?? [], 'Medio'),
            _buildScoresList(_allScores['Difícil'] ?? [], 'Difícil'),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _confirmDeleteScores,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Borrar todos los marcadores'),
          ),
        ),
      ),
    );
  }

  Widget _buildScoresList(List<Map<String, dynamic>> scores, String difficulty) {
    if (scores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 15),
            Text(
              'Aún no tienes registros en nivel $difficulty.\n¡Juega tu primera partida!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: scores.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final score = scores[index];
        
        Widget leadingIcon;
        Color cardColor = Colors.white;
        if (index == 0) {
          leadingIcon = const Icon(Icons.workspace_premium, color: Colors.amber, size: 30);
          cardColor = Colors.amber.shade50;
        } else if (index == 1) {
          leadingIcon = const Icon(Icons.workspace_premium, color: Colors.grey, size: 28);
          cardColor = Colors.grey.shade100;
        } else {
          leadingIcon = CircleAvatar(
            radius: 14,
            child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
          );
        }

        int time = score['time'];
        String formattedTime = '${(time ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}';

        return Card(
          color: cardColor,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: leadingIcon,
            title: Text(score['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Fecha: ${score['date']}'),
            trailing: Text(formattedTime, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)),
          ),
        );
      },
    );
  }

  void _confirmDeleteScores() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ ¿Borrar registros?'),
        content: const Text('Esta acción eliminará de forma permanente todos los récords locales.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await StorageService.clearAllScores();
              Navigator.pop(context);
              _loadCurrentScores(); // Recarga la vista limpia en tiempo real
            },
            child: const Text('Sí, borrar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}