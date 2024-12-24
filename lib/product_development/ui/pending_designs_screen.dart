import 'package:flutter/material.dart';
import 'production_screen.dart';
import 'product_development_screen.dart';


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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Product Development',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Design Upload'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductDevelopmentScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending),
              title: const Text('Pending Designs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PendingDesignsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.factory),
              title: const Text('Production Planning'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductionScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Back To Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
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
