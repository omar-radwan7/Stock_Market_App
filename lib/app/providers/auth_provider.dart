import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class User {
  final String? displayName;
  final String email;

  User({this.displayName, required this.email});
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(String email, String? displayName) {
    _currentUser = User(email: email, displayName: displayName);
    notifyListeners();
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _currentUser = await _authService.signIn(email, password);
    notifyListeners();
  }
}
