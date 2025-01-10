import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/material.dart';

class MaterialController {
  final String _baseUrl = 'http://192.168.195.148:3000/api/rnd'; // Ganti dengan URL backend Anda

  Future<List<MaterialModel>> fetchAllMaterials() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/material'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => MaterialModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load materials');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<MaterialModel>> fetchFilteredMaterials() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/filtered-material'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => MaterialModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load materials');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<MaterialModel>> fetchSelectedDesignMaterials(int id) async {
    try {
      final retData = [];
      final resDesignMats = await http.get(Uri.parse('$_baseUrl/design-material/design/$id'));

      if (resDesignMats.statusCode == 200) {
        final List<dynamic> allDesignMats = json.decode(resDesignMats.body);
        for (var designmats in allDesignMats) {
          final resMats = await http.get(Uri.parse('$_baseUrl/material/${designmats["material_id"]}'));
          final List<dynamic> matsData = json.decode(resMats.body);
          retData.add({"material_id": matsData[0]["material_id"], "material_name": matsData[0]["material_name"], "stock_quantity": matsData[0]["stock_quantity"], "last_update": matsData[0]["last_update"]});
          matsData.clear();
        }
      } else {
        throw Exception('Failed to load materials');
      }
      return retData.map((item) => MaterialModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateMaterial(String id, int qty) async {
    try {
      final resData = await http.get(Uri.parse('$_baseUrl/material/$id'));
      final List<dynamic> matsData = json.decode(resData.body);
      print(id);
      print(qty);
      print(matsData);
        var quantity = matsData[0]["stock_quantity"] - qty;
        print(quantity);
        final url2 = Uri.parse("$_baseUrl/material");
        final response = await http.put(
          url2,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "material_id": matsData[0]["material_id"],
            "material_name": matsData[0]["material_name"],
            "stock_quantity": quantity,
          }),
        );

        if (response.statusCode != 200) {
          throw Exception("Failed to update material");
        }

    } catch (error) {
      print("Error occurred while updating material: $error");
      rethrow;
    }
  }
}
