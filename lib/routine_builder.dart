import 'package:flutter/material.dart';
import 'summary_screen.dart';  // Import the summary screen

class RoutineBuilder extends StatefulWidget {
  const RoutineBuilder({super.key});

  @override
  State<RoutineBuilder> createState() => _RoutineBuilderState();
}

class _RoutineBuilderState extends State<RoutineBuilder> {
  final List<Map<String, String>> tasks = [
    {'icon': '🪥', 'label': 'Brush Teeth'},
    {'icon': '🍳', 'label': 'Eat Breakfast'},
    {'icon': '🎒', 'label': 'Go to School'},
    {'icon': '📖', 'label': 'Study Time'},
    {'icon': '🧹', 'label': 'Clean Up'},
    {'icon': '🧘', 'label': 'Relax Time'},
    {'icon': '🍽️', 'label': 'Lunch Time'},
    {'icon': '🎨', 'label': 'Art or Craft'},
    {'icon': '🏃', 'label': 'Exercise'},
    {'icon': '📺', 'label': 'Watch TV'},
    {'icon': '🍎', 'label': 'Snack Time'},
    {'icon': '🚿', 'label': 'Take Shower'},
    {'icon': '📱', 'label': 'Free Time'},
    {'icon': '🌙', 'label': 'Bed Time'},
  ];

  List<Map<String, dynamic>> selectedRoutine = [];

  void addToRoutine(Map<String, String> task) {
    setState(() {
      selectedRoutine.add({
        'icon': task['icon'],
        'label': task['label'],
        'completed': false,
        'time': null,
      });
    });
  }

  void clearRoutine() {
    setState(() {
      selectedRoutine.clear();
    });
  }

  void resetProgress() {
    setState(() {
      for (var task in selectedRoutine) {
        task['completed'] = false;
      }
    });
  }

  Future<void> pickTime(int index) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedRoutine[index]['time'] = picked;
      });
    }
  }

  int get completedCount {
    return selectedRoutine.where((task) => task['completed'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text('Routine Builder'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                '🗓️ Build Your Daily Routine',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Select tasks, reorder them, set times, and track progress!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: tasks.map((task) {
                    return GestureDetector(
                      onTap: () => addToRoutine(task),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.deepPurple, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(task['icon']!, style: const TextStyle(fontSize: 32)),
                            const SizedBox(height: 6),
                            Text(
                              task['label']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.deepPurple, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 Your Routine - Completed: $completedCount/${selectedRoutine.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    selectedRoutine.isEmpty
                        ? const Text('No tasks selected yet.')
                        : SizedBox(
                            height: 250,
                            child: ReorderableListView(
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final item = selectedRoutine.removeAt(oldIndex);
                                  selectedRoutine.insert(newIndex, item);
                                });
                              },
                              children: [
                                for (int index = 0;
                                    index < selectedRoutine.length;
                                    index++)
                                  ListTile(
                                    key: ValueKey('$index'),
                                    leading: Text(
                                        '${index + 1}. ${selectedRoutine[index]['icon']}'),
                                    title: Text(selectedRoutine[index]['label']),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () => pickTime(index),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              selectedRoutine[index]['time'] !=
                                                      null
                                                  ? (selectedRoutine[index]['time']
                                                          as TimeOfDay)
                                                      .format(context)
                                                  : 'Set Time',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Checkbox(
                                          value:
                                              selectedRoutine[index]['completed'],
                                          onChanged: (value) {
                                            setState(() {
                                              selectedRoutine[index]['completed'] =
                                                  value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Clear Button (white)
                  OutlinedButton.icon(
                    onPressed: clearRoutine,
                    icon: const Icon(Icons.delete, color: Colors.deepPurple),
                    label: const Text('Clear',
                        style: TextStyle(color: Colors.deepPurple)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepPurple, width: 2),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  // Reset Progress (white)
                  OutlinedButton.icon(
                    onPressed: resetProgress,
                    icon: const Icon(Icons.restart_alt, color: Colors.deepPurple),
                    label: const Text('Reset Progress',
                        style: TextStyle(color: Colors.deepPurple)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepPurple, width: 2),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  // Summary Button (purple)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SummaryScreen(routine: selectedRoutine),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('Summary'),
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepPurple, width: 2),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
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





