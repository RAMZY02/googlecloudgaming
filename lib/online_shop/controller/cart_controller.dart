import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import '../models/cart_item.dart';

class CartController {
  final String baseUrl = "http://192.168.1.6:3000/api/store";

  // Function to add an item to the cart
  Future<bool> addToCart(cartItem request, String token) async {
    final url = Uri.parse("$baseUrl/cart/add");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the auth token here
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        print("Item added to cart successfully.");
        return true;
      } else {
        print("Failed to add item to cart: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error adding item to cart: $error");
      return false;
    }
  }

  Future<List<Cart>> getCartsByCustomerId(String customerId, String token) async {
    final url = Uri.parse("$baseUrl/carts/customer/$customerId");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the auth token here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cart.fromJson(json)).toList();
      } else {
        print("Failed to fetch carts: ${response.body}");
        return [];
      }
    } catch (error) {
      print("Error fetching carts: $error");
      return [];
    }
  }
}

