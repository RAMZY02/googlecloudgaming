import 'package:flutter/material.dart';
import 'package:steppa/product_development/controllers/design_controller.dart';
import 'package:steppa/product_development/models/design.dart';
import 'package:steppa/product_development/ui/design_lists_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';

class PendingDesignsScreen extends StatefulWidget {
  const PendingDesignsScreen({Key? key}) : super(key: key);

  @override
  State<PendingDesignsScreen> createState() => _PendingDesignsScreenState();
}

class _PendingDesignsScreenState extends State<PendingDesignsScreen> {
  List<Design> pendingdesigns = [];
  final DesignController _designController = DesignController();

  @override
  void initState() {
    super.initState();
    _fetchAllPendingDesigns();
  }

  Future<void> _fetchAllPendingDesigns() async {
    try {
      final resData = await _designController.fetchAllPendingDesigns();
      setState(() {
        pendingdesigns = resData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch pending designs: $e')),
      );
    }
  }

  Future<void> _approveDesigns(int id) async {
    try {
      await _designController.acceptDesign(id);

      // Ambil ulang data terbaru
      final resData = await _designController.fetchAllPendingDesigns();
      setState(() {
        pendingdesigns = resData;
      });

    } catch (e) {
      // Tampilkan error dengan tepat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve design: $e')),
      );
    }
  }


  Future<void> _deleteDesigns(int id) async {
    try {
      await _designController.softDeleteDesign(id);

      // Ambil ulang data terbaru
      final resData = await _designController.fetchAllPendingDesigns();
      setState(() {
        pendingdesigns = resData;
      });
    } catch (e) {
      // Tampilkan error dengan tepat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve design: $e')),
      );
    }
  }

  void _acceptDesign(int id) async {
    await _approveDesigns(id); // Tunggu hingga selesai
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Design accepted!')),
    // );
  }

  void _declineDesign(int id) async{
    await _deleteDesigns(id);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Design declined!')),
    // );
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
          itemCount: pendingdesigns.length,
          itemBuilder: (context, index) {
            if (index >= pendingdesigns.length) return const SizedBox.shrink();
            final design = pendingdesigns[index];
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
                subtitle: Text('Waiting for approval'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PendingDesignDetailScreen(
                              design: design,
                              onAccept: () => _acceptDesign(design.id),
                              onDecline: () => _declineDesign(design.id),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _acceptDesign(design.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _declineDesign(design.id),
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

class PendingDesignDetailScreen extends StatelessWidget {
  final Design design;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const PendingDesignDetailScreen({
    Key? key,
    required this.design,
    required this.onAccept,
    required this.onDecline,
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
                    backgroundColor: Colors.green, // Latar belakang hijau
                    padding: const EdgeInsets.symmetric(vertical: 16), // Ukuran tombol
                  ),
                  onPressed: () {
                    onAccept();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Accept Design',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Tulisan tebal
                      color: Colors.white, // Tulisan putih
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Jarak antara tombol
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Latar belakang merah
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    onDecline();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Decline Design',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
