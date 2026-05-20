import 'dart:math';
import 'package:micro_proyecto_alonso_saracual/models/cell_model.dart';

class GameEngine {
  late List<List<Cell>> board;
  int rows;
  int cols;
  int totalMines;
  bool isFirstClick = true;

  GameEngine(this.rows, this.cols, this.totalMines) {
    _initializeBoard();
  }

  void _initializeBoard() {
    board = List.generate(rows, (r) => List.generate(cols, (c) => Cell(r, c)));
  }

  void placeMines(int firstRow, int firstCol) {
    int minesPlaced = 0;
    var random = Random();

    while (minesPlaced < totalMines) {
      int r = random.nextInt(rows);
      int c = random.nextInt(cols);

      // Evitar colocar mina en el primer clic y no repetir minas
      if (!board[r][c].isMine && !(r == firstRow && c == firstCol)) {
        board[r][c].isMine = true;
        minesPlaced++;
      }
    }
    _calculateAdjacents();
  }

  void _calculateAdjacents() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c].isMine) continue;
        int count = 0;
        // Revisar las 8 direcciones adyacentes
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            if (r + i >= 0 && r + i < rows && c + j >= 0 && c + j < cols) {
              if (board[r + i][c + j].isMine) count++;
            }
          }
        }
        board[r][c].adjacentMines = count;
      }
    }
  }

  // Algoritmo Flood Fill
  void revealCell(int r, int c) {
    if (r < 0 || r >= rows || c < 0 || c >= cols) return;
    if (board[r][c].isRevealed || board[r][c].isFlagged) return;

    if (isFirstClick) {
      placeMines(r, c); // Asegura que el primer clic nunca sea mina
      isFirstClick = false;
    }

    board[r][c].isRevealed = true;

    // Si es 0, revelamos recursivamente los vecinos
    if (board[r][c].adjacentMines == 0 && !board[r][c].isMine) {
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          revealCell(r + i, c + j);
        }
      }
    }
  }
}