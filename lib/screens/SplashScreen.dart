import 'package:flutter/material.dart';
import 'intro.dart'; // Import the onboarding screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay before navigating to the onboarding screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            // logo
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.asset(
                'assets/images/logo2.png',
                height: 300,
              ),
            ),

            const SizedBox(
              height: 48,
            ),

            // title
            const Text(
              'C N M A T',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),

            // subtitle
            const SizedBox(
              height: 24,
            ),

            const Text(
              'Follow-Up Care brought Home!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),

            const SizedBox(
              height: 48,
            ),

            // Loading indicator
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
