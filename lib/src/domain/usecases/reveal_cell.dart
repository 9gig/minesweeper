import '../repositories/game_repository.dart';

class RevealCell {
  final GameRepository repository;

  RevealCell(this.repository);

  void call(int row, int col) {
    repository.revealCell(row, col);
  }
}
