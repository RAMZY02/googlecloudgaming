import 'package:flutter/material.dart';
import 'package:steppa/product_development/models/design.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';

class PendingDesignsScreen extends StatefulWidget {
  const PendingDesignsScreen({Key? key}) : super(key: key);

  @override
  State<PendingDesignsScreen> createState() => _PendingDesignsScreenState();
}

class _PendingDesignsScreenState extends State<PendingDesignsScreen> {
  List<Design> designs = [
    Design(
        name: "Nike Air Zoom",
        image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm3zenzeewmwTBRTG0R1kZwDEiT013hybhtg&s"),
    Design(
        name: "Adidas Ultra Boost",
        image: "https://static.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/p1/294/2024/08/27/Artikel-452-3055304001.jpg"),
    Design(
        name: "Puma RS-X",
        image: "https://m.media-amazon.com/images/I/71Vhhy6VmSL._AC_SL1500_.jpg"),
  ];

  void _acceptDesign(int index) {
    setState(() {
      designs.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Design accepted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          itemCount: designs.length,
          itemBuilder: (context, index) {
            final design = designs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: Image.network(
                  design.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(design.name),
                subtitle: const Text('Waiting for approval'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingDesignDetailScreen(
                        design: design,
                        onAccept: () => _acceptDesign(index),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class PendingDesignDetailScreen extends StatelessWidget {
  final Design design;
  final VoidCallback onAccept;

  const PendingDesignDetailScreen({
    Key? key,
    required this.design,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              design.image,
              height: 500,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              design.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onAccept();
                Navigator.pop(context);
              },
              child: const Text('Accept Design'),
            ),
          ],
        ),
      ),
    );
  }
}
