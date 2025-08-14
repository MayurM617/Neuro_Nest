import 'dart:math';
import 'package:flutter/material.dart';

class EmotionGame extends StatefulWidget {
  const EmotionGame({super.key});

  @override
  State<EmotionGame> createState() => _EmotionGameState();
}

class _EmotionGameState extends State<EmotionGame> {
  final List<Map<String, String>> situations = [
    {'situation': '🎂 A surprise birthday party is thrown for you.', 'emotion': 'Surprised'},
    {'situation': '😢 Your best friend forgot your birthday.', 'emotion': 'Sad'},
    {'situation': '😡 Someone cuts the line when you waited patiently.', 'emotion': 'Angry'},
    {'situation': '😱 A dog suddenly starts barking loudly at you.', 'emotion': 'Scared'},
    {'situation': '🏆 You solve a difficult puzzle after trying hard.', 'emotion': 'Proud'},
    {'situation': '😳 You ask a question and everyone laughs.', 'emotion': 'Embarrassed'},
    {'situation': '😬 You enter a new place with unfamiliar people.', 'emotion': 'Nervous'},
    {'situation': '😢 You studied hard but failed a test.', 'emotion': 'Sad'},
    {'situation': '😡 You see someone taking your things without asking.', 'emotion': 'Angry'},
    {'situation': '😱 You suddenly hear a loud noise behind you.', 'emotion': 'Scared'},
    {'situation': '😊 A teacher appreciates your help.', 'emotion': 'Happy'},
    {'situation': '😢 A classmate spills water on your drawing.', 'emotion': 'Sad'},
    {'situation': '😊 Your friend brings your favorite snack.', 'emotion': 'Happy'},
    {'situation': '😕 You misunderstood instructions and got it wrong.', 'emotion': 'Confused'},
    {'situation': '😢 A friend suddenly stops talking to you.', 'emotion': 'Sad'},
    {'situation': '🏆 You shared your toy and your friend thanked you.', 'emotion': 'Proud'},
    {'situation': '😊 You won an award in front of classmates.', 'emotion': 'Happy'},
    {'situation': '😳 You forgot your homework and the teacher calls you out.', 'emotion': 'Embarrassed'},
    {'situation': '😬 You have to talk in front of the whole class.', 'emotion': 'Nervous'},
    {'situation': '😃 You tried something new and loved it.', 'emotion': 'Excited'},
    {'situation': '😢 Your team loses a game you wanted to win.', 'emotion': 'Sad'},
    {'situation': '🏆 Someone compliments your artwork.', 'emotion': 'Proud'},
    {'situation': '😮 A magician does an incredible magic trick.', 'emotion': 'Surprised'},
    {'situation': '😡 Someone pushed you while playing.', 'emotion': 'Angry'},
    {'situation': '😃 You are going on a surprise trip.', 'emotion': 'Excited'},
  ];

  final List<String> level1Emotions = [
    'Happy',
    'Sad',
    'Angry',
    'Scared',
  ];

  final List<String> allEmotions = [
    'Happy',
    'Sad',
    'Angry',
    'Scared',
    'Proud',
    'Excited',
    'Nervous',
    'Embarrassed',
    'Confused',
    'Surprised',
  ];

  late Map<String, String> currentSituation;
  late List<String> options;

  int score = 0;
  int round = 1;
  int level = 1;
  final int roundsPerLevel = 4;
  final int maxLevel = 3;

  bool madeMistake = false;

  @override
  void initState() {
    super.initState();
    generateSituation();
  }

  void generateSituation() {
    final random = Random();
    currentSituation = situations[random.nextInt(situations.length)];

    final Set<String> tempOptions = {currentSituation['emotion']!};

    List<String> emotionSource =
        (level == 1) ? level1Emotions : allEmotions;

    while (tempOptions.length < 4) {
      tempOptions.add(emotionSource[random.nextInt(emotionSource.length)]);
    }
    options = tempOptions.toList();
    options.shuffle();
  }

  void checkAnswer(String selected) {
    setState(() {
      if (selected == currentSituation['emotion']) {
        score += 10;
        showFeedback('Correct!', Colors.green);
      } else {
        madeMistake = true;
        showFeedback('Wrong! Try again...', Colors.red);
      }

      if (round >= roundsPerLevel) {
        if (madeMistake) {
          showRetryLevelDialog();
        } else {
          if (level >= maxLevel) {
            showCongratsPage();
          } else {
            showLevelCompleteDialog();
          }
        }
      } else {
        round++;
        generateSituation();
      }
    });
  }

  void resetGame() {
    setState(() {
      score = 0;
      round = 1;
      level = 1;
      madeMistake = false;
      generateSituation();
    });
  }

  void restartLevel() {
    setState(() {
      score = 0; // ✅ Reset score when restarting the level
      round = 1;
      madeMistake = false;
      generateSituation();
    });
  }

  void nextLevel() {
    setState(() {
      round = 1;
      level++;
      madeMistake = false;
      generateSituation();
    });
  }

  void showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void showLevelCompleteDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Text('Great job! Get ready for Level ${level + 1}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              nextLevel();
            },
            child: const Text('Next Level ▶️'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('⬅️ Exit'),
          ),
        ],
      ),
    );
  }

  void showRetryLevelDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('❌ Level Failed'),
        content: const Text('Oops! You made a mistake. Retry this level.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              restartLevel();
            },
            child: const Text('🔄 Retry Level'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('⬅️ Exit'),
          ),
        ],
      ),
    );
  }

  void showCongratsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const CongratsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Game'),
        backgroundColor: Colors.purple,
      ),
      backgroundColor: const Color(0xFFF3E5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🏆 Score: $score',
                      style: const TextStyle(fontSize: 16)),
                  Text('🌀 Round: $round/$roundsPerLevel',
                      style: const TextStyle(fontSize: 16)),
                  Text('⭐ Level: $level/$maxLevel',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'Which emotion matches this situation?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Situation Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.purple, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  currentSituation['situation']!,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Emotion Buttons
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: options.map((option) {
                  return ElevatedButton(
                    onPressed: () => checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      minimumSize: const Size(130, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              // Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: restartLevel,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Retry Level'),
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

class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉 Congratulations!',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),
              const Text(
                'You have completed all the levels of the\nEmotion Game!',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

