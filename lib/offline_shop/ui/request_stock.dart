import 'package:flutter/material.dart';
import '../controller/shipment_controller.dart';
import '../models/shipment.dart';
import 'history_screen.dart';
import 'offline_shop_screen.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  late Future<List<Shipment>> _shipmentsFuture;

  @override
  void initState() {
    super.initState();
    _shipmentsFuture = ShipmentService().fetchShipments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raw Materials Storage'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Offline Shop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Stock'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StocksScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cashier'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OfflineShopScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('History Penjualan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
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
      body: FutureBuilder<List<Shipment>>(
        future: _shipmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storage,
                    size: 100,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Stock Data Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'The raw materials storage is currently empty.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            final shipments = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Shipment ID')),
                  DataColumn(label: Text('Shipment Date')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Details')),
                ],
                rows: shipments.map((shipment) {
                  final details = shipment.details.map((detail) {
                    return 'Product: ${detail.productName}, Qty: ${detail.quantity}';
                  }).join('\n');

                  return DataRow(
                    cells: [
                      DataCell(Text(shipment.shipmentId.toString())),
                      DataCell(Text(shipment.shipmentDate)),
                      DataCell(Text(shipment.shipmentStatus)),
                      DataCell(Text(details)),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
