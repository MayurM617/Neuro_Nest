import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dual_task_summary.dart';

class DualTaskGame extends StatefulWidget {
  const DualTaskGame({super.key});

  @override
  State<DualTaskGame> createState() => _DualTaskGameState();
}

class _DualTaskGameState extends State<DualTaskGame> {
  final List<List<String>> categories = [
    ['🍎', '🍌', '🍇', '🍉', '🍊', '🍓', '🥭', '🍍'],
    ['🐶', '🐱', '🐭', '🐰', '🐻', '🐯', '🦁', '🐨'],
    ['🚗', '🚕', '🚙', '🚌', '🚑', '🚒', '🚜', '🚚'],
    ['🪑', '🛏️', '🚪', '🖼️', '🛋️', '🧹', '🚽', '🪞'],
    ['⚽', '🏀', '🏈', '🎾', '🥏', '🏐', '🥎', '🏓'],
  ];

  late List<String> gridItems;
  late List<int> mathOptions;
  String oddItem = '';

  int num1 = 0;
  int num2 = 0;
  String operator = '';
  int correctMathAnswer = 0;
  int? selectedMathAnswer;

  int level = 1;
  final int maxLevel = 5;
  int score = 0;

  int timeLeft = 25;
  Timer? gameTimer;

  bool mathAnswered = false;
  bool visualAnswered = false;

  int totalMathCorrect = 0;
  int totalVisualCorrect = 0;

  @override
  void initState() {
    super.initState();
    startNewRound();
  }

  void startNewRound() {
    generateGrid();
    generateMath();
    generateMathOptions();
    mathAnswered = false;
    visualAnswered = false;
    startTimer();
  }

  void generateGrid() {
    final random = Random();
    int mainCategory = random.nextInt(categories.length);
    int oddCategory;
    do {
      oddCategory = random.nextInt(categories.length);
    } while (oddCategory == mainCategory);

    List<String> mainItems = List.from(categories[mainCategory]);
    List<String> grid = List.generate(
        8, (index) => mainItems[random.nextInt(mainItems.length)]);
    String odd = categories[oddCategory]
        [random.nextInt(categories[oddCategory].length)];

    grid.add(odd);
    grid.shuffle();

    setState(() {
      gridItems = grid;
      oddItem = odd;
    });
  }

  void generateMath() {
    final random = Random();
    List<String> operators = ['+', '-', '×'];

    num1 = random.nextInt(50) + 10;
    num2 = random.nextInt(40) + 5;
    operator = operators[random.nextInt(operators.length)];

    if (operator == '+') {
      correctMathAnswer = num1 + num2;
    } else if (operator == '-') {
      correctMathAnswer = num1 - num2;
    } else {
      correctMathAnswer = num1 * num2;
    }

    selectedMathAnswer = null;
  }

  void generateMathOptions() {
    Set<int> options = {correctMathAnswer};
    final random = Random();

    while (options.length < 4) {
      int offset = random.nextInt(15) - 7;
      int wrongAnswer = correctMathAnswer + offset;
      if (wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }

    mathOptions = options.toList()..shuffle();
  }

  void startTimer() {
    gameTimer?.cancel();
    setState(() {
      timeLeft = max(10, 25 - level * 2);
    });

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          showSummary();
        }
      });
    });
  }

  void selectMathAnswer(int answer) {
    if (mathAnswered) return;
    setState(() {
      selectedMathAnswer = answer;
      mathAnswered = answer == correctMathAnswer;
      if (mathAnswered) {
        score += 15;
        totalMathCorrect++;
      } else {
        score -= 5;
        showSummary();
      }
      checkCompletion();
    });
  }

  void selectOddItem(String item) {
    if (visualAnswered) return;
    setState(() {
      visualAnswered = item == oddItem;
      if (visualAnswered) {
        score += 15;
        totalVisualCorrect++;
      } else {
        score -= 5;
        showSummary();
      }
      checkCompletion();
    });
  }

  void checkCompletion() {
    if (mathAnswered && visualAnswered) {
      gameTimer?.cancel();
      if (level == maxLevel) {
        showSummary();
      } else {
        nextLevel();
      }
    }
  }

  void nextLevel() {
    setState(() {
      level++;
      startNewRound();
    });
  }

  void showSummary() {
    gameTimer?.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DualTaskSummary(
          totalScore: score,
          totalMathCorrect: totalMathCorrect,
          totalVisualCorrect: totalVisualCorrect,
          currentLevel: level,
          onRestart: () {
            Navigator.pop(context);
            resetGame();
          },
          onExit: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void resetGame() {
    setState(() {
      level = 1;
      score = 0;
      totalMathCorrect = 0;
      totalVisualCorrect = 0;
      startNewRound();
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text('Dual Task Game'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: showSummary,
            icon: const Icon(Icons.info_outline),
            tooltip: 'Summary',
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Level: $level/$maxLevel',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Score: $score',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('⏰ $timeLeft sec',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      '🧠 Solve: $num1 $operator $num2 = ?',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: mathOptions.map((option) {
                        return ElevatedButton(
                          onPressed: selectedMathAnswer == null
                              ? () => selectMathAnswer(option)
                              : null,
                          child: Text('$option'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '🎯 Find the odd item!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: gridItems.map((item) {
                    return GestureDetector(
                      onTap: () => selectOddItem(item),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



