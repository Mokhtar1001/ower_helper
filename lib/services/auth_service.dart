class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Stub for Node.js Auth
  Future<Map<String, dynamic>?> login(String email, String password) async {
    // TODO: Implement HTTP POST request to Node.js backend (/api/login)
    // For now, simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    return {"uid": "mock_user_123", "email": email, "token": "mock_jwt_token"};
  }

  Future<Map<String, dynamic>?> signUp(String name, String email, String password, String userType) async {
    // TODO: Implement HTTP POST request to Node.js backend (/api/signup)
    await Future.delayed(const Duration(seconds: 1));
    return {"uid": "mock_user_123", "email": email, "token": "mock_jwt_token"};
  }

  Future<void> signOut() async {
    // TODO: Implement logout logic (clear local storage, tokens, etc.)
  }
}
