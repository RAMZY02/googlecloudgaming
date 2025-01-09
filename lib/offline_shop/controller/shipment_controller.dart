import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shipment.dart';

class ShipmentService {
  final String baseUrl = "http://192.168.18.18:3000/api/store"; // Sesuaikan URL backend Anda

  Future<List<Shipment>> fetchShipments() async {
    final url = Uri.parse("$baseUrl/product-shipments");

    try {
      final response = await http.get(url);

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
