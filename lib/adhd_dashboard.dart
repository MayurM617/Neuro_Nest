import 'package:flutter/material.dart';
import 'memory_maze_game.dart'; // Make sure to create this file separately

class ADHDDashboard extends StatelessWidget {
  const ADHDDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F7FF),
      appBar: AppBar(
        title: const Text('Memory Maze - How to Play'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 420,
              maxHeight: 800,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    '🧠 Memory Maze',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Instructions Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '👉 How to Play:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1️⃣ A few tiles will be highlighted.\n\n'
                          '2️⃣ Memorize their positions within 3 seconds.\n\n'
                          '3️⃣ Once they disappear, tap on the same tiles from memory.\n\n'
                          '4️⃣ Each correct tile earns +10 points.\n'
                          '❌ Wrong taps deduct -5 points.\n\n'
                          '5️⃣ Difficulty increases each round with more tiles to remember.\n\n'
                          'Have Fun & Train Your Focus!',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Start Game Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MemoryMazeGame()),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Memory Maze'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  // Back Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to ADHD Mode'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
