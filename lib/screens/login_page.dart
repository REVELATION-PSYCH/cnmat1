import 'package:cnmat/components/my_buttom.dart';
import 'package:cnmat/components/my_textfield.dart';
import 'package:cnmat/screens/HomePage.dart';
import 'package:cnmat/utilities/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Save the token
  }

  Future<void> saveProfileData(Map<String, dynamic> jsonData) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString =
        convert.jsonEncode(jsonData); // Convert Map to JSON String
    await prefs.setString('profile', jsonString);
  }

  void mockSignUserIn() async {
    // Simulate a successful login by directly navigating to the home page
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var baseurl = Config.API_URL;
      var response = await http.post(Uri.parse('$baseurl/login.php'), body: {
        'email': emailController.text,
        'password': passwordController.text
      });
      if (response.statusCode == 200) {
        //print(response.body);
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var status = jsonResponse['status'];
        var message = jsonResponse['message'];

        if (status == 'success') {
          var token = jsonResponse['token'];
          var profile = jsonResponse['profile'];
          await saveToken(token);
          await saveProfileData(profile);
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
        genericErrorMessage('$message.');
      } else {
        genericErrorMessage(
            'Request failed with status: ${response.statusCode}.');
      }
      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      ); */
    } else {
      genericErrorMessage('Please enter both email and password');
    }
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/logo2.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  'Login to CNMAT',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Email TextField
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  fillColor: Colors.blue[50],
                ),
                const SizedBox(height: 20),
                // Password TextField
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  fillColor: Colors.blue[50],
                ),
                const SizedBox(height: 30),
                // Sign In Button
                MyButton(
                  onTap: mockSignUserIn,
                  text: 'Sign In',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Not a member?',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                      Text(
                        ' Register now',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
