import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/production.dart';

class ProductionController {
  final String baseUrl = 'http://192.168.195.148:3000/api/rnd'; // Ganti dengan URL backend Anda

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

  Future<List<Production>> fetchAllOngoingProductions() async {
    try {
      final retData = [];
      String designName;
      final resProduction = await http.get(Uri.parse('$baseUrl/production'));

      if (resProduction.statusCode == 200) {
        final List<dynamic> allProduction = json.decode(resProduction.body);
        for (var production in allProduction) {
          designName = "";
          if(production["status"] == "Ongoing"){
            final resDesign = await http.get(Uri.parse("$baseUrl/design/${production["design_id"]}"));
            if (resDesign.statusCode == 200) {
              final List<dynamic> designData = json.decode(resDesign.body);
              designName = designData[0]["name"];
              retData.add({"id": production["id"], "design_id":production["design_id"], "name":designName, "expected_qty":production["expected_qty"], "actual_qty":production["actual_qty"], "status":production["status"], "production_size":production["production_size"]});
            }
          }
        }
        return retData.map((item) => Production.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load ongoing productions');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> markAsDone(int id, int actual_qty) async {
    try {
      final resData = await http.get(Uri.parse('$baseUrl/production/$id'));

      if (resData.statusCode == 200) {
        final List<dynamic> productionData = json.decode(resData.body);
        final resDesign = await http.get(Uri.parse('$baseUrl/design/${productionData[0]["design_id"]}'));
        if(resDesign.statusCode == 200){
          final List<dynamic> designData = json.decode(resDesign.body);
          final resProduct = await http.get(Uri.parse('$baseUrl/product/name/${designData[0]["name"]}'));
          final List<dynamic> productData = json.decode(resProduct.body);
          print('Response body: ${resProduct.body}');
          print('Data length: ${productData.length}');
          if(productData.length < 1){
            for(int i = 40; i < 46; i++){
              final url = Uri.parse("$baseUrl/product");
              final response = await http.post(
                url,
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({
                  "product_name": designData[0]["name"],
                  "product_description": designData[0]["description"],
                  "product_category": designData[0]["category"],
                  "product_size": i.toString(),
                  "product_gender": designData[0]["gender"],
                  "product_image": designData[0]["image"],
                  "stok_qty": int.parse(productionData[0]["production_size"]) == i ? actual_qty : 0,
                  "price": 0,
                }),
              );

              if (response.statusCode != 201) {
                print("Failed to add product at size $i: ${response.body}");
                continue;
              }
            }
          }
          else{
            for(int i = 0; i < productData.length; i++){
              if(productData[i]["product_size"] == productionData[0]["production_size"]){
                final url = Uri.parse("$baseUrl/product");
                final response = await http.put(
                  url,
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "product_id": productData[i]["product_id"],
                    "product_name": productData[i]["product_name"],
                    "product_description": productData[i]["product_description"],
                    "product_category": productData[i]["product_category"],
                    "product_size": productData[i]["product_size"],
                    "product_gender": productData[i]["product_gender"],
                    "product_image": productData[i]["product_image"],
                    "stok_qty": productData[i]["stok_qty"] + actual_qty,
                    "price": productData[i]["price"],
                  }),
                );

                if (response.statusCode != 200) {
                  throw Exception("Failed to add product");
                }
              }
            }
          }
          final url = Uri.parse("$baseUrl/production");
          final response = await http.put(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "id": id,
              "designId": productionData[0]["design_id"],
              "expectedQty": productionData[0]["expected_qty"],
              "actualQty": actual_qty,
              "status": "Done",
              "productionSize": productionData[0]["production_size"],
            }),
          );

          if (response.statusCode != 200) {
            throw Exception("Failed to update production");
          }
        }
      } else {
        throw Exception("Failed to mark production as done. Error: ${resData.body}");
      }
    } catch (error) {
      print("Error occurred while updating production: $error");
      rethrow;
    }
  }
}