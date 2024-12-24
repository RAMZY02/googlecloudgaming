import 'package:flutter/material.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class OfflineShopScreen extends StatefulWidget {
  const OfflineShopScreen({Key? key}) : super(key: key);

  @override
  State<OfflineShopScreen> createState() => _OfflineShopScreenState();
}

class _OfflineShopScreenState extends State<OfflineShopScreen> {
  final List<Product> _products = [
    Product(id: '1', name: 'Running Shoes', imageUrl: 'https://via.placeholder.com/150', price: 50.0),
    Product(id: '2', name: 'Casual Shoes', imageUrl: 'https://via.placeholder.com/150', price: 40.0),
    Product(id: '3', name: 'Sports Shoes', imageUrl: 'https://via.placeholder.com/150', price: 60.0),
  ];

  void _updateQuantity(Product product, int change) {
    setState(() {
      product.quantity = (product.quantity + change).clamp(0, 100);
    });
  }

  void _goToCart() {
    final cartItems = _products.where((product) => product.quantity > 0).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Shop'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(product.imageUrl),
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _updateQuantity(product, -1),
                  ),
                  Text('${product.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _updateQuantity(product, 1),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCart,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
