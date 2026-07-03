import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 1. SAVE USER CREDENTIALS DURING REGISTRATION
  static Future<bool> registerUser(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the credentials locally
    await prefs.setString('saved_username', username);
    await prefs.setString('saved_password', password);
    return true;
  }

  // 2. CHECK CREDENTIALS DURING LOGIN
  static Future<bool> loginUser(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve what was previously saved
    String? savedName = prefs.getString('saved_username');
    String? savedPass = prefs.getString('saved_password');

    // Return true if they match exactly
    if (username == savedName && password == savedPass) {
      return true;
    }
    return false;
  }
}