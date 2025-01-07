import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controller/product_controller.dart';
import 'cart_screen.dart';

class OfflineShopScreen extends StatefulWidget {
  const OfflineShopScreen({Key? key}) : super(key: key);

  @override
  State<OfflineShopScreen> createState() => _OfflineShopScreenState();
}

class _OfflineShopScreenState extends State<OfflineShopScreen> {
  List<Product> _products = [];
  Map<int, int> _productQuantities = {};  // Variabel untuk menyimpan quantity produk berdasarkan indeks
  bool isLoading = true;
  final ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      List<Product> products = await productController.getAllProducts();
      setState(() {
        _products = products;
        isLoading = false;

        // Inisialisasi quantity produk dengan 0 untuk setiap produk yang ada
        for (int i = 0; i < _products.length; i++) {
          _productQuantities[i] = 0;  // Default quantity adalah 0
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      _productQuantities[index] = (_productQuantities[index]! + change).clamp(0, 100);  // Batasi quantity antara 0 dan 100
    });
  }

  void _goToCart() {
    // Filter produk berdasarkan quantity > 0 tanpa menyertakan null
    final cartItems = _products.where((product) {
      final index = _products.indexOf(product);
      return _productQuantities[index]! > 0; // Produk dengan quantity > 0
    }).toList(); // Menghasilkan List<Product> yang valid

    // Mengubah Map<int, int> menjadi Map<Product, int>
    final productQuantities = Map<Product, int>.fromIterable(cartItems,
        key: (product) => product,
        value: (product) {
          final index = _products.indexOf(product);
          return _productQuantities[index]!;  // Dapatkan kuantitas dari Map<int, int>
        });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems, productQuantities: productQuantities),
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
          final productQuantity = _productQuantities[index]!;  // Ambil quantity dari map
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(product.product_image!),
              title: Text(product.product_name!),
              subtitle: Text('\$${product.price?.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _updateQuantity(index, -1),
                  ),
                  Text('$productQuantity'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _updateQuantity(index, 1),
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
