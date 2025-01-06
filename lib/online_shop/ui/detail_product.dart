import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product_card.dart';
import '../controller/product_controller.dart';
import 'navbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({Key? key}) : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  bool isSearching = false;
  String? searchQuery;
  String? selectedSize;
  int? stok;
  int quantity = 0;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final List<String> size = ['40', '41', '42', '43', '44', '45'];
  final ProductController productController = ProductController();

  void initState() {
    super.initState();
    print('asda0');
    _getJwtToken();
  }

  void _navigateToSearch() {
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/searchPage',
        arguments: searchQuery,
      );
    }
  }

  Future<void> getProductStock(String productName, String productSize) async {
    final productStock = await productController.getProductStock(productName, productSize);
    setState(() {
      stok = productStock as int?;
    });
  }

  Future<void> _getJwtToken() async {
    try {
      String? jwtToken = await _secureStorage.read(key: 'jwt_token');
      String? customerId = await _secureStorage.read(key: 'customer_id');

      if (jwtToken != null) {
        print("JWT Token: $jwtToken"); // Print JWT token
      } else {
        print("No JWT token found.");
      }

      if (customerId != null) {
        print("Customer ID: $customerId"); // Print Customer ID
      } else {
        print("No Customer ID found.");
      }
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product_Cart product = ModalRoute.of(context)!.settings.arguments as Product_Cart;

    return Scaffold(
      appBar: Navbar(
        isSearching: isSearching,
        onSearchChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        onSearchSubmitted: (value) {
          setState(() {
            searchQuery = value;
          });
          _navigateToSearch();
        },
        onToggleSearch: () {
          setState(() {
            isSearching = !isSearching;
          });
        },
        onCartPressed: () {
          Navigator.pushNamed(context, '/cartPage');
        },
        onHistoryPressed: () {
          Navigator.pushNamed(context, '/orderHistoryPage');
        },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Image.asset(
                        product.product_image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 104),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Bagian informasi produk
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama produk
                        Text(
                          product.product_name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Kategori produk
                        Text(
                          product.product_category,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        // Deskripsi produk
                        Text(
                          product.product_description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Pilih ukuran
                        const Text(
                          'Select Size',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: size.map((currentSize) {
                            final isSelected = selectedSize == currentSize; // Cek apakah ukuran sedang dipilih
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = currentSize;
                                  stok = null; // Reset stok
                                  quantity = 0; // Reset jumlah barang
                                });
                                getProductStock(product.product_name, currentSize);
                              },
                              child: Container(
                                width: 50, // Lebar tombol persegi
                                height: 50, // Tinggi tombol persegi
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blueAccent : Colors.white, // Warna biru jika dipilih
                                  border: Border.all(
                                    color: isSelected ? Colors.blueAccent : Colors.black, // Border warna biru
                                    width: isSelected ? 2 : 1, // Ketebalan border
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Sudut melengkung
                                ),
                                child: Text(
                                  currentSize,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected ? Colors.white : Colors.black, // Warna teks
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Pilih jumlah barang dan harga barang
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: (quantity > 0)
                                      ? () {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                      : null,
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: (stok != null && quantity < stok!)
                                      ? () {
                                    setState(() {
                                      quantity++;
                                    });
                                  }
                                      : null,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            Text(
                              'Rp ${product.price}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Informasi stok
                        if (stok != null)
                          Text(
                            'Stok: $stok',
                            style: const TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        const SizedBox(height: 24),
                        // Tombol tambah ke keranjang
                        ElevatedButton(
                          onPressed: () {
                            print('Add to Cart: ${product.product_name}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Add to Bag',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
