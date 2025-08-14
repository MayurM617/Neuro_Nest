import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunicationBoard extends StatefulWidget {
  const CommunicationBoard({super.key});

  @override
  State<CommunicationBoard> createState() => _CommunicationBoardState();
}

class _CommunicationBoardState extends State<CommunicationBoard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FlutterTts flutterTts = FlutterTts();

  List<Map<String, String>> favorites = [];
  bool largeButtons = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length + 1, vsync: this);
    loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future _speak(String text) async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void onItemTap(String label) {
    _speak(label);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Selected'),
        content: Text(label),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  // ---------- Favorites Storage ----------
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favData = prefs.getString('favorites');
    List favList = jsonDecode(favData!);
    setState(() {
      favorites = List<Map<String, String>>.from(
          favList.map((e) => Map<String, String>.from(e)));
    });
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', jsonEncode(favorites));
  }

  Future<void> clearFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
    setState(() {
      favorites.clear();
    });
  }

  void addToFavorites(String emoji, String label) {
    setState(() {
      favorites.add({'emoji': emoji, 'label': label});
    });
    saveFavorites();
  }

  void removeFromFavorites(int index) {
    setState(() {
      favorites.removeAt(index);
    });
    saveFavorites();
  }

  // ---------- Categories ----------
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Food',
      'items': [
        {'emoji': '🍎', 'label': 'Apple'},
        {'emoji': '🍕', 'label': 'Pizza'},
        {'emoji': '🍩', 'label': 'Snack'},
        {'emoji': '🥤', 'label': 'Drink'},
        {'emoji': '🍚', 'label': 'Eat Rice'},
      ]
    },
    {
      'name': 'Feelings',
      'items': [
        {'emoji': '😄', 'label': 'Happy'},
        {'emoji': '😢', 'label': 'Sad'},
        {'emoji': '😡', 'label': 'Angry'},
        {'emoji': '😨', 'label': 'Scared'},
        {'emoji': '😴', 'label': 'Tired'},
      ]
    },
    {
      'name': 'Actions',
      'items': [
        {'emoji': '🏃', 'label': 'Run'},
        {'emoji': '🧹', 'label': 'Clean'},
        {'emoji': '🎨', 'label': 'Draw'},
        {'emoji': '🧸', 'label': 'Play'},
        {'emoji': '🛏️', 'label': 'Rest'},
      ]
    },
    {
      'name': 'Needs',
      'items': [
        {'emoji': '🛑', 'label': 'Stop'},
        {'emoji': '✋', 'label': 'Wait'},
        {'emoji': '🙋', 'label': 'Help'},
        {'emoji': '🚽', 'label': 'Bathroom'},
        {'emoji': '➕', 'label': 'More'},
      ]
    },
    {
      'name': 'Places',
      'items': [
        {'emoji': '🏠', 'label': 'Home'},
        {'emoji': '🏫', 'label': 'School'},
        {'emoji': '🏞️', 'label': 'Playground'},
        {'emoji': '🏥', 'label': 'Hospital'},
        {'emoji': '🛒', 'label': 'Shop'},
      ]
    },
  ];

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    double buttonSize = largeButtons ? 110 : 90;
    double fontSize = largeButtons ? 18 : 14;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text('Communication Board'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () => openAddPhraseDialog(),
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () => openSettingsDialog(),
              icon: const Icon(Icons.settings)),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: '⭐ Favorites'),
            ...categories.map((cat) => Tab(text: cat['name']))
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Favorites Tab
            buildGrid(favorites, buttonSize, fontSize, isFavorite: true),
            // Other Categories
            ...categories.map((cat) => buildGrid(
                List<Map<String, String>>.from(cat['items']),
                buttonSize,
                fontSize)),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Teacher Dashboard'),
        ),
      ),
    );
  }

  Widget buildGrid(
      List<Map<String, String>> items, double size, double fontSize,
      {bool isFavorite = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (_, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onItemTap(item['label']!),
            onLongPress: isFavorite
                ? () => removeFromFavorites(index)
                : () => addToFavorites(item['emoji']!, item['label']!),
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['emoji']!,
                      style: TextStyle(fontSize: size / 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: fontSize, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openAddPhraseDialog() {
    String emoji = '';
    String label = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add to Favorites'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Emoji'),
              onChanged: (value) => emoji = value,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Label'),
              onChanged: (value) => label = value,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (emoji.isNotEmpty && label.isNotEmpty) {
                  addToFavorites(emoji, label);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add')),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
        ],
      ),
    );
  }

  void openSettingsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Large Buttons'),
                Switch(
                    value: largeButtons,
                    onChanged: (val) {
                      setState(() {
                        largeButtons = val;
                      });
                    })
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  clearFavorites();
                  Navigator.pop(context);
                },
                child: const Text('Clear Favorites'))
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'))
        ],
      ),
    );
  }
}
