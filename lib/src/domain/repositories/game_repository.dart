import '../entities/cell_entity.dart';

abstract class GameRepository {
  List<List<CellEntity>> getGrid();
  void initializeGame();
  void revealCell(int row, int col);
  void toggleFlag(int row, int col);
  void useHint();
  bool getGameOver();
  int getTimeElapsed();
  int getFlagsRemaining();
  int getHintsRemaining();
  void startTimer();
  void stopTimer();
  void resetTimer();
}
