class AuthService {
  Future<bool> signIn(String email, String password) async {
    // TODO: Implement real authentication
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(milliseconds: 500));
  }
}
