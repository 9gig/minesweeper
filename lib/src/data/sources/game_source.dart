import 'dart:math';
import '../models/cell.dart';

class GameSource {
  static const int rows = 10;
  static const int cols = 10;
  static const int totalMines = 12;

  List<List<Cell>> grid = List.generate(
    rows,
    (_) => List.generate(cols, (_) => Cell(), growable: false),
    growable: false,
  );
  bool gameOver = false;
  int timeElapsed = 0;
  int flagsRemaining = totalMines;
  int hintsRemaining = 3;
  bool timerRunning = false;

  void placeMines() {
    int minesPlaced = 0;
    final random = Random();
    while (minesPlaced < totalMines) {
      int x = random.nextInt(rows);
      int y = random.nextInt(cols);
      if (!grid[x][y].isMine) {
        grid[x][y].isMine = true;
        minesPlaced++;
      }
    }
  }

  int countAdjacentMines(int row, int col) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = row + i;
        int newCol = col + j;
        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
          if (grid[newRow][newCol].isMine) count++;
        }
      }
    }
    return count;
  }
}
