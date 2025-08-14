import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String apiKey =
      "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";
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  final List<String> modules = [
    "MCI Game",
    "ADHD Game",
    "Teachers Mode",
    "Routine Builder",
    "Communication Board",
    "Progress Journal",
    "Emotion Game",
    "Symptom Detector",
    "Feedback Collector",
  ];

  String cleanResponse(String text) {
    return text.replaceAll(RegExp(r'[*_/`]+'), '').trim();
  }

  Future<void> _sendMessage([String? userInput]) async {
    final messageToSend = userInput ?? _controller.text.trim();
    if (messageToSend.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": messageToSend});
      _controller.clear();
      _isLoading = true;
    });

    const systemPrompt = """
You are NeuroNest’s assistant. NeuroNest is a cognitive support app designed to assist users with ADHD, Mild Cognitive Impairment, and Autism Spectrum Disorder.

When the user sends a module name like "ADHD Game" or "Routine Builder", respond with a clear, friendly, detailed explanation of that module and how it helps users.

Do not assume anything else in the user input, and do not add extra instructions yourself. Keep responses empathetic and easy to understand.
""";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "meta-llama/llama-4-scout-17b-16e-instruct",
          "messages": [
            {"role": "system", "content": systemPrompt},
            ..._messages.map((m) => {
                  "role": m["role"]!,
                  "content": m["content"]!,
                }),
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply = cleanResponse(
            data['choices'][0]['message']['content'] ?? "No response");

        setState(() {
          _messages.add({"role": "assistant", "content": botReply});
        });
      } else {
        setState(() {
          _messages.add({
            "role": "assistant",
            "content": "Error: Unable to get response (${response.statusCode})"
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "content": "Error: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message["content"] ?? ""),
      ),
    );
  }

  Widget _buildFloatingModuleButtons() {
    return Positioned(
      bottom: 70,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: modules.map((module) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FloatingActionButton.extended(
                heroTag: module,
                backgroundColor: Colors.blue[400],
                label: Text(
                  module,
                  style: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  _sendMessage(module); // send only the module name text
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NeuroNest Chatbot")),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index]);
                  },
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingModuleButtons(),
        ],
      ),
    );
  }
}
