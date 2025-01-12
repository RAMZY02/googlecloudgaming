import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/staff_register.dart';

class StaffController {
  final String baseUrl = "http://192.168.195.148:3000/api/store";
  final storage = FlutterSecureStorage();  // For securely storing the JWT token
  // Function to add a new staff
  Future<String> addStaff(Staff staff) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},  // Set the content type to JSON
        body: jsonEncode(staff.toJson()),  // Send staff data in the body
      );

      if (response.statusCode == 201) {
        return "Staff added successfully.";  // If staff added successfully
      } else {
        // If the response is not successful, throw an exception
        final error = jsonDecode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to add staff: $error');
      }
    } catch (error) {
      // Catch and rethrow any errors
      print("Error adding staff: $error");
      rethrow;
    }
  }

  // Function to fetch all staffs
  Future<List<Staff>> getAllStaffs() async {
    final url = Uri.parse('$baseUrl/staffs');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},  // Set the content type to JSON
      );  // Send GET request to fetch staffs

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);  // Decode response body
        if (data.isEmpty) {
          print("No staffs found.");
        }
        return data.map((json) => Staff.fromJson(json)).toList();  // Map JSON to List<Staff>
      } else {
        // If the response is not successful, throw an exception
        final error = jsonDecode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to fetch staffs: $error');
      }
    } catch (error) {
      // Catch and rethrow any errors
      print("Error fetching staffs: $error");
      rethrow;
    }
  }

  Future<String> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        // Decode the JWT token to extract the payload
        final payloadMap = decodeJwtTokenManually(token);

        // Get the staff ID from the decoded payload
        String? staffId = payloadMap['customer_id'];

        print("Staff ID: $staffId");

        // Save the token and staff ID into secure storage
        await storage.write(key: 'jwt_token', value: token);

        if (staffId != null) {
          await storage.write(key: 'customer_id', value: staffId);
        }

        return "Login successful.";
      } else {
        final error = json.decode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to login: $error');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Map<String, dynamic> decodeJwtTokenManually(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token');
      }

      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      final payloadMap = json.decode(utf8.decode(payload)) as Map<String, dynamic>;

      print("Decoded Payload: $payloadMap");

      return payloadMap;
    } catch (e) {
      print("Error decoding JWT token: $e");
      throw Exception('Error decoding JWT token');
    }
  }

  Future<Staff> getStaffById(String staffId, String token) async {
    final url = Uri.parse('$baseUrl/staffs/$staffId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Staff.fromJson(data); // Map JSON response to Staff object
      } else {
        final error = jsonDecode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to fetch staff: $error');
      }
    } catch (error) {
      print("Error fetching staff by ID: $error");
      rethrow;
    }
  }
}
