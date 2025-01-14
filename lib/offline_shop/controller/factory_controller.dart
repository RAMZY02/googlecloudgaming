// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/factory_stock.dart';

class FactoryController {
  final String baseUrl = 'http://192.168.1.6:3000/api/store';
  Future<List<FactoryStock>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mv-products'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((product) => FactoryStock.fromJson(product)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      rethrow;
    }
  }
}
