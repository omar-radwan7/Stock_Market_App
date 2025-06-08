import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
class AuthService {
  static const String _userKey = 'user_email';
  static const String _passwordKey = 'user_password';

  @pragma('vm:entry-point')
  Future<void> signUp(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, email);
    await prefs.setString(_passwordKey, password);
  }

  @pragma('vm:entry-point')
  Future<bool> signIn(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_userKey);
    final storedPassword = prefs.getString(_passwordKey);

    return email == storedEmail && password == storedPassword;
  }

  @pragma('vm:entry-point')
  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final hasUser = prefs.containsKey(_userKey);
    print('Checking if signed in: $hasUser'); // Debug log
    return hasUser;
  }

  @pragma('vm:entry-point')
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_passwordKey);
  }

  @pragma('vm:entry-point')
  Future<void> resetAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This will clear all SharedPreferences data
  }
}
