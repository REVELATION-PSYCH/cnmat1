class AuthService {
  // Mock signUp method
  Future<void> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email.isNotEmpty && password.isNotEmpty) {
      print('Registration successful');
    } else {
      print('Registration failed: Invalid input');
    }
  }

  // Mock signIn method
  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email == "test@example.com" && password == "password123") {
      print('Login successful');
    } else {
      print('Login failed: Invalid credentials');
    }
  }

  Future<bool> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate checking
    return false; // Always returning false for now
  }
}
