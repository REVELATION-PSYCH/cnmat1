import 'package:cnmat/screens/HomePage.dart';
import 'package:cnmat/screens/login_or_registerPage.dart';
import 'package:cnmat/services/AuthService.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Future<bool> _authStatusFuture;

  @override
  void initState() {
    super.initState();
    _authStatusFuture = _checkAuthStatus(); // Initialize Future in initState
  }

  Future<bool> _checkAuthStatus() async {
    try {
      return await AuthService().checkAuthStatus();
    } catch (e) {
      // Handle errors
      print("Error checking auth status: $e");
      return false; // Assume not authenticated on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authStatusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          // Handle error state
          return const Scaffold(
            body: Center(child: Text('An error occurred. Please try again.')),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const HomePage(); // User is logged in
        } else {
          return const LoginOrRegisterPage(); // User is not logged in
        }
      },
    );
  }
}
