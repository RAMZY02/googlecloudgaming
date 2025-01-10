import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionService {
  static const String apiUrl = "http://192.168.195.5:3000/api/store";  // Update to your API base URL
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6IkNVUzAwMDQiLCJpYXQiOjE3MzY1MTM3OTcsImV4cCI6MTczNjUxNzM5N30.B2FDfiQzu3tin2xfrn50jbwQcaJTfYhGrTCZWB5EDRI';
  // Function to handle the transaction
  Future<Transaction> offlineTransactionNonMember(
      String saleChannel, List<String> products, List<int> quantities, List<int> prices) async {
    try {
      final url = Uri.parse('$apiUrl/cart/offline_transaction_non_member');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'sale_channel': saleChannel,
          'products': products,
          'quantities': quantities,
          'prices': prices,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return Transaction.fromJson(responseData);
      } else {
        throw Exception('Failed to complete the transaction. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
