import 'package:cnmat/screens/login_page.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const AppScaffold({super.key, required this.body, required this.title});

  void signUserOut(BuildContext context) {
    // Navigate back to the login page directly
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(onTap: () {
          // Navigate to the registration page using a named route
          Navigator.pushNamed(context, '/register');
        }),
      ),
    );
  }

  // Optional: Confirm logout with the user
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
                signUserOut(context); // Log out the user
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? theme.scaffoldBackgroundColor : Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white
                    : Colors.blue[900], // Adjust based on theme
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'assets/images/logo2.png',
              height: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor:
            isDarkMode ? theme.scaffoldBackgroundColor : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Image.asset('assets/images/logo2.png'),
                ),
                Divider(
                  height: 30,
                  color:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
                ),
                // Home navigation
                _buildDrawerItem(
                    context, Icons.home, 'Home', '/home', isDarkMode),
                _buildDrawerItem(
                    context, Icons.person, 'Profile', '/profile', isDarkMode),
                _buildDrawerItem(context, Icons.medical_information,
                    'Appointments', '/appointments', isDarkMode),
                _buildDrawerItem(
                    context, Icons.info, 'About', '/about', isDarkMode),
                _buildDrawerItem(context, Icons.settings, 'Settings',
                    '/settings', isDarkMode),
              ],
            ),
            // Logout with confirmation
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: ListTile(
                leading: Icon(Icons.logout,
                    color: isDarkMode ? Colors.white : Colors.black),
                onTap: () => _confirmSignOut(context),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      String route, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        leading: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
