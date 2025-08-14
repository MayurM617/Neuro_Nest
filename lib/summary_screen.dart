import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> routine;

  const SummaryScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final int total = routine.length;
    final int completed = routine.where((t) => t['completed'] == true).length;
    final int pending = total - completed;

    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FF),
      appBar: AppBar(
        title: const Text('Routine Summary'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '📊 Summary',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Tasks: $total   ✅ Completed: $completed   ⏳ Pending: $pending',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: routine.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks in your routine!',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: routine.length,
                      itemBuilder: (context, index) {
                        final task = routine[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Text(
                              '${task['icon']}',
                              style: const TextStyle(fontSize: 28),
                            ),
                            title: Text(
                              '${task['label']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            subtitle: Text(
                              task['time'] != null
                                  ? '⏰ ${task['time'].format(context)}'
                                  : '⏰ No time set',
                            ),
                            trailing: Icon(
                              task['completed'] == true
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: task['completed'] == true
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Routine'),
            )
          ],
        ),
      ),
    );
  }
}
