import 'package:flutter/material.dart';

import 'adhd_dashboard.dart';
import 'mci_dashboard.dart';

class CognitiveModeSelectionScreen extends StatelessWidget {
  const CognitiveModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        title: const Text('Cognitive Mode'),
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
                  const SizedBox(height: 20),

                  const Text(
                    '🧠 Cognitive Mode',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

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
                    child: const Text(
                      'Select a mode based on the user:\n\n'
                      '🔵 ADHD Mode: Fast-paced, engaging games to improve focus, attention, and inhibition.\n\n'
                      '🟢 MCI Mode: Calmer interface with slower-paced games to strengthen memory and cognitive flexibility.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // ADHD Mode Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ADHDDashboard()),
                      );
                    },
                    child: const Column(
                      children: [
                        Text('🔵 ADHD Mode',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Focus • Attention • Impulse Control',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // MCI Mode Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MCIDashboard()),
                      );
                    },
                    child: const Column(
                      children: [
                        Text('🟢 MCI Mode',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Memory • Cognitive Flexibility • Focus',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
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
}
