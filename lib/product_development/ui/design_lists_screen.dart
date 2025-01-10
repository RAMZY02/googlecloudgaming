import 'package:flutter/material.dart';
import 'package:steppa/product_development/controllers/design_controller.dart';
import 'package:steppa/product_development/models/design.dart';
import 'package:steppa/product_development/ui/materials_storage_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/production_progress_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';

class DesignListsScreen extends StatefulWidget {
  const DesignListsScreen({Key? key}) : super(key: key);

  @override
  State<DesignListsScreen> createState() => _DesignListsScreenState();
}

class _DesignListsScreenState extends State<DesignListsScreen> {
  List<Design> designlists = [];
  final DesignController _designController = DesignController();

  @override
  void initState() {
    super.initState();
    _fetchAllAcceptedDesigns();
  }

  Future<void> _fetchAllAcceptedDesigns() async {
    try {
      final resData = await _designController.fetchAllAcceptedDesigns();
      setState(() {
        designlists = resData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch accepted designs: $e')),
      );
    }
  }

  Future<void> _deleteDesigns(int id) async {
    try {
      await _designController.softDeleteDesign(id);
      final resData = await _designController.fetchAllAcceptedDesigns();
      setState(() {
        designlists = resData; // Update daftar desain setelah soft delete
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch pending designs: $e')),
      );
    }
  }

  void _throwDesign(int id) {
    _deleteDesigns(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Design declined!')),
    );
  }

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
              title: const Text('Production Planner'),
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
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text('Production Progress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductionProgressScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Raw Materials Storage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaterialsStorageScreen(),
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
                Navigator.pushNamed(context, '/landing');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: designlists.length,
          itemBuilder: (context, index) {
            final design = designlists[index];
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
                subtitle: Text(
                  design.description,
                  maxLines: 1, // Membatasi teks hanya pada 1 baris
                  overflow: TextOverflow.ellipsis, // Menampilkan ... jika teks terlalu panjang
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DesignListsDetailScreen(
                              design: design,
                              onDelete: () => _throwDesign(design.id),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _throwDesign(design.id),
                    ),
                  ],
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
  final VoidCallback onDelete;

  const DesignListsDetailScreen({
    Key? key,
    required this.design,
    required this.onDelete,
  }) : super(key: key);

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
            Text(
              '${design.description}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text('Category: ${design.category}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Gender: ${design.gender}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Sole Material: ${design.soleMaterial}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Body Material: ${design.bodyMaterial}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat tombol penuh secara horizontal
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Latar belakang hijau
                    padding: const EdgeInsets.symmetric(vertical: 16), // Ukuran tombol
                  ),
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete Design',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Tulisan tebal
                      color: Colors.white, // Tulisan putih
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
