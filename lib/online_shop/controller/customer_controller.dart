import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/customer_register.dart';

class CustomerController {
  final String baseUrl = "http://192.168.195.5:3000/api/store";
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

        // Decode the JWT token to extract the payload
        final payloadMap = decodeJwtTokenManually(token);

        // Get the customer ID from the decoded payload
        String? customerId = payloadMap['customer_id'];

        print("Customer ID: $customerId");

        // Save the token and customer ID into secure storage
        await storage.write(key: 'jwt_token', value: token);

        if (customerId != null) {
          await storage.write(key: 'customer_id', value: customerId);
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

  Future<Customer> getCustomerById(String customerId, String token) async {
    final url = Uri.parse('$baseUrl/customers/$customerId');
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
        return Customer.fromJson(data); // Map JSON response to Customer object
      } else {
        final error = jsonDecode(response.body)['error'] ?? response.reasonPhrase;
        throw Exception('Failed to fetch customer: $error');
      }
    } catch (error) {
      print("Error fetching customer by ID: $error");
      rethrow;
    }
  }
}
