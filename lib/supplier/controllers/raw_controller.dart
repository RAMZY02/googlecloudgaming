import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/raw.dart';

class RawController {
  final String baseUrl = 'http://192.168.195.148:3000/api/pengepul'; // Ganti dengan URL backend Anda

  Future<void> placeOrder(String id, int qty, String token) async {
    try {
      final resMaterial = await http.get(Uri.parse('$baseUrl/material/bysupplier/$id'));

      if (resMaterial.statusCode == 200) {
        final List<dynamic> materialData = json.decode(resMaterial.body);

        final url = Uri.parse("$baseUrl/material");
        final response = await http.put(
          url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "materialId": materialData[0]["material_id"],
            "materialName": materialData[0]["material_name"],
            "stockQuantity": materialData[0]["stock_quantity"] + qty,
            "supplier_id": materialData[0]["supplier_id"],
          }),
        );

        if (response.statusCode != 200) {
          throw Exception("Failed to order materials");
        }
      } else {
        throw Exception("Failed to order new materials. Error: ${resMaterial.body}");
      }
    } catch (error) {
      print("Error occurred while ordering material: $error");
      rethrow;
    }
  }
}