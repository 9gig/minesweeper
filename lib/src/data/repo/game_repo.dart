import 'dart:async';
import 'dart:math';
import '../models/cell.dart';
import '../sources/game_source.dart';
import '../../domain/entities/cell_entity.dart';
import '../../domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  final GameSource _source = GameSource();
  Timer? _timer;

  @override
  List<List<CellEntity>> getGrid() {
    return _source.grid
        .map(
          (row) =>
              row
                  .map(
                    (cell) => CellEntity(
                      isMine: cell.isMine,
                      isRevealed: cell.isRevealed,
                      isFlagged: cell.isFlagged,
                      number: cell.number,
                    ),
                  )
                  .toList(),
        )
        .toList();
  }

  @override
  void initializeGame() {
    _source.grid = List.generate(
      GameSource.rows,
      (_) => List.generate(GameSource.cols, (_) => Cell(), growable: false),
      growable: false,
    );
    _source.placeMines();
    _calculateNumbers();
    _source.gameOver = false;
    _source.timeElapsed = 0;
    _source.flagsRemaining = GameSource.totalMines;
    _source.hintsRemaining = 3;
    _source.timerRunning = false;
    stopTimer(); // Changed from _stopTimer() to stopTimer()
  }

  void _calculateNumbers() {
    for (int i = 0; i < GameSource.rows; i++) {
      for (int j = 0; j < GameSource.cols; j++) {
        if (!_source.grid[i][j].isMine) {
          _source.grid[i][j].number = _source.countAdjacentMines(i, j);
        }
      }
    }
  }

  @override
  void revealCell(int row, int col) {
    if (_source.grid[row][col].isRevealed ||
        _source.grid[row][col].isFlagged ||
        _source.gameOver)
      return;

    _source.grid[row][col].isRevealed = true;
    if (_source.grid[row][col].isMine) {
      _source.gameOver = true;
    } else if (_source.grid[row][col].number == 0) {
      _revealAdjacentCells(row, col);
    }
    _checkWin();
    if (!_source.timerRunning) {
      startTimer();
      _source.timerRunning = true;
    }
  }

  void _revealAdjacentCells(int row, int col) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = row + i;
        int newCol = col + j;
        if (newRow >= 0 &&
            newRow < GameSource.rows &&
            newCol >= 0 &&
            newCol < GameSource.cols) {
          if (!_source.grid[newRow][newCol].isRevealed &&
              !_source.grid[newRow][newCol].isMine) {
            revealCell(newRow, newCol);
          }
        }
      }
    }
  }

  @override
  void toggleFlag(int row, int col) {
    if (_source.grid[row][col].isRevealed || _source.gameOver) return;

    if (_source.grid[row][col].isFlagged) {
      _source.grid[row][col].isFlagged = false;
      _source.flagsRemaining++;
    } else if (_source.flagsRemaining > 0) {
      _source.grid[row][col].isFlagged = true;
      _source.flagsRemaining--;
    }
    if (!_source.timerRunning) {
      startTimer();
      _source.timerRunning = true;
    }
  }

  void _checkWin() {
    bool won = true;
    for (int i = 0; i < GameSource.rows; i++) {
      for (int j = 0; j < GameSource.cols; j++) {
        if (!_source.grid[i][j].isMine && !_source.grid[i][j].isRevealed) {
          won = false;
          break;
        }
      }
    }
    if (won) _source.gameOver = true;
  }

  @override
  void useHint() {
    if (_source.hintsRemaining > 0 && !_source.gameOver) {
      _source.hintsRemaining--;
      int safeRow, safeCol;
      final random = Random();
      do {
        safeRow = random.nextInt(GameSource.rows);
        safeCol = random.nextInt(GameSource.cols);
      } while (_source.grid[safeRow][safeCol].isMine ||
          _source.grid[safeRow][safeCol].isRevealed);
      revealCell(safeRow, safeCol);
      if (!_source.timerRunning) {
        startTimer();
        _source.timerRunning = true;
      }
    }
  }

  @override
  bool getGameOver() {
    return _source.gameOver;
  }

  @override
  int getTimeElapsed() {
    return _source.timeElapsed;
  }

  @override
  int getFlagsRemaining() {
    return _source.flagsRemaining;
  }

  @override
  int getHintsRemaining() {
    return _source.hintsRemaining;
  }

  @override
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_source.gameOver) {
        _source.timeElapsed++;
      } else {
        stopTimer(); // Changed from _stopTimer() to stopTimer()
      }
    });
  }

  @override
  void stopTimer() {
    _timer?.cancel();
    _source.timerRunning = false;
  }

  @override
  void resetTimer() {
    _source.timeElapsed = 0;
    stopTimer(); // Changed from _stopTimer() to stopTimer()
  }
}
