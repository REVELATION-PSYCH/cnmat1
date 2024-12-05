import 'dart:convert';

import 'package:cnmat/components/my_textfield.dart';
import 'package:cnmat/screens/AppScaffold.dart';
import 'package:cnmat/utilities/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Profile extends StatefulWidget {
  const Profile({super.key, required});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? _profle;
  String? _token;

  bool isLoading = false;
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final nameController = TextEditingController();
  DateTime dob = DateTime.now();

  Future<Map<String, dynamic>?> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('profile'); // Retrieve JSON String
    if (jsonString != null) {
      return jsonDecode(jsonString); // Convert JSON String to Map
    }
    return null; // Return null if no data found
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void initState() {
    super.initState();
    _loadProfleData();
  }

  Future<void> _loadProfleData() async {
    Map<String, dynamic>? data = await getProfileData();
    setState(() {
      _profle = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            const CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage("assets/images/profile.jpeg"), // Placeholder image
            ),
            const SizedBox(height: 20),

            // Username
            Text(
              _profle?['name'], // Replace with username
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Email
            Text(
              _profle?['email'], // Replace with email
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Edit Profile Button
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              onPressed: () {
                // Navigate to Edit Profile Page
                _showRequestNurseDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
            const SizedBox(height: 30),

            // Additional Info
            _buildProfileDetailItem('Phone Number', _profle?['phone']),
            _buildProfileDetailItem('Address', _profle?['address']),
            _buildProfileDetailItem('Date of Birth', _profle?['dob']),
          ],
        ),
      ),
    );
  }

  void genericErrorMessage(String message, String? type) {
    showAlert(context, message, type);
  }

  void showAlert(BuildContext context, String message, String? type) {
    Color color = const Color.fromARGB(255, 255, 25, 25);

    if (type == 'success') {
      color = Colors.green;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Duration to display the alert
        backgroundColor: color, // Optional: Customize background color
        behavior: SnackBarBehavior.floating, // Optional: Floating style
      ),
    );
  }

  Future<void> storeProfileData(Map<String, dynamic> jsonData) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString =
        convert.jsonEncode(jsonData); // Convert Map to JSON String
    await prefs.setString('profile', jsonString);
  }

  void saveProfile(contextd) async {
    if (emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      _token = await getToken();
      var baseurl = Config.API_URL;

      var response = await http.post(Uri.parse('$baseurl/profile.php'), body: {
        'address': addressController.text,
        'email': emailController.text,
        'name': nameController.text,
        'phone': phoneController.text,
        'dob': "${dob.year}-${dob.month}-${dob.day}",
      }, headers: {
        'Authorisation': "Bearer $_token"
      });
      if (response.statusCode == 200) {
        print(response.body);
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var status = jsonResponse['status'];
        var message = jsonResponse['message'];
        var profile = jsonResponse['profile'];
        if (status == 'success') {
          genericErrorMessage('$message.', 'success');
          Navigator.of(contextd).pop(); // Close the dialog
          await storeProfileData(profile);
          _loadProfleData();
        }
      } else {
        genericErrorMessage(
            'Request failed with status: ${response.statusCode}.', 'error');
      }
    } else {
      Navigator.of(contextd).pop(); // Close the dialog
      genericErrorMessage('Fill is all fields', 'error');
    }
  }

  void _showRequestNurseDialog(BuildContext context) {
    emailController.text = _profle?['email'];
    nameController.text = _profle?['name'];
    phoneController.text = _profle?['phone'];
    addressController.text = _profle?['address'];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Request a Nurse'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _pickDateAndTime(context, (pickedDateTime) {
                      if (pickedDateTime.isBefore(DateTime.now())) {
                        setState(() {
                          dob = pickedDateTime;
                        });
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${dob.day}/${dob.month}/${dob.year}"),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 20),
                  // Password TextField
                  MyTextField(
                    controller: nameController,
                    obscureText: false,
                    hintText: 'Name',
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 20),
                  // Password TextField
                  MyTextField(
                    controller: addressController,
                    hintText: 'Address',
                    obscureText: false,
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password TextField
                  MyTextField(
                    controller: phoneController,
                    hintText: 'Phone',
                    obscureText: false,
                    fillColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 30),
                  // save Button
                  TextButton(
                    onPressed: () {
                      saveProfile(context);
                    },
                    child: const Text('Save'),
                  ),
                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _pickDateAndTime(
      BuildContext context, Function(DateTime) onDateTimePicked) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      DateTime pickedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
      onDateTimePicked(pickedDateTime);
    }
  }

  // Widget for individual profile details
  Widget _buildProfileDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
