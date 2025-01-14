import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:steppa/supplier/models/shipment_detail.dart';
import '../models/shipment.dart';

class ShipmentService {
  final String baseUrl = "http://192.168.1.6:3000/api/pengepul"; // Sesuaikan URL backend Anda

  // final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6IkNVUzAwMDQiLCJpYXQiOjE3MzY1MDc2NjUsImV4cCI6MTczNjUxMTI2NX0.Fe9bt_ImS01-B-7y3w6MGs6vkSOAm8d8pYvHuz9qZLs';

  Future<List<Shipment>> fetchShipments(String token) async {
    final url = Uri.parse("$baseUrl/material-shipments");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include the auth token here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Shipment.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch shipments: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching shipments: $e");
    }
  }

  Future<List<ShipmentDetail>> fetchShipmentDetails(String id, String token) async {
    final url = Uri.parse("$baseUrl/material-shipment-detail/shipment/${id}");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include the auth token here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ShipmentDetail.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch shipments: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching shipments: $e");
    }
  }

  Future<void> acceptShipment(String shipmentId, String token) async {
    final url = Uri.parse('$baseUrl/accept-shipment');
    try {
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token", // Pastikan token yang benar
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "shipmentId": shipmentId,
        }),
      );

      if (response.statusCode == 200) {
        print('Shipment accepted successfully');
      } else {
        throw Exception('Failed to accept shipment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> submitShipments(List<Map<String, dynamic>> materialsToSubmit, String token) async {
    final url = Uri.parse('$baseUrl/material-shipment');
    try {
      // Pisahkan material_id dan quantity dari materialsToSubmit
      final materials = materialsToSubmit.map((item) => item['material_id']).toList();
      final quantities = materialsToSubmit.map((item) => item['quantity']).toList();
      print(materialsToSubmit);
      print(materials);
      print(quantities);
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "materials": materials,
          "quantities": quantities,// Kirim data material dan quantity
        }),
      );

      if (response.statusCode == 201) {
        print('Shipment accepted successfully');
      } else {
        throw Exception('Failed to accept shipment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}
