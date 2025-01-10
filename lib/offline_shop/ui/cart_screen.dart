import 'package:flutter/material.dart';
import '../models/product.dart';
import 'history_screen.dart';
import 'request_stock.dart';
import 'invoice_screen.dart';
import 'offline_shop_screen.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cartItems;
  final Map<Product, int> productQuantities;  // Menyimpan kuantitas produk

  const CartScreen({
    Key? key,
    required this.cartItems,
    required this.productQuantities,
  }) : super(key: key);

  void _confirmPurchase(BuildContext context) {
    // Tidak perlu mendeklarasikan productQuantities baru, karena productQuantities sudah diteruskan ke halaman CartScreen
    final productQuantities = this.productQuantities;  // Menggunakan Map yang sudah ada

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceScreen(cartItems: cartItems, productQuantities: productQuantities),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    // Menghitung total harga dari semua produk dalam cart
    double totalAmount = 0;
    cartItems.forEach((product) {
      final quantity = productQuantities[product] ?? 0;
      totalAmount += product.price! * quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                final quantity = productQuantities[product]!;  // Ambil quantity berdasarkan product
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(product.product_image!),
                    title: Text(product.product_name!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size: ${product.product_size}'),  // Menampilkan ukuran produk
                        Text('Price: \Rp. ${product.price?.toStringAsFixed(2)}'),  // Menampilkan harga produk
                        Text('Quantity: $quantity'),  // Menampilkan kuantitas produk
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '\Rp. ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          // Tombol "Purchase" untuk konfirmasi pembelian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _confirmPurchase(context),
              child: const Text('Confirm Purchase'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
