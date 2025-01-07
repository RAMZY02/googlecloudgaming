import 'package:flutter/material.dart';
import '../models/product.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
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
                  return ListTile(
                    leading: Image.network(product.product_image!),
                    title: Text(product.product_name!),
                    subtitle: Text('Quantity: $quantity'),
                    trailing: Text(
                      '\$${(product.price! * quantity).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
