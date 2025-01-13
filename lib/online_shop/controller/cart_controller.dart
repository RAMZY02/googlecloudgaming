import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import '../models/add_to_cart.dart';
import '../models/cart_item.dart';
import '../models/delete_cart_item.dart';
import '../models/update_cart_item.dart';

class CartController {
  final String baseUrl = "http://192.168.195.5:3000/api/store";

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

  Future<List<CartItem>> getCartItemsByCartId(String cartId, String token) async {
    final url = Uri.parse('$baseUrl/cartitems/cart/$cartId');
    try {
      final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token', // Include the auth token here
          },
      );

      if (response.statusCode == 200) {
        return List<CartItem>.from(
            json.decode(response.body).map((x) => CartItem.fromJson(x)),
        );
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (error) {
      throw Exception('Error fetching cart items: $error');
    }
  }

  Future<bool> updateCartItemQuantity(
      UpdateCartItemRequest request, String token) async {
    final url = Uri.parse("$baseUrl/cart/update_quantity");

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the auth token
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        print("Cart item quantity updated successfully.");
        return true;
      } else {
        print("Failed to update cart item quantity: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Error updating cart item quantity: $error");
      return false;
    }
  }

  Future<void> removeCartItemById(String cartItemId, String token) async {
    final url = Uri.parse('$baseUrl/cart/remove_item');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cart_item_id': cartItemId, // Mengirim cart_item_id sesuai backend
        }),
      );

      if (response.statusCode == 200) {
        final message = json.decode(response.body)['message'];
        print(message); // Menampilkan pesan sukses
      } else {
        throw Exception('Failed to remove cart item: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error removing cart item: $error');
    }
  }
}

