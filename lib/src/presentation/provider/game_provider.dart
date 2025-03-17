import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miney/src/data/repo/game_repo.dart';
import 'package:miney/src/data/sources/game_source.dart';
import 'package:miney/src/domain/entities/cell_entity.dart';
import 'package:miney/src/domain/usecases/check_game_status.dart';
import 'package:miney/src/domain/usecases/initialize_game.dart';
import 'package:miney/src/domain/usecases/reveal_cell.dart';
import 'package:miney/src/domain/usecases/toggle_flag.dart';
import 'package:miney/src/domain/usecases/use_hint.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  final repository = GameRepositoryImpl();
  return GameNotifier(
    repository,
    InitializeGame(repository),
    RevealCell(repository),
    ToggleFlag(repository),
    UseHint(repository),
    CheckGameStatus(repository),
  );
});

class GameState {
  final List<List<CellEntity>> grid;
  final bool gameOver;
  final int timeElapsed;
  final int flagsRemaining;
  final int hintsRemaining;

  GameState({
    required this.grid,
    required this.gameOver,
    required this.timeElapsed,
    required this.flagsRemaining,
    required this.hintsRemaining,
  });

  GameState copyWith({
    List<List<CellEntity>>? grid,
    bool? gameOver,
    int? timeElapsed,
    int? flagsRemaining,
    int? hintsRemaining,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      gameOver: gameOver ?? this.gameOver,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      flagsRemaining: flagsRemaining ?? this.flagsRemaining,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  final GameRepositoryImpl repository;
  final InitializeGame initializeGame;
  final RevealCell revealCell;
  final ToggleFlag toggleFlag;
  final UseHint useHint;
  final CheckGameStatus checkGameStatus;

  GameNotifier(
    this.repository,
    this.initializeGame,
    this.revealCell,
    this.toggleFlag,
    this.useHint,
    this.checkGameStatus,
  ) : super(
        GameState(
          grid: [],
          gameOver: false,
          timeElapsed: 0,
          flagsRemaining: GameSource.totalMines,
          hintsRemaining: 3,
        ),
      ) {
    initializeGame();
    _updateState();
    repository.startTimer();
  }

  void _updateState() {
    state = state.copyWith(
      grid: repository.getGrid(),
      gameOver: repository.getGameOver(),
      timeElapsed: repository.getTimeElapsed(),
      flagsRemaining: repository.getFlagsRemaining(),
      hintsRemaining: repository.getHintsRemaining(),
    );
  }

  void newGame() {
    initializeGame();
    repository.resetTimer();
    repository.startTimer();
    _updateState();
  }

  void onCellTap(int row, int col) {
    revealCell.call(row, col);
    _updateState();
  }

  void onCellLongPress(int row, int col) {
    toggleFlag.call(row, col);
    _updateState();
  }

  void onHint() {
    useHint.call();
    _updateState();
  }
}
