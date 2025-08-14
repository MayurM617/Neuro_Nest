import 'package:flutter/material.dart';

import 'communication_board.dart';
import 'emotion_game_dashboard.dart';
import 'progress_journal.dart';
import 'routine_builder_dashboard.dart';

class TeacherModeDashboard extends StatelessWidget {
  const TeacherModeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        title: const Text('Teacher Mode'),
        backgroundColor: Colors.green,
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
                    '👩‍🏫 Teacher Mode',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tools to help teach autistic children\nthrough games and interactive aids.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // First Row of Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dashboardButton(
                        context,
                        icon: Icons.emoji_emotions,
                        label: 'Emotion Game',
                        color: Colors.orangeAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EmotionGameDashboard()),
                          );
                        },

                      ),
                      dashboardButton(
                        context,
                        icon: Icons.schedule,
                        label: 'Routine Builder',
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RoutineBuilderDashboard()),
                         );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Second Row of Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dashboardButton(
                        context,
                        icon: Icons.record_voice_over,
                        label: 'Communication Board',
                        color: Colors.purple,
                        onTap: () {
                          // Inside your Teacher Dashboard button
                          Navigator.push(
                            context,
                             MaterialPageRoute(builder: (_) => const CommunicationBoard()),
                          );
                        },
                      ),
                      dashboardButton(
                        context,
                        icon: Icons.assignment,
                        label: 'Progress Journal',
                        color: Colors.teal,
                        onTap: () {
                          // Navigate to Progress Journal
                          Navigator.push(
                            context,
                             MaterialPageRoute(builder: (_) => const ProgressJournal()),
);

                        },
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  // Back Button
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboardButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 130,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
