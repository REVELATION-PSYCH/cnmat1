import 'package:cnmat/components/my_buttom.dart';
import 'package:cnmat/components/my_textfield.dart';
import 'package:cnmat/screens/login_page.dart';
import 'package:cnmat/utilities/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  void registerUser() async {
    // Check if any field is empty
    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      genericErrorMessage('Please fill in all fields.');
      return;
    }

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      genericErrorMessage('Passwords do not match!');
      return;
    }

    var baseurl = Config.API_URL; // e.g., http://172.20.10.7:8085/api/auth

    try {
      final response = await http.post(
        Uri.parse('$baseurl/register'), // Match your backend endpoint
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var status = jsonResponse['status'];
        var message = jsonResponse['message'] ?? 'Registration completed';

        genericErrorMessage(message);

        if (status == 'success') {
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(onTap: widget.onTap)),
            );
          });
        }
      } else {
        genericErrorMessage(
            'Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      genericErrorMessage('An error occurred: $e');
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/logo2.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: nameController,
                    hintText: 'Name',
                    obscureText: false,
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    onTap: registerUser,
                    text: 'Sign Up',
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
