import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:steppa/online_shop/models/addTocart.dart';
import '../controller/cart_controller.dart';
import '../models/cart_item.dart';
import '../models/update_cart_item.dart';
import 'navbar.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isSearching = false;
  String? searchQuery;
  String? jwtToken;
  String? customerId;
  String? cartId;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final CartController cartController = CartController();

  List<CartItem> itemOnCart = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> _getJwtTokenAndCustomerId() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
      customerId = await _secureStorage.read(key: 'customer_id');

      if (jwtToken == null) {
        print("No JWT token found.");
      } else {
        print("JWT Token: $jwtToken");
      }

      if (customerId == null) {
        print("No Customer ID found.");
      } else {
        print("Customer ID: $customerId");
      }
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
    }
  }

  Future<void> fetchCartItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _getJwtTokenAndCustomerId();

      if (customerId != null && jwtToken != null) {
        final carts = await cartController.getCartsByCustomerId(
          customerId!,
          jwtToken!,
        );

        if (carts.isNotEmpty) {
          final cartId = carts.first.cartId;

          if (cartId != null) {
            List<CartItem> allItems = await cartController.getCartItemsByCartId(
              cartId,
              jwtToken!,
            );

            setState(() {
              itemOnCart = allItems;
            });
          } else {
            print("Cart ID is null.");
          }
        } else {
          print("No carts found for the customer ID.");
        }
      } else {
        print("Customer ID or JWT token is null.");
      }
    } catch (error) {
      print('Error fetching cart items: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: itemOnCart.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            itemOnCart[index].productImage,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemOnCart[index].productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Ukuran: ${itemOnCart[index].productSize}'),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Jumlah:'),
                                    DropdownButton<int>(
                                      value: itemOnCart[index].quantity, // Mengambil nilai kuantitas item yang sesuai
                                      items: List.generate(10, (index) => index + 1)
                                          .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text('$value'),
                                      ))
                                          .toList(),
                                      onChanged: (newQty) async {
                                        if (newQty != null) {
                                          final previousQty = itemOnCart[index].quantity;
                                          setState(() {
                                            itemOnCart[index] = itemOnCart[index].copyWith(quantity: newQty);
                                          });

                                          final success = await cartController.updateCartItemQuantity(
                                            UpdateCartItemRequest(
                                              cartItemId: itemOnCart[index].cartItemId,
                                              quantity: newQty,
                                            ),
                                            jwtToken!,
                                          );

                                          if (!success) {
                                            setState(() {
                                              itemOnCart[index] = itemOnCart[index].copyWith(quantity: previousQty);
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp${(itemOnCart[index].price * itemOnCart[index].quantity).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ORDER SUMMARY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      Text(
                        'Rp${(itemOnCart.fold(0.0, (sum, item) => sum + (item.price * item.quantity)) + 30000).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // VAT
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('VAT included:'),
                      Text('Rp 30.000'),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),
                  // Order Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ORDER TOTAL:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Rp${(itemOnCart.fold(0.0, (sum, item) => sum + (item.price * item.quantity)) + 30000).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Checkout Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/checkoutPage');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                          'CHECKOUT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
