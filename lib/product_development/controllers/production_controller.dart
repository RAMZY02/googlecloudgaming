import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductionController {
  final String baseUrl = 'http://192.168.1.6:3000/api/rnd'; // Ganti dengan URL backend Anda

  Future<void> submitProduction({
        required int designId,
        required int expectedQty,
        required String status,
        required String productionSize,
        }) async {
    try {
      // Insert ke tabel DESIGN
      final productionResponse = await http.post(
        Uri.parse("$baseUrl/production"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "designId": designId,
          "expectedQty": expectedQty,
          "status": status,
          "productionSize": productionSize,
        }),
      );

      if (productionResponse.statusCode != 201) {
        throw Exception("Failed to insert design");
      }
    } catch (e) {
      throw Exception("Error submitting design: $e");
    }
  }
}