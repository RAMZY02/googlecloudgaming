import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_card.dart';
import '../models/product_stock.dart';

class ProductController {
  final String baseUrl = "http://192.168.18.18:3000/api/store";

  Future<List<Product_Cart>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        // Mengambil langsung data array dari response
        return List<Product_Cart>.from(
          json.decode(response.body).map((x) => Product_Cart.fromJson(x)),
        );
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Product_Cart>> getNewReleaseProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/new_releases'));
      if (response.statusCode == 200) {
        // Mengambil langsung data array dari response
        return List<Product_Cart>.from(
          json.decode(response.body).map((x) => Product_Cart.fromJson(x)),
        );
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<int> getProductStock(String productName, String productSize) async {
    try {
      print(productName);
      print(productSize);
      final response = await http.get(
        Uri.parse('$baseUrl/products/stock?product_name=$productName&product_size=$productSize'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Respons Data: $data");
        if (data.isNotEmpty) {
          final productStock = data[0];
          if (productStock is Map<String, dynamic>) {
            print("Stok: ${productStock['stok_qty']}");
            return productStock['stok_qty'] ?? 0;
          } else {
            throw Exception('Data tidak sesuai format yang diharapkan');
          }
        } else {
          print("Tidak ada data stok ditemukan");
          return 0;
        }
      } else {
        throw Exception('Gagal memuat stok produk');
      }
    } catch (e) {
      print("Error fetching product stock: $e");
      return 0;
    }
  }


}
