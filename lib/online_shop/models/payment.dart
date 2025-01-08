import 'dart:convert';

import 'customer_detail.dart';

class Payment {
  final String token;
  final String paymentUrl;
  final String cartId; // Menambahkan cartId
  final CustomerDetails customerDetails; // Menambahkan customerDetails

  Payment({
    required this.token,
    required this.paymentUrl,
    required this.cartId,
    required this.customerDetails,
  });

  // Factory method untuk membuat objek Payment dari JSON map
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      token: json['token'] ?? '',
      paymentUrl: json['redirect_url'] ?? '',
      cartId: json['cart_id'] ?? '',
      customerDetails: CustomerDetails.fromJson(json['customerDetails'] ?? {}),
    );
  }

  // Method untuk mengonversi objek Payment ke JSON map
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'payment_url': paymentUrl,
      'cart_id': cartId, // Menambahkan cartId ke dalam JSON
      'customerDetails': customerDetails.toJson(), // Menambahkan customerDetails ke dalam JSON
    };
  }
}
