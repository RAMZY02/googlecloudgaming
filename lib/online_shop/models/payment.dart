import 'dart:convert';

import 'customer_detail.dart';

class Payment {
  final String orderId;
  final double totalAmount;
  final String paymentUrl;
  final String cartId; // Menambahkan cartId
  final CustomerDetails customerDetails; // Menambahkan customerDetails

  Payment({
    required this.orderId,
    required this.totalAmount,
    required this.paymentUrl,
    required this.cartId,
    required this.customerDetails,
  });

  // Factory method untuk membuat objek Payment dari JSON map
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      orderId: json['order_id'] ?? '',
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      paymentUrl: json['payment_url'] ?? '',
      cartId: json['cart_id'] ?? '', // Menambahkan pengambilan cartId
      customerDetails: CustomerDetails.fromJson(json['customerDetails'] ?? {}), // Menambahkan pengambilan customerDetails
    );
  }

  // Method untuk mengonversi objek Payment ke JSON map
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'total_amount': totalAmount,
      'payment_url': paymentUrl,
      'cart_id': cartId, // Menambahkan cartId ke dalam JSON
      'customerDetails': customerDetails.toJson(), // Menambahkan customerDetails ke dalam JSON
    };
  }
}
