import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/design.dart';

class DesignController {
  final String baseUrl = "http://192.168.1.6:3000/api/rnd"; // Sesuaikan dengan backend Anda.

  //Insert Design
  Future<void> submitDesign(
      {required String name,
        required String image,
        required String category,
        required String gender,
        required String status,
        required String soleMaterialId,
        required String bodyMaterialId}) async {
    try {
      // Insert ke tabel DESIGN
      final designResponse = await http.post(
        Uri.parse("$baseUrl/design"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "image": image,
          "description": "Description placeholder", // Jika ada input deskripsi, sesuaikan
          "category": category,
          "gender": gender,
          "status": status,
        }),
      );

      if (designResponse.statusCode != 201) {
        throw Exception("Failed to insert design");
      }

      // Ambil ID design yang baru dibuat dari response backend
      final resDesign = await http.get(Uri.parse('$baseUrl/design'));
      final List<dynamic> allDesign = jsonDecode(resDesign.body);
      final designId = allDesign.length;

      // Insert ke tabel DESIGN_MATERIALS
      final materials = [
        {"materialId": "1", "qty": 2}, // Tali Sepatu
        {"materialId": "2", "qty": 1}, // Lem 200 gr
      ];

      // Jika soleMaterialId == bodyMaterialId, tambahkan 1 material dengan qty 4
      if (bodyMaterialId == soleMaterialId) {
        materials.add({"materialId": soleMaterialId, "qty": 4});
      }
      else {
        // Jika beda, tambahkan 2 material masing-masing qty 2
        materials.add({"materialId": soleMaterialId, "qty": 2});
        materials.add({"materialId": bodyMaterialId, "qty": 2});
      }

      for (var material in materials) {
        final materialResponse = await http.post(
          Uri.parse("$baseUrl/design-material"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "designId": designId,
            "materialId": material["materialId"],
            "qty": material["qty"],
          }),
        );

        if (materialResponse.statusCode != 201) {
          throw Exception("Failed to insert design material");
        }
      }
    } catch (e) {
      throw Exception("Error submitting design: $e");
    }
  }

  Future<List<Design>> fetchAllPendingDesigns() async {
    try {
      final retData = [];
      String soleMaterial;
      String bodyMaterial;
      final resDesign = await http.get(Uri.parse('$baseUrl/design'));

      if (resDesign.statusCode == 200) {
        final List<dynamic> allDesign = json.decode(resDesign.body);
        for (var design in allDesign) {
          if(design["status"] == "Pending"){
            int counter = 0;
            soleMaterial = "";
            bodyMaterial = "";
            final resMaterial = await http.get(Uri.parse("$baseUrl/design-material/design/${design["id"]}"));

            if (resMaterial.statusCode == 200) {
              final List<dynamic> matsData = json.decode(resMaterial.body);
              for (var material in matsData) {
                if(material["material_id"] != 1 && material["material_id"] != 2){
                  final resMatsName = await http.get(Uri.parse("$baseUrl/material/${material["material_id"]}"));
                  final List<dynamic> matsNameData = json.decode(resMatsName.body);
                  if(material.length < 4){
                    soleMaterial = matsNameData[0]["name"];
                    bodyMaterial = matsNameData[0]["name"];
                  }
                  else{
                    if(counter == 0){
                      soleMaterial = matsNameData[0]["name"];
                    }
                    else{
                      bodyMaterial = matsNameData[0]["name"];
                    }
                  }
                  matsNameData.clear();
                }
                counter++;
              }
              retData.add({"id": design["id"], "name":design["name"], "image":design["image"], "description":design["description"], "category":design["category"], "gender":design["gender"], "soleMaterial":soleMaterial, "bodyMaterial":bodyMaterial});
            }
          }
        }
        return retData.map((item) => Design.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load pending designs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> softDeleteDesign(int id) async {
    try {
      final url = Uri.parse("$baseUrl/design-material-by-designId");
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        print("Design marked as deleted successfully.");

        final url2 = Uri.parse("$baseUrl/design");
        final response2 = await http.delete(
          url2,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"id": id}),
        );

        if (response2.statusCode == 200) {
          print("Design marked as deleted successfully.");
        } else {
          throw Exception("Failed to mark design as deleted. Error: ${response.body}");
        }
      } else {
        throw Exception("Failed to mark design as deleted. Error: ${response.body}");
      }
    } catch (error) {
      print("Error occurred while soft deleting design: $error");
      rethrow;
    }
  }

  Future<void> acceptDesign(int id) async {
    try {
      final resData = await http.get(Uri.parse('$baseUrl/design/$id'));
      final List<dynamic> designData = json.decode(resData.body);

      if (resData.statusCode == 200) {
        final url2 = Uri.parse("$baseUrl/design");
        final response = await http.put(
          url2,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "id": designData[0]["id"],
            "name": designData[0]["name"],
            "image": designData[0]["image"],
            "description": designData[0]["description"],
            "category": designData[0]["category"],
            "gender": designData[0]["gender"],
            "status": "Accepted",
          }),
        );

        if (response.statusCode != 200) {
          throw Exception("Failed to update design status");
        }
      } else {
        throw Exception("Failed to mark design as accepted. Error: ${resData.body}");
      }
    } catch (error) {
      print("Error occurred while accepting design: $error");
      rethrow;
    }
  }

  Future<List<Design>> fetchAllAcceptedDesigns() async {
    try {
      final retData = [];
      String soleMaterial;
      String bodyMaterial;
      final resDesign = await http.get(Uri.parse('$baseUrl/design'));

      if (resDesign.statusCode == 200) {
        final List<dynamic> allDesign = json.decode(resDesign.body);
        for (var design in allDesign) {
          if(design["status"] == "Accepted"){
            int counter = 0;
            soleMaterial = "";
            bodyMaterial = "";
            final resMaterial = await http.get(Uri.parse("$baseUrl/design-material/design/${design["id"]}"));

            if (resMaterial.statusCode == 200) {
              final List<dynamic> matsData = json.decode(resMaterial.body);
              for (var material in matsData) {
                if(material["material_id"] != 1 && material["material_id"] != 2){
                  final resMatsName = await http.get(Uri.parse("$baseUrl/material/${material["material_id"]}"));
                  final List<dynamic> matsNameData = json.decode(resMatsName.body);
                  if(material.length < 4){
                    soleMaterial = matsNameData[0]["name"];
                    bodyMaterial = matsNameData[0]["name"];
                  }
                  else{
                    if(counter == 0){
                      soleMaterial = matsNameData[0]["name"];
                    }
                    else{
                      bodyMaterial = matsNameData[0]["name"];
                    }
                  }
                  matsNameData.clear();
                }
                counter++;
              }
              retData.add({"id": design["id"], "name":design["name"], "image":design["image"], "description":design["description"], "category":design["category"], "gender":design["gender"], "soleMaterial":soleMaterial, "bodyMaterial":bodyMaterial});
            }
          }
        }
        return retData.map((item) => Design.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load accepted designs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Design>> fetchSelectedDesigns(int id) async {
    try {
      final retData = [];
      String soleMaterial;
      String bodyMaterial;
      final resDesign = await http.get(Uri.parse('$baseUrl/design/$id'));

      if (resDesign.statusCode == 200) {
        final List<dynamic> allDesign = json.decode(resDesign.body);
        for (var design in allDesign) {
          if(design["status"] == "Accepted"){
            int counter = 0;
            soleMaterial = "";
            bodyMaterial = "";
            final resMaterial = await http.get(Uri.parse("$baseUrl/design-material/design/${design["id"]}"));

            if (resMaterial.statusCode == 200) {
              final List<dynamic> matsData = json.decode(resMaterial.body);
              for (var material in matsData) {
                if(material["material_id"] != 1 && material["material_id"] != 2){
                  final resMatsName = await http.get(Uri.parse("$baseUrl/material/${material["material_id"]}"));
                  final List<dynamic> matsNameData = json.decode(resMatsName.body);
                  if(material.length < 4){
                    soleMaterial = matsNameData[0]["name"];
                    bodyMaterial = matsNameData[0]["name"];
                  }
                  else{
                    if(counter == 0){
                      soleMaterial = matsNameData[0]["name"];
                    }
                    else{
                      bodyMaterial = matsNameData[0]["name"];
                    }
                  }
                  matsNameData.clear();
                }
                counter++;
              }
              retData.add({"id": design["id"], "name":design["name"], "image":design["image"], "description":design["description"], "category":design["category"], "gender":design["gender"], "soleMaterial":soleMaterial, "bodyMaterial":bodyMaterial});
            }
          }
        }
        return retData.map((item) => Design.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load selected designs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
