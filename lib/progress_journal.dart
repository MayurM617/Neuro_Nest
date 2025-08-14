import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressJournal extends StatefulWidget {
  const ProgressJournal({super.key});

  @override
  State<ProgressJournal> createState() => _ProgressJournalState();
}

class _ProgressJournalState extends State<ProgressJournal> {
  List<String> students = [];
  String? selectedStudent;
  DateTime selectedDate = DateTime.now();

  final List<String> checklistItems = [
    'Communication Board Used',
    'Games Completed',
    'Expressed Emotions',
    'Participated Well',
    'Needed Help Frequently',
  ];

  List<bool> checklistStatus = [false, false, false, false, false];
  TextEditingController notesController = TextEditingController();

  Map<String, dynamic> journalData = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    students = prefs.getStringList('students') ?? [];
    String? data = prefs.getString('journal');
    journalData = jsonDecode(data!);
    setState(() {});
  }

  Future<void> saveStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('students', students);
  }

  Future<void> saveJournal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('journal', jsonEncode(journalData));
  }

  String getDateKey() {
    return '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
  }

  void loadEntry() {
    if (selectedStudent == null) return;
    String student = selectedStudent!;
    String date = getDateKey();

    if (journalData[student] != null && journalData[student][date] != null) {
      Map entry = journalData[student][date];
      checklistStatus = List<bool>.from(entry['checklist']);
      notesController.text = entry['notes'];
    } else {
      checklistStatus = List.filled(checklistItems.length, false);
      notesController.clear();
    }
    setState(() {});
  }

  Future<void> saveEntry() async {
    if (selectedStudent == null) return;
    String student = selectedStudent!;
    String date = getDateKey();

    journalData[student] ??= {};
    journalData[student][date] = {
      'checklist': checklistStatus,
      'notes': notesController.text,
    };

    await saveJournal();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress Saved ✅')),
    );
  }

  void showSummary() {
    if (selectedStudent == null) return;
    String summary = '';
    for (int i = 0; i < checklistItems.length; i++) {
      summary += '${checklistStatus[i] ? "✔️" : "❌"} ${checklistItems[i]}\n';
    }
    summary +=
        '\n📝 Notes:\n${notesController.text.isEmpty ? 'No notes' : notesController.text}';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Progress Summary'),
        content: Text(
            '👤 Student: $selectedStudent\n📅 Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}\n\n$summary'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'))
        ],
      ),
    );
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    setState(() {
      selectedDate = picked!;
    });
    loadEntry();
  }

  void addStudent() {
    String name = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Student'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Enter student name'),
          onChanged: (val) => name = val,
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (name.trim().isNotEmpty) {
                  setState(() {
                    students.add(name.trim());
                  });
                  saveStudents();
                }
                Navigator.pop(context);
              },
              child: const Text('Add')),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFAF7),
      appBar: AppBar(
        title: const Text('Progress Journal'),
        backgroundColor: Colors.teal,
        actions: [
          if (selectedStudent != null)
            IconButton(
              onPressed: showSummary,
              icon: const Icon(Icons.info_outline),
              tooltip: 'View Summary',
            ),
          if (selectedStudent != null)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bar_chart),
              tooltip: 'View Charts',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Card for student and date
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('👩‍🏫 Student:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        DropdownButton<String>(
                          value: selectedStudent,
                          hint: const Text('Select'),
                          items: students
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedStudent = val;
                            });
                            loadEntry();
                          },
                        ),
                        IconButton(
                            onPressed: addStudent,
                            icon: const Icon(Icons.person_add)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Date Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('📅 Date:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        TextButton.icon(
                          onPressed: pickDate,
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (selectedStudent != null) ...[
                // Checklist Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✔️ Checklist:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...List.generate(checklistItems.length, (index) {
                        return CheckboxListTile(
                          title: Text(checklistItems[index]),
                          value: checklistStatus[index],
                          onChanged: (val) {
                            setState(() {
                              checklistStatus[index] = val!;
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      const Text('📝 Notes:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: notesController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Add your notes here...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          fillColor: Colors.grey[50],
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: saveEntry,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Progress'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                const Text(
                  'Please select or add a student to continue.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Teacher Dashboard'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
