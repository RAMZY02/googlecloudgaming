import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:steppa/supplier/controllers/supplier_controller.dart';
import 'package:steppa/supplier/ui/add_shipment_screen.dart';
import 'package:steppa/supplier/ui/supplier_screen.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({Key? key}) : super(key: key);

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final SupplierController _supplierController = SupplierController();
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _materialNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? jwtToken;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getJwtToken();
  }

  Future<void> _getJwtToken() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Supplier'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _supplierNameController,
                decoration: const InputDecoration(
                  labelText: 'Supplier Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _materialNameController,
                decoration: const InputDecoration(
                  labelText: 'Material Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _contactInfoController,
                decoration: const InputDecoration(
                  labelText: 'Contact Info',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final supplierName = _supplierNameController.text;
                  final location = _locationController.text;
                  final contact_info = _contactInfoController.text;
                  final material_name = _materialNameController.text;

                  if (supplierName.isNotEmpty &&
                      material_name.isNotEmpty &&
                      location.isNotEmpty &&
                      contact_info.isNotEmpty) {
                    try {
                      if(jwtToken != null) {
                        await _supplierController.addSupplier(
                          supplierName,
                          material_name,
                          location,
                          contact_info,
                          jwtToken!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              'Supplier "$supplierName" added successfully!')),
                        );
                        _supplierNameController.clear();
                        _materialNameController.clear();
                        _locationController.clear();
                        _contactInfoController.clear();
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('There is no JWT token')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add supplier: $e')),
                      );
                        print('Failed to add supplier: $e');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please complete all fields!')),
                    );
                  }
                },
                child: const Text('Add New Supplier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
