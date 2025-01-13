import 'package:flutter/material.dart';
import 'package:steppa/product_development/ui/accept_shipment.dart';
import 'package:steppa/product_development/ui/design_lists_screen.dart';
import 'package:steppa/product_development/ui/materials_storage_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/production_progress_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';
import '../models/material.dart';
import 'package:steppa/product_development/controllers/material_controller.dart';

class SupplierStorageScreen extends StatefulWidget {
  const SupplierStorageScreen({Key? key}) : super(key: key);

  @override
  State<SupplierStorageScreen> createState() => _SupplierStorageScreenState();
}

class _SupplierStorageScreenState extends State<SupplierStorageScreen> {
  List<MaterialModel> rawmats = [];
  final MaterialController _materialController = MaterialController();

  @override
  void initState() {
    super.initState();
    _fetchAllMaterials();
  }

  Future<void> _fetchAllMaterials() async {
    try {
      final resData = await _materialController.fetchSupplierMaterials();
      setState(() {
        rawmats = resData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch raw materials: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Materials Storage'),
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
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Supplier Materials Storage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupplierStorageScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Shipments'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AcceptShipmentScreen(),
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
          itemCount: rawmats.length,
          itemBuilder: (context, index) {
            if (index >= rawmats.length) return const SizedBox.shrink();
            final material = rawmats[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                title: Text(material.material_name),
                subtitle: Text('Stock: ${material.stock_quantity}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
