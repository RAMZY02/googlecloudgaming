import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:steppa/product_development/models/shipment_detail.dart';
import 'package:steppa/product_development/ui/design_lists_screen.dart';
import 'package:steppa/product_development/ui/materials_storage_screen.dart';
import 'package:steppa/product_development/ui/pending_designs_screen.dart';
import 'package:steppa/product_development/ui/product_development_screen.dart';
import 'package:steppa/product_development/ui/production_progress_screen.dart';
import 'package:steppa/product_development/ui/production_screen.dart';
import 'package:steppa/product_development/ui/supplier_storage_screen.dart';
import '../controllers/shipment_controller.dart';
import '../models/shipment.dart';
import 'package:intl/intl.dart';

class AcceptShipmentScreen extends StatefulWidget {
  const AcceptShipmentScreen({Key? key}) : super(key: key);

  @override
  State<AcceptShipmentScreen> createState() => _AcceptShipmentScreenState();
}

class _AcceptShipmentScreenState extends State<AcceptShipmentScreen> {
  List<Shipment> _shipmentsData = [];
  List<ShipmentDetail> _shipmentsDetails = [];
  Map<String, int> materialsData = {};
  String? jwtToken;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> _getJwtToken() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getJwtToken(); // Ambil JWT Token secara asinkron
    final resData = await ShipmentService().fetchShipments(jwtToken!);
    if (jwtToken != null) {
      // Pastikan token tidak null sebelum dipakai
      setState(() {
        _shipmentsData = resData;
      });
    }
  }

  Future<void> _fetchShipmentDetails(String id) async {// Ambil JWT Token secara asinkron
    final resData = await ShipmentService().fetchShipmentDetails(id, jwtToken!);
    if (jwtToken != null) {
      // Pastikan token tidak null sebelum dipakai
      setState(() {
        _shipmentsDetails = resData;
      });
    }
  }

  void _cancelShipment(String id) {
    // Logic untuk membatalkan shipment
    print('Cancelled shipment with ID: ${id}');
    // Tambahkan logika lain seperti update status shipment di server
  }

  void _acceptShipment(String id) async {
    try {
      // Menampilkan pesan bahwa shipment diterima
      await ShipmentService().acceptShipment(id, jwtToken!);

      // Menampilkan SnackBar dengan pesan "Accept Success"
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shipment accepted successfully!')),
      );

      // Memperbarui daftar shipment setelah menerima shipment
      final resData = await ShipmentService().fetchShipments(jwtToken!);
      if (jwtToken != null) {
        // Pastikan token tidak null sebelum dipakai
        setState(() {
          _shipmentsData = resData;
        });
      }
    } catch (e) {
      print('Error: $e');
      // Menampilkan pesan jika terjadi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept shipment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment'),
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
          itemCount: _shipmentsData.length,
          itemBuilder: (context, index) {
            if (index >= _shipmentsData.length) return const SizedBox.shrink();
            final shipment = _shipmentsData[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                title: Text(shipment.shipment_id),
                subtitle: Text(shipment.shipment_status),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Menyembunyikan tombol check dan cross jika status bukan "Shipped"
                    if (shipment.shipment_status == "Shipped")
                      ...[
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _acceptShipment(shipment.shipment_id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _cancelShipment(shipment.shipment_id),
                        ),
                      ],
                    IconButton(
                      icon: const Icon(Icons.info, color: Colors.blue),
                      onPressed: () async {
                        await _fetchShipmentDetails(shipment.shipment_id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShipmentDetailScreen(
                              shipment: shipment,
                              shipmentdetails: _shipmentsDetails,
                              onAccept: () => _acceptShipment(shipment.shipment_id),
                              onDecline: () => _cancelShipment(shipment.shipment_id),
                            ),
                          ),
                        );
                      },
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

class ShipmentDetailScreen extends StatelessWidget {
  final Shipment shipment;
  final List<ShipmentDetail> shipmentdetails;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const ShipmentDetailScreen({
    Key? key,
    required this.shipment,
    required this.shipmentdetails,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    if (status == 'Shipped') {
      return Colors.yellow.shade900; // Kuning jika status 'Shipped'
    } else if (status == 'Delivered') {
      return Colors.green; // Hijau jika status 'Delivered'
    } else if (status == 'Failed') {
      return Colors.red; // Merah jika status 'Failed'
    }
    return Colors.black; // Warna default jika status lain
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shipment.shipment_id,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${shipment.shipment_status}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(shipment.shipment_status)
              ),
            ),
            const SizedBox(height: 24),
            Text('Shipment Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(shipment.shipment_date))}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Shipment Details:', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shipmentdetails.length,
              itemBuilder: (context, index) {
                final shipmentdetail = shipmentdetails[index];
                return Card(
                  child: ListTile(
                    title: Text(shipmentdetail.material_name),
                    subtitle: Text('Quantity: ${shipmentdetail.quantity}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat tombol penuh secara horizontal
              children: [
                if (shipment.shipment_status == "Shipped")
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
                      'Accept Shipment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // Tulisan tebal
                        color: Colors.white, // Tulisan putih
                      ),
                    ),
                  ),
                const SizedBox(height: 8), // Jarak antara tombol
                if (shipment.shipment_status == "Shipped")
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
                      'Cancel Shipment',
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