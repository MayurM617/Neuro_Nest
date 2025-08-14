import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MemoryMazeGame extends StatefulWidget {
  const MemoryMazeGame({super.key});

  @override
  State<MemoryMazeGame> createState() => _MemoryMazeGameState();
}

class _MemoryMazeGameState extends State<MemoryMazeGame> {
  int score = 0;
  int level = 1;
  int round = 1;
  final int roundsPerLevel = 4;
  bool showPattern = true;

  List<int> correctTiles = [];
  List<int> userSelected = [];

  int get gridSize {
    if (level == 1) return 2;
    if (level == 2) return 3;
    return 4;
  }

  int get totalTiles => gridSize * gridSize;

  @override
  void initState() {
    super.initState();
    generatePattern();
  }

  void generatePattern() {
    final random = Random();
    correctTiles.clear();
    userSelected.clear();

    int numberOfTiles = min(2 + round, gridSize);

    while (correctTiles.length < numberOfTiles) {
      int tile = random.nextInt(totalTiles);
      if (!correctTiles.contains(tile)) {
        correctTiles.add(tile);
      }
    }

    showPattern = true;
    setState(() {});
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showPattern = false;
      });
    });
  }

  void handleTileTap(int index) {
    if (showPattern) return;

    setState(() {
      if (correctTiles.contains(index)) {
        if (!userSelected.contains(index)) {
          userSelected.add(index);
        }

        if (userSelected.length == correctTiles.length) {
          score += 10;

          if (round == roundsPerLevel) {
            if (level == 3) {
              showGameOverDialog();
            } else {
              level++;
              round = 1;
              generatePattern();
            }
          } else {
            round++;
            generatePattern();
          }
        }
      } else {
        score -= 5;
      }
    });
  }

  void resetGame() {
    setState(() {
      score = 0;
      level = 1;
      round = 1;
      generatePattern();
    });
  }

  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Game Over!'),
        content: Text('Your final score is: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text('🔄 Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('⬅ Back'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Maze'),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🏆 Score: $score',
                      style: const TextStyle(fontSize: 18)),
                  Text('🌀 Level: $level | Round: $round/$roundsPerLevel',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),

              // Instructions
              Text(
                showPattern
                    ? '👀 Memorize the highlighted tiles'
                    : '🔍 Select the tiles from memory',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Game Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: totalTiles,
                  itemBuilder: (context, index) {
                    bool isCorrect = correctTiles.contains(index);
                    bool isSelected = userSelected.contains(index);

                    Color tileColor = Colors.grey.shade300;

                    if (showPattern && isCorrect) {
                      tileColor = Colors.teal;
                    } else if (!showPattern && isSelected) {
                      tileColor = Colors.green;
                    }

                    return GestureDetector(
                      onTap: () => handleTileTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: tileColor,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.teal.shade700, width: 2),
                        ),
                        child: const Center(child: Text('')),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: resetGame,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Restart'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}