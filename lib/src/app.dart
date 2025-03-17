import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miney/src/presentation/view/screens/minesweeper_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Minesweeper',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const MinesweeperScreen(),
      ),
    );
  }
}
