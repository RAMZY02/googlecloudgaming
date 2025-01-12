import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:steppa/online_shop/models/add_to_cart.dart';
import '../controller/cart_controller.dart';
import '../controller/payment_controller.dart';
import '../controller/customer_controller.dart';
import '../models/cart_item.dart';
import '../models/update_cart_item.dart';
import '../models/customer_register.dart';
import 'navbar.dart';
import 'dart:html' as html; // For Flutter Web

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
  final CustomerController customerController = CustomerController();
  final PaymentController paymentController = PaymentController();

  List<CartItem> itemOnCart = [];
  Customer? customer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
    fetchCustomerData();
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

  Future<void> _logout() async {
    // Hapus semua data dari Secure Storage
    await _secureStorage.deleteAll();

    // Navigasi ke halaman loginPage
    Navigator.pushReplacementNamed(context, '/loginPage');
  }

  Future<void> fetchCustomerData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _getJwtTokenAndCustomerId();

      if (customerId != null && jwtToken != null) {
        final fetchedCustomer = await customerController.getCustomerById(customerId!, jwtToken!);
        setState(() {
          customer = fetchedCustomer;
          print(customer?.email);
        });
      }
    } catch (error) {
      print('Error fetching customer data: $error');
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

  void _navigateToPayment() async {
    try {
      await _getJwtTokenAndCustomerId();
      if (customerId != null && jwtToken != null) {
        final carts = await cartController.getCartsByCustomerId(
          customerId!,
          jwtToken!,
        );

        print("masuk");

        final cartId = carts.first.cartId;
        if (cartId != null) {
          final customerDetails = {
            'customer_id': customerId,
            'email': customer?.email,
            'phone': customer?.phoneNumber,
          };

        print("masuk 2");
          // Request pembayaran melalui payment controller
          final payment = await paymentController.checkout(cartId, customerDetails, jwtToken!);

          // Buka halaman Snap Midtrans di tab baru
          html.window.open(payment.paymentUrl, '_blank');
        } else {
          print('Cart ID is null.');
        }
      }
    } catch (error) {
      print('Failed to proceed to payment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to proceed to payment.')),
      );
    }
  }

  Future<void> removeCartItemByCartId(String cartItemId) async {
    try {
      await cartController.removeCartItemById(cartItemId, jwtToken!);
      setState(() {
        itemOnCart.removeWhere((item) => item.cartItemId == cartItemId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed successfully.')),
      );
    } catch (error) {
      print('Error removing cart item: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove item.')),
      );
    }
  }

  Future<void> showRemoveItemDialog(String cartItemId) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text('Are you sure you want to remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldRemove == true) {
      await removeCartItemByCartId(cartItemId);
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
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, color: Colors.white),
                                          iconSize: 16,
                                          onPressed: itemOnCart[index].quantity > 1
                                              ? () async {
                                            final previousQty = itemOnCart[index].quantity;
                                            final previousPrice = itemOnCart[index].price;
                                            setState(() {
                                              itemOnCart[index] = itemOnCart[index].copyWith(price: previousPrice/previousQty * (previousQty - 1) );
                                              itemOnCart[index] = itemOnCart[index].copyWith(quantity: previousQty - 1);
                                            });

                                            final success = await cartController.updateCartItemQuantity(
                                              UpdateCartItemRequest(
                                                cartItemId: itemOnCart[index].cartItemId,
                                                quantity: itemOnCart[index].quantity,
                                              ),
                                              jwtToken!,
                                            );

                                            if (!success) {
                                              setState(() {
                                                itemOnCart[index] = itemOnCart[index].copyWith(quantity: previousQty);
                                              });
                                            }
                                          }
                                              : () async {
                                            final shouldRemove = await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Hapus Item'),
                                                  content: const Text('Apakah Anda yakin ingin menghapus item ini dari keranjang?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: const Text('Batal'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: const Text('Hapus'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (shouldRemove == true) {
                                              await removeCartItemByCartId(itemOnCart[index].cartItemId);
                                            }
                                          },
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            shape: const CircleBorder(),
                                            padding: const EdgeInsets.all(4),
                                            minimumSize: const Size(24, 24),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 35,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(fontSize: 12),
                                            controller: TextEditingController(
                                              text: itemOnCart[index].quantity.toString(),
                                            ),
                                            onSubmitted: (value) async {
                                              final newQty = int.tryParse(value) ?? itemOnCart[index].quantity;
                                              final previousQty = itemOnCart[index].quantity;

                                              if (newQty >= 0) {
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
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          iconSize: 16,
                                          onPressed: () async {
                                            final previousQty = itemOnCart[index].quantity;
                                            final previousPrice = itemOnCart[index].price;
                                            setState(() {
                                              itemOnCart[index] = itemOnCart[index].copyWith(price: previousPrice/previousQty * (previousQty + 1) );
                                              itemOnCart[index] = itemOnCart[index].copyWith(quantity: previousQty + 1);
                                            });

                                            final success = await cartController.updateCartItemQuantity(
                                              UpdateCartItemRequest(
                                                cartItemId: itemOnCart[index].cartItemId,
                                                quantity: itemOnCart[index].quantity,
                                              ),
                                              jwtToken!,
                                            );

                                            if (!success) {
                                              setState(() {
                                                itemOnCart[index] = itemOnCart[index].copyWith(quantity: previousQty);
                                              });
                                            }
                                          },
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            shape: const CircleBorder(),
                                            padding: const EdgeInsets.all(4),
                                            minimumSize: const Size(24, 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp${(itemOnCart[index].price).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
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
              ),
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
                        'Rp${(itemOnCart.fold(0.0, (sum, item) => sum + (item.price))).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
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
                        'Rp${(itemOnCart.fold(0.0, (sum, item) => sum + (item.price)) + 30000).toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
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
                    onPressed: _navigateToPayment,
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
