import 'package:flutter/material.dart';
import 'package:steppa/offline_shop/models/transaction.dart';
import '../models/product.dart';
import 'factory_stock.dart';
import 'history_screen.dart';
import 'request_stock.dart';
import 'offline_shop_screen.dart';
import '../controller/transaction_controller.dart';  // Import the Transaction Service

class InvoiceScreen extends StatelessWidget {
  final List<Product> cartItems;
  final Map<Product, int> productQuantities;  // Map<Product, int> untuk kuantitas produk

  const InvoiceScreen({
    Key? key,
    required this.cartItems,
    required this.productQuantities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menghitung total harga dari semua produk dalam invoice
    double totalAmount = 0;
    cartItems.forEach((product) {
      int quantity = productQuantities[product] ?? 0;  // Ambil kuantitas berdasarkan produk
      totalAmount += product.price! * quantity;
    });

    void _handleOfflineTransaction() async {
      String saleChannel = "Offline";
      List<String> products = cartItems.map((product) {
        if (product.product_id == null) {
          throw Exception('Missing product ID for product: ${product.product_name}');
        }
        return product.product_id!;
      }).toList();

      List<int> quantities = cartItems.map((product) {
        final quantity = productQuantities[product];
        if (quantity == null) {
          throw Exception('Missing quantity for product: ${product.product_name}');
        }
        return quantity;
      }).toList();

      List<int> prices = cartItems.map((product) {
        if (product.price == null) {
          throw Exception('Missing price for product: ${product.product_name}');
        }
        return product.price!;
      }).toList();

      TransactionService transactionService = TransactionService();
      try {
        Transaction result = await transactionService.offlineTransactionNonMember(
          saleChannel,
          products,
          quantities,
          prices,
        );

      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction completed!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OfflineShopScreen(),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
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
                    builder: (context) => const FactoryStock(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  final quantity = productQuantities[product]!;  // Ambil kuantitas berdasarkan produk
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(product.product_image!),
                      title: Text(product.product_name!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Size: ${product.product_size}'),  // Menampilkan ukuran produk
                          Text('Price: \Rp. ${product.price?.toStringAsFixed(2)}'),  // Menampilkan harga produk
                          Text('Quantity: $quantity'),  // Menampilkan kuantitas produk
                          Text('Id: ${product.product_id}'),
                        ],
                      ),
                      trailing: Text(
                        '\Rp. ${(product.price! * quantity).toStringAsFixed(2)}', // Total harga produk * kuantitas
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total: \Rp. ${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleOfflineTransaction,  // Call the function to handle the offline transaction
              child: const Text('Print Invoice & Complete Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}