import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shipment.dart';

class ShipmentService {
  final String baseUrl = "http://192.168.195.213:3000/api/store"; // Sesuaikan URL backend Anda

  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6IkNVUzAwMTEiLCJpYXQiOjE3MzY0NDc5MTQsImV4cCI6MTczNjQ1MTUxNH0.FBwT_aiMhyg0LpaSpvED2psaZW2mTQXFybiITlwkWY0';

  Future<List<Shipment>> fetchShipments() async {
    final url = Uri.parse("$baseUrl/product-shipments");


    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include the auth token here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Shipment.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch shipments: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching shipments: $e");
    }
  }
}
