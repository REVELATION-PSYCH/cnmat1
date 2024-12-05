import 'package:cnmat/screens/AppScaffold.dart';
import 'package:cnmat/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening web links

class Settings extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentTheme;

  const Settings({
    super.key,
    required this.onThemeChanged,
    required this.currentTheme,
  });

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.currentTheme == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Account settings section
          _buildSettingsSectionTitle('Account'),
          _buildSettingsOption(
            context,
            icon: Icons.person,
            title: 'Manage Account',
            onTap: () {
              Navigator.pushNamed(
                  context, '/profile'); // Navigate to Profile Page
            },
          ),

          // Notification settings
          _buildSettingsSectionTitle('Notifications'),
          _buildSettingsOption(
            context,
            icon: Icons.notifications,
            title: 'Notification Preferences',
            onTap: () {
              Navigator.pushNamed(context,
                  '/notification-settings'); // Navigate to Notification Settings
            },
          ),

          // Theme settings
          _buildSettingsSectionTitle('Theme'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
              widget.onThemeChanged(
                  _isDarkMode ? ThemeMode.dark : ThemeMode.light);
            },
          ),

          // Privacy settings
          _buildSettingsSectionTitle('Privacy'),
          _buildSettingsOption(
            context,
            icon: Icons.lock,
            title: 'Privacy Policy',
            onTap: () {
              _launchURL('https://cnmat.policy.com'); // Open Privacy Policy URL
            },
          ),

          // Logout option
          _buildSettingsOption(
            context,
            icon: Icons.logout,
            title: 'Log Out',
            onTap: () {
              _confirmSignOut(context); // Handle log out action
            },
          ),
        ],
      ),
    );
  }

  // Sign-out method
  void _signUserOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(onTap: () {
          Navigator.pushNamed(context, '/register');
        }),
      ),
    );
  }

  // Show logout confirmation dialog
  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signUserOut(context); // Log out the user
              },
            ),
          ],
        );
      },
    );
  }

  // Widget to create a section title
  Widget _buildSettingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  // Widget to create each settings option with an icon
  Widget _buildSettingsOption(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Method to launch a URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
