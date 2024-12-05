import 'package:cnmat/screens/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
// Placeholder for where users go after onboarding

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to CNMAT",
          body:
              "Request home care services from nearby nurses at your convenience.",
          image: Center(
              child: Image.asset("assets/images/image1.jpg", height: 175.0)),
        ),
        PageViewModel(
          title: "Find Nearby Nurses",
          body: "Easily locate and request the best nurses in your area.",
          image: Center(
              child: Image.asset("assets/images/image2.jpg", height: 175.0)),
        ),
        PageViewModel(
          title: "Track Your Requests",
          body: "Get real-time updates on the status of your care requests.",
          image: Center(
              child: Image.asset("assets/images/image3.png", height: 175.0)),
        ),
      ],
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) =>
                  const AuthPage()), // Navigates to the login screen
        );
      },
      onSkip: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) =>
                  const AuthPage()), // Skip button also navigates to login
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Get Started",
          style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
