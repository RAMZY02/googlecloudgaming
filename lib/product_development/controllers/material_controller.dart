import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/material.dart';

class MaterialController {
  final String _baseUrl = 'http://192.168.1.6:3000/api/rnd'; // Ganti dengan URL backend Anda

  Future<List<MaterialModel>> fetchFilteredMaterials() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/filtered-material'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        return data.map((item) => MaterialModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load materials');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
