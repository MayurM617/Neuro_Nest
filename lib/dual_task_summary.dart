import 'package:flutter/material.dart';

class DualTaskSummary extends StatelessWidget {
  final int totalScore;
  final int totalMathCorrect;
  final int totalVisualCorrect;
  final int currentLevel;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const DualTaskSummary({
    super.key,
    required this.totalScore,
    required this.totalMathCorrect,
    required this.totalVisualCorrect,
    required this.currentLevel,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      appBar: AppBar(
        title: const Text('Summary'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉 Your Progress',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const SizedBox(height: 10),
              const Text(
                'Check your progress or take a break anytime!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: Column(
                  children: [
                    Text('🎯 Total Score: $totalScore',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text('🧠 Correct Math: $totalMathCorrect',
                        style: const TextStyle(fontSize: 16)),
                    Text('🎨 Correct Visual: $totalVisualCorrect',
                        style: const TextStyle(fontSize: 16)),
                    Text('📊 Current Level: $currentLevel',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Restart Game'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: onExit,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Exit'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
