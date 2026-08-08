import 'package:url_launcher/url_launcher.dart';

class SmsService {
  // Send SOS SMS to guardian with live location link
  static Future<void> sendSosAlert({
    required String guardianPhone,
    required double lat,
    required double lng,
    required String userName,
  }) async {
    final String locationLink =
        'https://www.google.com/maps?q=$lat,$lng';

    final String message =
        '🚨 EMERGENCY ALERT from Nexora!\n\n'
        '$userName needs immediate help!\n\n'
        'Live Location:\n$locationLink\n\n'
        'Please respond immediately or contact authorities.\n'
        '- Nexora Safety App';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: guardianPhone,
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  // Send a custom SMS message
  static Future<void> sendCustomSms({
    required String phoneNumber,
    required String message,
  }) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }
}