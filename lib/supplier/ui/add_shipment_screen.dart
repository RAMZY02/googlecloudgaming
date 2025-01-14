import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:steppa/supplier/controllers/raw_controller.dart';
import 'package:steppa/supplier/controllers/shipment_controller.dart';
import 'package:steppa/supplier/models/raw.dart';
import 'package:steppa/supplier/ui/add_supplier_screen.dart';
import 'package:steppa/supplier/ui/supplier_screen.dart';

class AddShipmentScreen extends StatefulWidget {
  const AddShipmentScreen({Key? key}) : super(key: key);

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen> {
  List<Raw> listMaterial = [];
  final ShipmentService _shipmentController = ShipmentService();
  final RawController _rawController = RawController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? jwtToken;
  final Map<int, TextEditingController> quantityControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getJwtToken();
    await _fetchAllMaterials();
  }

  Future<void> _getJwtToken() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
    }
  }

  Future<void> _fetchAllMaterials() async {
    try {
      final resData = await _rawController.fetchAllRaws(jwtToken!);
      setState(() {
        listMaterial = resData;
        // Initialize controllers for each material
        for (int i = 0; i < listMaterial.length; i++) {
          quantityControllers[i] = TextEditingController(text: '0');
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch raw materials: $e')),
      );
    }
  }

  Future<void> _submitShipments() async {
    if (jwtToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('JWT token is missing.')),
      );
      return;
    }

    final List<Map<String, dynamic>> materialsToSubmit = [];

    for (int i = 0; i < listMaterial.length; i++) {
      final quantity = int.tryParse(quantityControllers[i]?.text ?? '0') ?? 0;
      if (quantity > 0) {
        materialsToSubmit.add({
          'material_id': listMaterial[i].material_id,
          'quantity': quantity,
        });
      }
    }

    if (materialsToSubmit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No materials with valid quantities.')),
      );
      return;
    }

    try {
      await _shipmentController.submitShipments(materialsToSubmit, jwtToken!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shipments submitted successfully.')),
      );
      // Reset quantities
      for (var controller in quantityControllers.values) {
        controller.text = '0';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit shipments: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Shipments'),
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
                'Supplier Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Add New Supplier'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddSupplierScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Supplier Lists'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupplierScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('New Shipments'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddShipmentScreen(),
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
            // Tambahkan item lainnya jika diperlukan
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: listMaterial.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: listMaterial.length,
          itemBuilder: (context, index) {
            final material = listMaterial[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        material.material_name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: quantityControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitShipments,
        child: const Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
