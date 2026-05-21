import 'package:flutter/material.dart';

// Variable global simple temporal para manejar la dificultad seleccionada
String globalDifficulty = 'Fácil'; 

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONFIGURACIÓN'),
        backgroundColor: Colors.amber.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: ListTile(
            title: const Text('🎯 Dificultad del Tablero', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: DropdownButton<String>(
              value: globalDifficulty,
              items: ['Fácil', 'Medio', 'Difícil'].map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
              onChanged: (String? newVal) {
                setState(() {
                  globalDifficulty = newVal!;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}