import 'package:flutter/material.dart';
import '../models/factory_stock.dart'; // Ganti dengan model yang sesuai, misalnya ProductModel
import '../controller/factory_controller.dart'; // Import FactoryController
import 'history_screen.dart';
import 'request_stock.dart';
import 'invoice_screen.dart';
import 'offline_shop_screen.dart';

class FactoryStockScreen extends StatefulWidget {
  const FactoryStockScreen({Key? key}) : super(key: key);

  @override
  _FactoryStockScreenState createState() => _FactoryStockScreenState();
}

class _FactoryStockScreenState extends State<FactoryStockScreen> {
  final FactoryController factoryController = FactoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factory Stock'),
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
                'Offline Shop',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delivery_dining),
              title: const Text('Shipment'),
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
            ListTile(
              leading: const Icon(Icons.factory),
              title: const Text('Factory Stock'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FactoryStockScreen(),
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
      body: FutureBuilder<List<FactoryStock>>(
        future: factoryController.fetchProducts(), // Memanggil fetchProducts dari FactoryController
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            List<FactoryStock> products = snapshot.data!; // Data produk yang diterima
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Image.network(product.productImage),
                    title: Text(product.productName),
                    subtitle: Text(product.productDescription),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Stock: ${product.stokQty}'),
                        Text('Price: \$${product.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
