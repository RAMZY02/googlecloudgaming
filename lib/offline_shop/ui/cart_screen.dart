import 'package:flutter/material.dart';
import '../models/product.dart';
import 'invoice_screen.dart';

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
                    subtitle: Text('Quantity: $quantity'),
                    trailing: Text(
                      '\$${(product.price! * quantity).toStringAsFixed(2)}',
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
                  '\$${totalAmount.toStringAsFixed(2)}',
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
