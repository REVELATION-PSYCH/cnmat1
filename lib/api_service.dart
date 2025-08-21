// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      'http://172.20.10.7:8080/api/users'; // Replace with your backend IP

  /// Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// LOGIN USER
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
        final jsonData = jsonDecode(response.body);

        // Expecting token from backend response
        if (jsonData['token'] != null) {
          await _saveToken(jsonData['token']);
        }

        print('✅ Login successful');
        return true;
      } else {
        print('❌ Failed to login: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('⚠️ Error connecting to backend: $e');
      return false;
    }
  }

  /// REQUEST NURSE
  Future<bool> requestNurse(
      String service, String date, double latitude, double longitude) async {
    final url = Uri.parse('$baseUrl/request-nurse');
    final token = await _getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'service': service,
          'date': date,
          'location': {'latitude': latitude, 'longitude': longitude},
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Nurse request submitted successfully');
        return true;
      } else {
        print('❌ Failed to request nurse: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('⚠️ Error connecting to backend: $e');
      return false;
    }
  }
}
