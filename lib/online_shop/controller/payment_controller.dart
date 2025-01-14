import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment.dart';

class PaymentController {
  final String baseUrl = 'http://192.168.1.6:3000/api/store'; // Update this with your server URL

  Future<Payment> checkout(String cartId, Map<String, dynamic> customerDetails, String token) async {
    final url = Uri.parse('$baseUrl/cart/checkout');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'cart_id': cartId,
        'customerDetails': customerDetails,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('masok');
      return Payment.fromJson(data['transaction']);
    } else {
      print('ga masok');
      throw Exception('Failed to process checkout: ${response.body}');
    }
  }
}
