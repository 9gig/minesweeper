import '../repositories/game_repository.dart';

class InitializeGame {
  final GameRepository repository;

  InitializeGame(this.repository);

  void call() {
    repository.initializeGame();
  }
}
