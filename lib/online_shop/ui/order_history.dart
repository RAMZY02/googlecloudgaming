import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'navbar.dart';
import '../controller/history_controller.dart';
import '../models/history_item.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool isSearching = false;
  String? searchQuery;
  String? jwtToken;
  String? customerId;
  late Future<List<HistoryItem>> purchaseHistory;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final PurchaseHistoryController controller =
  PurchaseHistoryController(baseUrl: 'http://10.10.2.49:3000');

  @override
  void initState() {
    super.initState();
    purchaseHistory = _getPurchaseHistory(); // Panggil fungsi untuk inisialisasi data
  }

  Future<List<HistoryItem>> _getPurchaseHistory() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
      customerId = await _secureStorage.read(key: 'customer_id');

      if (customerId != null && jwtToken != null) {
        return controller.getPurchaseHistory(customerId!, jwtToken!);
      } else {
        throw Exception("Missing customer ID or JWT token.");
      }
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
      throw Exception("Failed to load purchase history.");
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

  Future<void> _logout() async {
    // Hapus semua data dari Secure Storage
    await _secureStorage.deleteAll();

    // Navigasi ke halaman loginPage
    Navigator.pushReplacementNamed(context, '/loginPage');
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
          Navigator.pushNamed(context, '/searchPage');
        },
        onCartPressed: () {
          Navigator.pushNamed(context, '/cartPage');
        },
        onHistoryPressed: () {
          Navigator.pushNamed(context, '/orderHistoryPage');
        },
        onLogoPressed: () {
          Navigator.pushNamed(context, '/homePage');
        },
        onPersonPressed: () {
          double screenWidth = MediaQuery.of(context).size.width;

          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              screenWidth - 200,
              50,
              16,
              0,
            ),
            items: [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _logout();
                  },
                ),
              ),
            ],
          );
        },
      ),
      body: FutureBuilder<List<HistoryItem>>(
        future: purchaseHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No purchase history available.'),
            );
          } else {
            final items = snapshot.data!;
            return Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        item.productImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                      title: Text(item.productName),
                      subtitle: Text(
                        'Quantity: ${item.quantity}\nPrice: Rp${item.price.toStringAsFixed(0)}',
                      ),
                      trailing: const Text(
                        'Purchased',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
