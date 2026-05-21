import 'package:flutter/material.dart';
import 'package:micro_proyecto_alonso_saracual/logic/game_engine.dart';
import 'package:micro_proyecto_alonso_saracual/models/cell_model.dart';
import '../services/storage_service.dart';
import 'config_screen.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _ThemeColors {
  static const Color hidden = Color(0xFF9E9E9E); // Gris intermedio para celdas tapadas
  static const Color revealed = Color(0xFFE0E0E0); // Gris claro para fondo revelado
}

class _GameScreenState extends State<GameScreen> {
  late GameEngine _engine;
  late int _rows;
  late int _cols;
  late int _mines;
  bool _gameOver = false;
  int _lives = 3;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _timerStarted = false;
  int _flagCount = 0;
  bool _hasWon = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
    _timerStarted = true;
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _setupDifficulty();
    _initEngine();
  }

  void _setupDifficulty() {
    int level = StorageService.getDifficulty();

    if (level == 1) {
      _rows = 6;
      _cols = 6;
      _mines = 10;
      globalDifficulty = 'Fácil'; 
    } else if (level == 2) {
      _rows = 8;
      _cols = 8;
      _mines = 20;
      globalDifficulty = 'Medio';
    } else {
      _rows = 10;
      _cols = 10;
      _mines = 30;
      globalDifficulty = 'Difícil';
    }
  }

  void _initEngine() {
    _stopTimer();
    _engine = GameEngine(_rows, _cols, _mines);
    _gameOver = false;
    _hasWon = false;
    _lives = 3;
    _secondsElapsed = 0;
    _timerStarted = false;
    _flagCount = 0;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _checkGameStatus() {
    bool win = true;
    bool hitMineThisTurn = false;

    for (var row in _engine.board) {
      for (var cell in row) {
        if (cell.isMine && cell.isRevealed && !_gameOver) {
          hitMineThisTurn = true;
        }
        if (!cell.isMine && !cell.isRevealed) {
          win = false;
        }
      }
    }

    if (win) {
      _hasWon = true;
      _stopTimer();

      // Cuando el usuario gana, preparamos los datos del registro
      final String hoy = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      
      // Delay de seguridad para renderizar el último clic antes de abrir el diálogo
      Future.delayed(const Duration(milliseconds: 300), () {
        _showVictoryDialog(globalDifficulty, _secondsElapsed, hoy);
      });
    }
  }

  void _showVictoryDialog(String dificultad, int tiempo, String fecha) {
    final TextEditingController nameController = TextEditingController(text: 'Jugador');
    
    showDialog(
      context: context,
      barrierDismissible: false, // Obligatorio interactuar para guardar el récord
      builder: (context) => AlertDialog(
        title: const Text('🎉 ¡Felicidades, Ganaste! 🏆'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Completaste el nivel $dificultad con éxito.'),
            const SizedBox(height: 8),
            Text('Tiempo total: $tiempo segundos.'),
            const SizedBox(height: 15),
            const Text('Ingresa tu nombre para el registro:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Tu nombre'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              String playerName = nameController.text.trim();
              if (playerName.isEmpty) playerName = 'Anónimo';
              
              // Almacenar el récord en SharedPreferences mediante los métodos agregados
              await StorageService.saveScore(dificultad, playerName, tiempo, fecha);
              if (!mounted) return;
              Navigator.pop(context); // Cerrar ventana emergente
              Navigator.pop(context); // Volver al menú principal
            },
            child: const Text('Guardar Récord'),
          ),
        ],
      ),
    );
  }

  void _revealAll() {
    for (var row in _engine.board) {
      for (var cell in row) {
        if (cell.isMine) cell.isRevealed = true;
      }
    }
  }

  Color _getNumberColor(int n) {
    switch (n) {
      case 1: return Colors.blue;
      case 2: return Colors.green;
      case 3: return Colors.red;
      default: return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    _setupDifficulty();
    return Scaffold(
      appBar: AppBar(
        title: Text('BUSCAMINAS ($globalDifficulty)'),
        backgroundColor: Colors.red.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initEngine()),
          )
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Toque Corto: Revelar | Toque Largo: Bandera 🚩',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.brightness_7, color: Colors.orange, size: 24),
                    const SizedBox(width: 6),
                    Text(
                      'Minas: ${_mines - _flagCount}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.blue, size: 24),
                    const SizedBox(width: 6),
                    Text(
                      'Tiempo: ${(_secondsElapsed ~/ 60).toString().padLeft(2, '0')}:${(_secondsElapsed % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Vidas: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(3, (index) {
                    return Icon(
                      index < _lives ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 28,
                    );
                  }),
                ),
              ],
            ),
          ),          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _cols,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                    ),
                    itemCount: _rows * _cols,
                    itemBuilder: (context, index) {
                      int r = index ~/ _cols;
                      int c = index % _cols;
                      Cell cell = _engine.board[r][c];

                      return GestureDetector(
                        onTap: () {
                          if (_gameOver || _hasWon) return;
                          if (!_timerStarted) {
                            _startTimer();
                          }
                          setState(() {
                            int r = index ~/ _cols;
                            int c = index % _cols;
                            Cell cell = _engine.board[r][c];

                            if (!cell.isRevealed && !cell.isFlagged) {
                              _engine.revealCell(r, c);

                              if (cell.isMine) {
                                _lives--; 
                                if (_lives <= 0) {
                                  _gameOver = true;
                                  _stopTimer();
                                  _revealAll(); 
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('💥 ¡Pisaste una mina! Te quedan $_lives vidas.'),
                                      backgroundColor: Colors.orange,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                              _checkGameStatus();
                            }
                          });
                        },
                        onLongPress: () {
                          if (_gameOver || _hasWon || cell.isRevealed) return;
                          setState(() {
                            cell.isFlagged = !cell.isFlagged;
                            if (cell.isFlagged) {
                              _flagCount++;
                            } else {
                              _flagCount--;
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: cell.isRevealed 
                                ? (cell.isMine ? Colors.red.shade300 : _ThemeColors.revealed) 
                                : _ThemeColors.hidden,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: _buildCellContent(cell),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          if (_gameOver || _hasWon) _buildEndBanner(),
        ],
      ),
    );
  }

  Widget _buildCellContent(Cell cell) {
    if (!cell.isRevealed) {
      return cell.isFlagged ? const Icon(Icons.flag, color: Colors.red) : const SizedBox();
    }
    if (cell.isMine) return const Icon(Icons.brightness_7, color: Colors.black);
    if (cell.adjacentMines > 0) {
      return Text(
        '${cell.adjacentMines}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _getNumberColor(cell.adjacentMines)),
      );
    }
    return const SizedBox();
  }

  Widget _buildEndBanner() {
    return Container(
      color: _hasWon ? Colors.green : Colors.red.shade800,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            _hasWon ? '¡GANASTE EL JUEGO! 🏆' : '💥 ¡GAME OVER! 💥',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => setState(() => _initEngine()),
            child: const Text('Volver a Intentar', style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }
}