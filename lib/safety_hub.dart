import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'location_service.dart';
import 'notification_service.dart';
import 'sms_service.dart';
import 'auth_service.dart';

class SafetyHub {
  // ─── Singleton ─────────────────────────────────────────────────────────────
  SafetyHub._privateConstructor();
  static final SafetyHub instance = SafetyHub._privateConstructor();

  // ─── State ─────────────────────────────────────────────────────────────────
  bool _isSosActive = false;
  bool _isShakeDetectionOn = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // Shake detection thresholds
  static const double _shakeThreshold = 15.0; // m/s² — vigorous shake
  static const int _shakeCountRequired = 3;   // number of shakes to trigger
  static const Duration _shakeWindow = Duration(seconds: 2);

  int _shakeCount = 0;
  DateTime? _firstShakeTime;

  bool get isSosActive => _isSosActive;
  bool get isShakeDetectionOn => _isShakeDetectionOn;

  // ─── INITIALIZE ────────────────────────────────────────────────────────────
  Future<void> initialize() async {
    await NotificationService.initialize();
    debugPrint('✅ SafetyHub initialized.');
  }

  // ─── SHAKE DETECTION ───────────────────────────────────────────────────────
  void startShakeDetection(VoidCallback onShakeTriggered) {
    if (_isShakeDetectionOn) return;
    _isShakeDetectionOn = true;
    _shakeCount = 0;
    _firstShakeTime = null;

    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
          // Calculate total acceleration magnitude
          double magnitude =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

          // Subtract gravity (~9.8 m/s²) to get net shake force
          double netAcceleration = (magnitude - 9.8).abs();

          if (netAcceleration > _shakeThreshold) {
            final now = DateTime.now();

            // Start shake window timer on first shake
            if (_firstShakeTime == null) {
              _firstShakeTime = now;
              _shakeCount = 1;
            } else {
              // Check if within shake window
              if (now.difference(_firstShakeTime!) <= _shakeWindow) {
                _shakeCount++;
                debugPrint('🤳 Shake detected: $_shakeCount/$_shakeCountRequired');

                if (_shakeCount >= _shakeCountRequired) {
                  // Reset and trigger SOS
                  _shakeCount = 0;
                  _firstShakeTime = null;
                  debugPrint('🚨 Shake threshold reached! Triggering SOS...');
                  onShakeTriggered();
                }
              } else {
                // Window expired, reset counter
                _firstShakeTime = now;
                _shakeCount = 1;
              }
            }
          }
        });

    debugPrint('📳 Shake detection started.');
  }

  void stopShakeDetection() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _isShakeDetectionOn = false;
    _shakeCount = 0;
    _firstShakeTime = null;
    debugPrint('⏹️ Shake detection stopped.');
  }

  // ─── TRIGGER SOS ───────────────────────────────────────────────────────────
  Future<String> triggerSosAlert() async {
    if (_isSosActive) {
      return 'SOS already active.';
    }

    _isSosActive = true;
    debugPrint('🚨 SOS Protocol Initiated...');

    try {
      // 1. Get real GPS location
      final position = await LocationService.getCurrentLocation();

      double lat = position?.latitude ?? 0.0;
      double lng = position?.longitude ?? 0.0;
      bool hasLocation = position != null;

      String locationText = hasLocation
          ? LocationService.formatCoordinates(lat, lng)
          : 'Location unavailable';

      String locationLink = hasLocation
          ? LocationService.buildLocationLink(lat, lng)
          : 'Location unavailable';

      // 2. Get current user profile from Firestore
      final userProfile = await AuthService.getCurrentUserProfile();
      final String userName = userProfile?['name'] ?? 'Nexora User';
      final String guardianPhone = userProfile?['guardianPhone'] ?? '';
      final String uid = AuthService.getCurrentUid() ?? '';

      // 3. Save SOS event to Firestore
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('sos_alerts').add({
          'uid': uid,
          'userName': userName,
          'latitude': lat,
          'longitude': lng,
          'locationLink': locationLink,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'active',
          'triggerMethod': 'manual',
        });
        debugPrint('📡 SOS saved to Firestore.');
      }

      // 4. Show local notification
      await NotificationService.showSosNotification(
        locationText: locationText,
      );

      // 5. Send SMS to guardian (opens SMS app)
      if (guardianPhone.isNotEmpty) {
        await SmsService.sendSosAlert(
          guardianPhone: guardianPhone,
          lat: lat,
          lng: lng,
          userName: userName,
        );
        debugPrint('📱 SMS alert sent to guardian: $guardianPhone');
      }

      debugPrint('✅ SOS pipeline complete.');
      return hasLocation
          ? 'SOS sent! Location: $locationText'
          : 'SOS sent! (Location unavailable)';
    } catch (e) {
      debugPrint('⚠️ SOS error: $e');
      _isSosActive = false;
      return 'SOS failed. Please try again.';
    }
  }

  // ─── TRIGGER SOS FROM SHAKE ────────────────────────────────────────────────
  Future<String> triggerSosFromShake() async {
    if (_isSosActive) return 'SOS already active.';
    _isSosActive = true;

    try {
      final position = await LocationService.getCurrentLocation();
      double lat = position?.latitude ?? 0.0;
      double lng = position?.longitude ?? 0.0;
      bool hasLocation = position != null;

      String locationText = hasLocation
          ? LocationService.formatCoordinates(lat, lng)
          : 'Location unavailable';

      String locationLink = hasLocation
          ? LocationService.buildLocationLink(lat, lng)
          : 'Location unavailable';

      final userProfile = await AuthService.getCurrentUserProfile();
      final String userName = userProfile?['name'] ?? 'Nexora User';
      final String guardianPhone = userProfile?['guardianPhone'] ?? '';
      final String uid = AuthService.getCurrentUid() ?? '';

      // Save to Firestore with shake trigger method
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('sos_alerts').add({
          'uid': uid,
          'userName': userName,
          'latitude': lat,
          'longitude': lng,
          'locationLink': locationLink,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'active',
          'triggerMethod': 'shake',
        });
      }

      await NotificationService.showSosNotification(
        locationText: locationText,
      );

      if (guardianPhone.isNotEmpty) {
        await SmsService.sendSosAlert(
          guardianPhone: guardianPhone,
          lat: lat,
          lng: lng,
          userName: userName,
        );
      }

      return hasLocation
          ? '🤳 Shake SOS sent! Location: $locationText'
          : '🤳 Shake SOS sent! (Location unavailable)';
    } catch (e) {
      _isSosActive = false;
      return 'Shake SOS failed.';
    }
  }

  // ─── CLEAR SOS ─────────────────────────────────────────────────────────────
  void clearSos() {
    _isSosActive = false;
    debugPrint('✅ SOS cleared.');
  }

  // ─── DISPOSE ───────────────────────────────────────────────────────────────
  void dispose() {
    stopShakeDetection();
  }
}