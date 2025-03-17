import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miney/src/data/sources/game_source.dart';
import 'package:miney/src/presentation/provider/game_provider.dart';

import '../widgets/game_grid.dart';

class MinesweeperScreen extends ConsumerWidget {
  const MinesweeperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Classic Mode'),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.red),
                    Text('${GameSource.totalMines - state.flagsRemaining}'),
                    const SizedBox(width: 10),
                    const Icon(Icons.timer),
                    Text('${state.timeElapsed.toString().padLeft(2, '0')}:00'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: GameGrid()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => ref.read(gameProvider.notifier).newGame(),
                  child: const Text('New Game'),
                ),
                Column(
                  children: [
                    const Text('Flag Mode'),
                    IconButton(
                      icon: const Icon(Icons.flag),
                      onPressed: () {}, // Implement toggle logic
                      color: Colors.red,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Safe Mode'),
                    Text('${state.hintsRemaining} hints remaining'),
                    IconButton(
                      icon: const Icon(Icons.lightbulb),
                      onPressed: () => ref.read(gameProvider.notifier).onHint(),
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: const Icon(Icons.home), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.emoji_events),
                onPressed: () {},
              ),
              IconButton(icon: const Icon(Icons.person), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
