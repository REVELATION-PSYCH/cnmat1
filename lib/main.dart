import 'package:cnmat/screens/HomePage.dart';
import 'package:cnmat/screens/SplashScreen.dart';
import 'package:cnmat/screens/about.dart';
import 'package:cnmat/screens/Appointments.dart';
import 'package:cnmat/screens/login_page.dart';
import 'package:cnmat/screens/profile.dart';
import 'package:cnmat/screens/register_page.dart';
import 'package:cnmat/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('themeMode');
    setState(() {
      if (theme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (theme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  void _saveThemePreference(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme);
  }

  void _updateTheme(ThemeMode newMode) {
    setState(() {
      _themeMode = newMode;
    });
    _saveThemePreference(newMode == ThemeMode.light ? 'light' : 'dark');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CNMAT',
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode, // Dynamic theme mode
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(onTap: () {
              Navigator.pushNamed(context, '/register');
            }),
        '/register': (context) => RegisterPage(onTap: () {
              Navigator.pushNamed(context, '/login');
            }),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const Profile(),
        '/appointments': (context) => const Appointments(),
        '/about': (context) => const about(),
        '/settings': (context) => Settings(
              onThemeChanged: _updateTheme, // Pass the theme update function
              currentTheme: _themeMode, // Pass the current theme mode
            ),
      },
    );
  }
}
