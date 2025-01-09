import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/history_item.dart';

class PurchaseHistoryController {
  final String baseUrl;

  PurchaseHistoryController({required this.baseUrl});

  Future<List<HistoryItem>> getPurchaseHistory(String customerId, String jwtToken) async {
    final url = Uri.parse('$baseUrl/api/store/customer/history/$customerId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => HistoryItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch purchase history');
    }
  }
}
