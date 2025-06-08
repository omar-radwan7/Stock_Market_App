import '../providers/auth_provider.dart';

class AuthService {
  Future<User> signIn(String email, String password) async {
    // Here you would typically make an API call to your backend
    // For now, we'll simulate a successful login
    await Future.delayed(const Duration(seconds: 1));
    return User(
      email: email,
      displayName: 'Omar Radwan', // Set default display name
    );
  }

  Future<User> signUp(
    String email,
    String password,
    String? displayName,
  ) async {
    // Here you would typically make an API call to your backend
    // For now, we'll simulate a successful registration
    await Future.delayed(const Duration(seconds: 1));
    return User(
      email: email,
      displayName:
          displayName ??
          'Omar Radwan', // Use provided name or default to Omar Radwan
    );
  }

  Future<void> signOut() async {
    // Here you would typically make an API call to your backend
    // For now, we'll just simulate a delay
    await Future.delayed(const Duration(seconds: 1));
  }
}
