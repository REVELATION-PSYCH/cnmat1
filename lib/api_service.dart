// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      'http://172.20.10.4:8080/api/users'; // Replace with your backend IP

  Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Login successful; you could handle token storage here if needed
        print('Login successful');
        return true;
      } else {
        print('Failed to login: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error connecting to backend: $e');
      return false;
    }
  }

  Future<bool> requestNurse(
      String service, String date, double latitude, double longitude) async {
    final url = Uri.parse('$baseUrl/request-nurse');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service': service,
          'date': date,
          'location': {'latitude': latitude, 'longitude': longitude},
        }),
      );

      if (response.statusCode == 200) {
        print('Nurse request submitted successfully');
        return true;
      } else {
        print('Failed to request nurse: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error connecting to backend: $e');
      return false;
    }
  }
}
