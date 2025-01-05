import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductController {
  final String baseUrl = "http://192.168.18.18:3000/api/store"; // Menggunakan IP emulator Android

  // Method untuk mengambil semua produk
  Future<List<Product>> getAllProducts() async {
    try {
      // Lakukan HTTP GET request ke API
      print('asdasdasd');
      final response = await http.get(Uri.parse('$baseUrl/products'));
      print('asdasdasd');
      if (response.statusCode == 200) {
        // Parse the response dan map menjadi list of Product
        return List<Product>.from(
          json.decode(response.body).map((x) => Product.fromJson(x)),
        );
      } else {
        // Jika gagal, throw exception
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani jika ada error
      throw Exception('Error fetching products: $e');
    }
  }
}
