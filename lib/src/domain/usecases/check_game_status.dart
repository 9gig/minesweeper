import '../repositories/game_repository.dart';

class CheckGameStatus {
  final GameRepository repository;

  CheckGameStatus(this.repository);

  bool call() {
    // Placeholder for win/lose logic
    return repository.getGameOver();
  }
}
