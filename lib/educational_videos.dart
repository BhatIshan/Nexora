import 'package:flutter/material.dart';

class EducationalVideosPage extends StatelessWidget {
  const EducationalVideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // A simple mock list of video content
    final List<Map<String, String>> videos = [
      {"title": "How to Use SOS Safely", "duration": "2:30"},
      {"title": "Personal Safety Habits", "duration": "4:15"},
      {"title": "Understanding Your Rights", "duration": "3:50"},
      {"title": "Self-Defense Basics", "duration": "5:00"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1B2533),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Safety Education"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.white24),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 40),
            title: Text(videos[index]["title"]!, style: const TextStyle(color: Colors.white)),
            subtitle: Text("${videos[index]["duration"]} min", style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Playing: ${videos[index]["title"]}")),
              );
            },
          );
        },
      ),
    );
  }
}