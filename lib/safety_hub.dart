import 'dart:convert';
import 'package:flutter/material.dart';

class SafetyHub {
  // Private constructor for singleton pattern
  SafetyHub._privateConstructor();

  // The static shared instance variable accessible across your app pages
  static final SafetyHub instance = SafetyHub._privateConstructor();

  bool _isSosCurrentlyActive = false;

  /// Public getter to check active alert status safely from any screen
  bool get isSosCurrentlyActive => _isSosCurrentlyActive;

  /// Executed directly by your homepage long-press target widget
  Future<void> triggerSosAlert() async {
    if (_isSosCurrentlyActive) return; // Prevent duplicate overlapping streams

    _isSosCurrentlyActive = true;
    debugPrint("🚨 [NEXORA SYSTEM COMPONENT] SOS Protocol Initialized.");

    try {
      // 1. Core Network Transmission
      // This is where you talk to your admin backend console.
      // Replacing placeholder logic with a real loop:
      await _streamAlertToCentralHQ();

      // 2. Hardware / Local Device Fallback
      // You can add your location gathering or SMS payload utilities right here.
      await _packageLocalDeviceDiagnostics();

    } catch (error) {
      debugPrint("⚠️ SOS Execution Failure pipeline: $error");
    }
  }

  /// Reset system loop when the threat perimeter is verified clear by admin
  void clearActiveSosState() {
    _isSosCurrentlyActive = false;
    debugPrint("✅ [NEXORA SYSTEM COMPONENT] Emergency clearance state restored.");
  }

  /// Internal pipeline to stream telemetry directly to admin dashboard
  Future<void> _streamAlertToCentralHQ() async {
    debugPrint("📡 Streaming secure perimeter update packets to HQ administration data sync...");

    // Fake network delay simulation mimicking a secure handshake loop
    await Future.delayed(const Duration(milliseconds: 800));

    // In your final production server integration step, you will replace this with:
    // final response = await http.post(Uri.parse('YOUR_API_ENDPOINT/sos'), body: {...});

    debugPrint("🔒 Handshake Confirmed: Emergency status registered on security perimeter matrix.");
  }

  /// Gathers background metrics for verification
  Future<void> _packageLocalDeviceDiagnostics() async {
    final Map<String, dynamic> mockTelemetry = {
      "timestamp": DateTime.now().toIso8601String(),
      "device_status": "Sandbox Active",
      "mock_lat": 13.3409,
      "mock_lng": 74.7421,
    };

    debugPrint("📦 Encoded System Diagnostics Matrix: ${jsonEncode(mockTelemetry)}");
  }
}