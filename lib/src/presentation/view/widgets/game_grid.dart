import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miney/src/presentation/provider/game_provider.dart';

class GameGrid extends ConsumerWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: 100,
      itemBuilder: (context, index) {
        int row = index ~/ 10;
        int col = index % 10;
        return GestureDetector(
          onTap: () => ref.read(gameProvider.notifier).onCellTap(row, col),
          onLongPress:
              () => ref.read(gameProvider.notifier).onCellLongPress(row, col),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color:
                  state.grid[row][col].isRevealed
                      ? Colors.grey[800]
                      : Colors.grey[600],
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child:
                  state.grid[row][col].isRevealed
                      ? (state.grid[row][col].isMine
                          ? const Icon(Icons.bug_report, color: Colors.red)
                          : state.grid[row][col].number > 0
                          ? Text(
                            '${state.grid[row][col].number}',
                            style: TextStyle(
                              color: getNumberColor(
                                state.grid[row][col].number,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : null)
                      : (state.grid[row][col].isFlagged
                          ? const Icon(Icons.flag, color: Colors.red)
                          : null),
            ),
          ),
        );
      },
    );
  }

  Color getNumberColor(int number) {
    switch (number) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}
