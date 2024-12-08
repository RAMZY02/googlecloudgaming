import 'package:flutter/material.dart';

class ProductionReportsScreen extends StatelessWidget {
  const ProductionReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Reports'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // Ganti dengan jumlah data laporan yang sebenarnya
        itemBuilder: (context, index) {
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report #${index + 1}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Production Date: ${DateTime.now().subtract(Duration(days: index * 7)).toLocal()}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Units Produced: ${100 + (index * 10)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing details for Report #${index + 1}'),
                        ),
                      );
                    },
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
