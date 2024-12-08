import 'package:flutter/material.dart';

class SellingReportsScreen extends StatelessWidget {
  const SellingReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selling Reports'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // Ganti dengan jumlah data laporan sebenarnya
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
                    'Selling Report #${index + 1}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Date: ${DateTime.now().subtract(Duration(days: index * 7)).toLocal()}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Items Sold: ${50 + (index * 5)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Total Revenue: \$${(1000 + (index * 150)).toStringAsFixed(2)}',
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
                          content: Text('Viewing details for Selling Report #${index + 1}'),
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
