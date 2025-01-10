import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/supplier.dart';

class SupplierController {
  final String baseUrl = 'http://192.168.1.6:3000/api/pengepul'; // Ganti dengan URL backend Anda

  Future<List<Supplier>> fetchAllSuppliers(String token) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/supplier'),
        headers:{
          'Authorization': 'Bearer $token',
        }
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Supplier.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load suppliers');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addSupplier(
      {required String name,
        required String location,
        required String contact_info,
        required String material_name,
        required String token}) async {
    try {
      // Insert ke tabel SUPPLIERS
      final supplierResponse = await http.post(
        Uri.parse("$baseUrl/supplier"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "name": name,
          "location": location,
          "contact_info": contact_info,
        }),
      );

      if (supplierResponse.statusCode != 201) {
        throw Exception("Failed to insert supplier");
      }

      // Ambil ID supplier yang baru dibuat dari response backend
      final resSupplier = await http.get(Uri.parse('$baseUrl/supplier'));
      final List<dynamic> allSupplier = jsonDecode(resSupplier.body);
      final String supplierId = allSupplier[allSupplier.length - 1]["supplier_id"];

      final materialResponse = await http.post(
        Uri.parse("$baseUrl/material"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "materialName": material_name,
          "stockQuantity": 0,
          "supplierId": supplierId,
        }),
      );

      if (materialResponse.statusCode != 201) {
        throw Exception("Failed to insert new raw material");
      }
    } catch (e) {
      throw Exception("Error adding supplier: $e");
    }
  }
}

