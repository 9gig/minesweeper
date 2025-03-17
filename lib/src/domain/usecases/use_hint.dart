import '../repositories/game_repository.dart';

class UseHint {
  final GameRepository repository;

  UseHint(this.repository);

  void call() {
    repository.useHint();
  }
}
