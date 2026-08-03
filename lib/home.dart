import 'package:flutter/material.dart';
import 'safety_hub.dart';
import 'login_page.dart';

// Your exact file mappings linked directly to the structured UI rows
import 'safe_path.dart';
import 'geofence_map.dart';
import 'ai_chat.dart';
import 'content_removal.dart';
import 'educational_videos.dart';
import 'fake_call.dart';
import 'anonymous_chat.dart';
import 'video_call.dart';
import 'audio_call.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSosTriggered = false;
  bool _isBackgroundServiceActive = false;
  final String _selectedCity = "Mumbai";

  void _handleLongPressSos() {
    setState(() {
      _isSosTriggered = true;
    });
    SafetyHub.instance.triggerSosAlert();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🚨 SOS CRITICAL ALERT STREAMED TO HQ!"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B), // Dark blue slate theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Nexora User Dashboard",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white70),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. City Dropdown Selection Header Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_city_rounded, color: Colors.white70),
                  const SizedBox(width: 16),
                  const Text(
                    "City: ",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    _selectedCity,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.white70),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Background Runtime Service Switch Control Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Switch(
                    value: _isBackgroundServiceActive,
                    activeColor: Colors.greenAccent,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.white24,
                    onChanged: (val) {
                      setState(() {
                        _isBackgroundServiceActive = val;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isBackgroundServiceActive ? "Background Service: Active" : "Background Service: Inactive",
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. Central Crimson SOS Panic Target Circle
            Center(
              child: GestureDetector(
                onLongPress: _handleLongPressSos,
                onLongPressEnd: (_) {
                  setState(() => _isSosTriggered = false);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 195,
                      height: 195,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.redAccent.withOpacity(0.2), width: 2),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 155,
                      height: 155,
                      decoration: BoxDecoration(
                        color: _isSosTriggered ? Colors.red.shade900 : const Color(0xFFE11D48),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE11D48).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 6,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "SOS",
                          style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Press and hold in emergency situations",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 14, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 40),

            // SECTION 1: Core Navigation & AI Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernDashboardItem(Icons.gesture, "Safe Path\nGuidance", Colors.greenAccent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SafePathPage()));
                }),
                _buildModernDashboardItem(Icons.map_outlined, "Geofence\nMap", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GeofenceMapPage()));
                }),
                _buildModernDashboardItem(Icons.smart_toy_outlined, "AI Assistant\nChatbot", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AiChatPage()));
                }),
              ],
            ),

            const SizedBox(height: 32),

            // SECTION 2: Proactive Safety Tools
            const Text(
              "Proactive Safety Tools",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernDashboardItem(Icons.gpp_bad_outlined, "Content\nRemoval", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContentRemovalPage()));
                }),
                _buildModernDashboardItem(Icons.play_circle_outline_rounded, "Educational\nVideos", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EducationalVideosPage()));
                }),
                _buildModernDashboardItem(Icons.phone_in_talk_outlined, "Fake Call", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FakeCallPage()));
                }),
              ],
            ),

            const SizedBox(height: 32),

            // SECTION 3: Support & Awareness
            const Text(
              "Support & Awareness",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernDashboardItem(Icons.visibility_off_outlined, "Anonymous\nChat", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AnonymousChatPage()));
                }),
                _buildModernDashboardItem(Icons.video_call_outlined, "Video\nCall", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VideoCallPage()));
                }),
                _buildModernDashboardItem(Icons.local_phone_outlined, "Audio\nCall", Colors.white70, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AudioCallPage()));
                }),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDashboardItem(IconData icon, String title, Color iconColor, VoidCallback onTapAction) {
    return Expanded(
      child: InkWell(
        onTap: onTapAction,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w400, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}