import '../repositories/game_repository.dart';

class ToggleFlag {
  final GameRepository repository;

  ToggleFlag(this.repository);

  void call(int row, int col) {
    repository.toggleFlag(row, col);
  }
}
