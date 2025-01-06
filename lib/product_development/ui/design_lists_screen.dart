import 'package:flutter/material.dart';
import 'package:steppa/product_development/models/design.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';

class DesignListsScreen extends StatefulWidget {
  const DesignListsScreen({Key? key}) : super(key: key);

  @override
  State<DesignListsScreen> createState() => _DesignListsScreenState();
}

class _DesignListsScreenState extends State<DesignListsScreen> {
  final List<Design> designLists = [
    Design(
        name: "Nike Air Zoom",
        image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm3zenzeewmwTBRTG0R1kZwDEiT013hybhtg&s",
        category: "Running",
        gender: "Male",
        price: "Rp 1,500,000",
        soleMaterial: "Karet",
        bodyMaterial: "Kain"),
    Design(
        name: "Adidas Ultra Boost",
        image: "https://static.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/p1/294/2024/08/27/Artikel-452-3055304001.jpg",
        category: "Casual",
        gender: "Female",
        price: "Rp 2,000,000",
        soleMaterial: "Foam",
        bodyMaterial: "Kulit"),
    Design(
        name: "Puma RS-X",
        image: "https://m.media-amazon.com/images/I/71Vhhy6VmSL._AC_SL1500_.jpg",
        category: "Training",
        gender: "Male",
        price: "Rp 1,800,000",
        soleMaterial: "Plastik",
        bodyMaterial: "Kulit Sintesis"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Lists'),
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
                'Product Research & Development',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Design Workspace'),
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
              leading: const Icon(Icons.check),
              title: const Text('Design Lists'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DesignListsScreen(),
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
          itemCount: designLists.length,
          itemBuilder: (context, index) {
            final design = designLists[index];
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
                subtitle: Text(design.price),
                trailing: IconButton(
                  icon: const Icon(Icons.info, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DesignListsDetailScreen(design: design),
                      ),
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

class DesignListsDetailScreen extends StatelessWidget {
  final Design design;

  const DesignListsDetailScreen({Key? key, required this.design}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              design.image,
              height: 750,
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
            const SizedBox(height: 8),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text('Category: ${design.category}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Gender: ${design.gender}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Price: ${design.price}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Sole Material: ${design.soleMaterial}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Body Material: ${design.bodyMaterial}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
