import 'package:flutter/material.dart';

class GeofenceMapPage extends StatelessWidget {
  const GeofenceMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2533),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Geofence Boundary Map"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Status Card Indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3748),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.gpp_good_rounded, color: Colors.greenAccent),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Active Geofence Status: SECURE",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "You are within your designated safety perimeter.",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Simulated Circular Radar Map Grid Visual
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Range Ring
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.2), width: 2),
                      ),
                    ),
                    // Middle Range Ring
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.4), width: 1.5),
                      ),
                    ),
                    // Inner Safe Zone Geofence Circle
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent.withOpacity(0.05),
                        border: Border.all(color: Colors.greenAccent, width: 2),
                      ),
                    ),
                    // Center User Pulse Dot
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                            boxShadow: [
                              BoxShadow(color: Colors.blueAccent, blurRadius: 10, spreadRadius: 2),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("You", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Geofence Radius: 500 meters",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const Text(
              "Exiting this area will auto-trigger alerts to emergency contacts.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}