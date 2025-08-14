import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_screen.dart'; // ✅ Added import for chatbot
import 'cognitive_mode_selection.dart';
import 'login_page.dart';
import 'teacher_mode_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAOvPD-RHAct_o4AG8Pxe6J-o33MIT7LI4",
        authDomain: "neuronest-adfd9.firebaseapp.com",
        projectId: "neuronest-adfd9",
        storageBucket: "neuronest-adfd9.appspot.com",
        messagingSenderId: "625505198755",
        appId: "1:625505198755:web:e1a0b54f6dfbb606789516",
        measurementId: "G-XB88DGHMH4",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const NeuroNestApp());
}

class NeuroNestApp extends StatelessWidget {
  const NeuroNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const HomeScreen(), // or TeacherModeDashboard()
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 420,
              maxHeight: 800,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  const Text(
                    '🧠 NeuroNest',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cognitive Rehab & Autism Learning Support',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  InteractiveCard(
                    title: '🧠 Cognitive Rehab Mode',
                    subtitle: 'Memory • Focus • Flexibility (ADHD & MCI)',
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CognitiveModeSelectionScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  InteractiveCard(
                    title: '👩‍🏫 Teacher Mode (Autism)',
                    subtitle: 'Tools for Teaching Autistic Children',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TeacherModeDashboard(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  // ✅ New Chatbot Card
                  InteractiveCard(
                    title: '💬 NeuroNest Chatbot',
                    subtitle: 'AI Assistant for Learning & Support',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChatScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomIcon(
                        icon: Icons.bar_chart,
                        label: 'Progress',
                        onTap: () {},
                      ),
                      BottomIcon(
                        icon: Icons.settings,
                        label: 'Settings',
                        onTap: () {},
                      ),
                      BottomIcon(
                        icon: Icons.info,
                        label: 'About',
                        onTap: () {},
                      ),
                    ],
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

class InteractiveCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const InteractiveCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BottomIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blueGrey),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
