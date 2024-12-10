import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'customer.dart';

class OracleDataScreen extends StatefulWidget {
  @override
  _OracleDataScreenState createState() => _OracleDataScreenState();
}

class _OracleDataScreenState extends State<OracleDataScreen> {
  late Future<List<Customer>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchCustomers();
  }

  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse('http://192.168.18.5:3000/oracle-data'));

    if (response.statusCode == 200) {
      try {
        // Decode JSON response
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Map response to Customer instances
        return jsonResponse
            .map((item) => Customer.fromList(item as List<dynamic>))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse data: $e');
      }
    } else {
      throw Exception('Failed to load data with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Oracle Data')),
      body: FutureBuilder<List<Customer>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final customer = data[index];
                return ListTile(
                  title: Text(customer.name),
                  subtitle: Text('${customer.address}, ${customer.city}'),
                  trailing: Text(customer.phone),
                );
              },
            );
          }
        },
      ),
    );
  }
}
