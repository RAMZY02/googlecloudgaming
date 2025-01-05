import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';

class ProductController {
  final String baseUrl = "http://192.168.18.18:3000/api/store";

  Future<void> addCustomer(Customer customer) async {
    final url = Uri.parse('$baseUrl/customers');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode == 201) {
        print("Customer added successfully.");
      } else {
        throw Exception('Failed to add customer: ${response.body}');
      }
    } catch (error) {
      print("Error adding customer: $error");
      rethrow;
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    final url = Uri.parse('$baseUrl/customers');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Customer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch customers: ${response.body}');
      }
    } catch (error) {
      print("Error fetching customers: $error");
      rethrow;
    }
  }
}
