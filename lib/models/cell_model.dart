class Cell {
  final int row;
  final int col;
  bool isMine;
  bool isRevealed;
  bool isFlagged;
  int adjacentMines;

  Cell(this.row, this.col, {
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.adjacentMines = 0,
  });
}