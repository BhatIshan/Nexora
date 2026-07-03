import 'package:flutter/material.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // A starting list of messages to show on screen
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hello! I am your Nexora Safety Assistant. How can I help you feel safer today?", "isUser": false},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      // 1. Add User Message
      _messages.add({"text": _messageController.text, "isUser": true});
      String userText = _messageController.text.toLowerCase();
      _messageController.clear();

      // 2. Simple Automated AI Responses based on keywords
      String botResponse = "I'm here for you. Tell me more or tap the main SOS button if you are in danger.";
      if (userText.contains("help") || userText.contains("scared")) {
        botResponse = "Stay calm. I can help guide you. Would you like me to track your path or suggest emergency numbers?";
      } else if (userText.contains("unsafe") || userText.contains("dark")) {
        botResponse = "Please turn on Safe Path Guidance from the dashboard to find illuminated pathways nearby.";
      }

      // 3. Add AI Response after a tiny delay
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.add({"text": botResponse, "isUser": false});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2533), // Matching Nexora Theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("AI Safety Assistant"),
      ),
      body: Column(
        children: [
          // Chat Messages View Area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length, // FIXED HERE: Changed from .size to .length
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["isUser"] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : const Color(0xFF2D3748),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg["text"].toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Message Input Box Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a safety question...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      fillColor: const Color(0xFF2D3748),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}