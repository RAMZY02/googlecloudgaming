import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/customer_register.dart';

class Customer_Controller {
  final String baseUrl = "http://10.10.1.248:3000/api/store";
  final storage = FlutterSecureStorage();  // For securely storing the JWT token
  // Function to add a new customer
  Future<String> addCustomer(Customer customer) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},  // Set the content type to JSON
        body: jsonEncode(customer.toJson()),  // Send customer data in the body
      );

      if (response.statusCode == 201) {
        return "Customer added successfully.";  // If customer added successfully
      } else {
        // If the response is not successful, throw an exception
        final error = jsonDecode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to add customer: $error');
      }
    } catch (error) {
      // Catch and rethrow any errors
      print("Error adding customer: $error");
      rethrow;
    }
  }

  // Function to fetch all customers
  Future<List<Customer>> getAllCustomers() async {
    final url = Uri.parse('$baseUrl/customers');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},  // Set the content type to JSON
      );  // Send GET request to fetch customers

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);  // Decode response body
        if (data.isEmpty) {
          print("No customers found.");
        }
        return data.map((json) => Customer.fromJson(json)).toList();  // Map JSON to List<Customer>
      } else {
        // If the response is not successful, throw an exception
        final error = jsonDecode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to fetch customers: $error');
      }
    } catch (error) {
      // Catch and rethrow any errors
      print("Error fetching customers: $error");
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

        // Store the JWT token securely using FlutterSecureStorage
        await storage.write(key: 'jwt_token', value: token);

        return "Login successful.";
      } else {
        final error = json.decode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to login: $error');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }
}
