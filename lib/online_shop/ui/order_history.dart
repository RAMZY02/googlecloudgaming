import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'navbar.dart';

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
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getJwtToken();
  }

  Future<void> _getJwtToken() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
      customerId = await _secureStorage.read(key: 'customer_id');
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
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
    );
  }
}