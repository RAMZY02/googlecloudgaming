import 'dart:math';
import 'package:flutter/material.dart';
import '../models/add_to_cart.dart';
import '../models/product_card.dart';
import '../controller/product_controller.dart';
import '../controller/cart_controller.dart'; // Import untuk CartController
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
  String? productId;  // Menambahkan variabel untuk productId
  int quantity = 0;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final List<String> size = ['40', '41', '42', '43', '44', '45'];
  final ProductController productController = ProductController();
  final CartController cartController = CartController();

  String? jwtToken;
  String? customerId;

  @override
  void initState() {
    super.initState();
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

  // Mengubah fungsi getProductStock untuk menerima stok dan product_id

  Future<void> _getJwtToken() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
      customerId = await _secureStorage.read(key: 'customer_id');

      if (jwtToken != null) {
        print("JWT Token: $jwtToken");
      } else {
        print("No JWT token found.");
      }

      if (customerId != null) {
        print("Customer ID: $customerId");
      } else {
        print("No Customer ID found.");
      }
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
    }
  }

  Future<void> getProductStock(String productName, String productSize) async {
    try {
      final productStock = await productController.getProductStock(productName, productSize);
      setState(() {
        stok = productStock['stok_qty'];  // Mengambil stok sebagai string
        productId = productStock['product_id'].toString();  // Menyimpan product_id
      });
      print(productStock);
      print(stok);
      print(productId);
    } catch (e) {
      print("Error fetching product stock: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch product stock.")),
      );
    }
  }

  Future<void> _addToCart(Product_Cart product) async {
    if (customerId == null || jwtToken == null || productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer ID, JWT Token, or Product ID not found.")),
      );
      return;
    }

    try {
      final carts = await cartController.getCartsByCustomerId(
        customerId!,
        jwtToken!,
      );
      print(jwtToken);
      print(customerId);
      if (carts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No carts found for customer.")),
        );
        return;
      }

      final cartId = carts.first.cartId;
      print(cartId);
      final success = await cartController.addToCart(
        cartItem(
          cartId: cartId,
          productId: productId!,  // Menggunakan productId yang baru diperoleh
          quantity: quantity,
          price: product.price!,
        ),
        jwtToken!,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item added to cart successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add item to cart.")),
        );
      }
    } catch (error) {
      print("Error adding item to cart: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred while adding item to cart.")),
      );
    }
  }

  Future<void> _logout() async {
    // Hapus semua data dari Secure Storage
    await _secureStorage.deleteAll();

    // Navigasi ke halaman loginPage
    Navigator.pushReplacementNamed(context, '/loginPage');
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
        onLogoPressed: () {
          Navigator.pushNamed(context, '/homePage'); // Navigasi ke halaman riwayat pesanan
        },
        onPersonPressed: () {
          // Lebar layar
          double screenWidth = MediaQuery.of(context).size.width;

          // Tampilkan menu di kanan atas layar
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              screenWidth - 200, // Jarak dari kiri layar (200 = lebar pop-up)
              50, // Jarak dari atas layar (50 = tinggi posisi logo "person")
              16, // Jarak dari kanan layar (padding opsional)
              0,  // Tidak ada offset di bawah
            ),
            items: [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    Navigator.pop(context); // Tutup menu
                    await _logout(); // Panggil fungsi logout
                  },
                ),
              ),
            ],
          );
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
                      Image.network(
                        product.product_image!,
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
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.product_name!,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.product_description!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Select Size',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: size.map((currentSize) {
                            final isSelected = selectedSize == currentSize;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = currentSize;
                                  quantity = 0;
                                });
                                getProductStock(product.product_name!, currentSize);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blueAccent : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.blueAccent : Colors.black,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  currentSize,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
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
                        if (stok != null)
                          Text(
                            'Stock: $stok',
                            style: const TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: quantity > 0 && selectedSize != null && productId != null
                              ? () => _addToCart(product)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Add to Cart',
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
