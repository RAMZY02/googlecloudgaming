import 'package:flutter/material.dart';

class PendingDesignsScreen extends StatelessWidget {
  const PendingDesignsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> dummyImages = [
      'assets/nike.jpg', // URL gambar dummy
      'assets/reebok.jpg',
      'assets/adidas.jpeg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Designs'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dummyImages.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: Image.network(
                  dummyImages[index],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text('Design ${index + 1}'),
                subtitle: const Text('Waiting for approval'),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Approved Design ${index + 1}')),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
