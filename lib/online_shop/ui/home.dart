import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/product_card.dart';
import '../controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'navbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.initialQuery}) : super(key: key);
  final String? initialQuery;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ProductController productController = ProductController();
  bool isSearching = false;
  String? searchQuery;
  String? jwtToken;
  String? customerId;

  List<Product_Cart> newRelease = [];
  bool isLoading = true;

  final storageRef = FirebaseStorage.instance.ref();

  String? _imageUrl;

  Future<void> _getImage() async {
    final downloadURL = await storageRef.getDownloadURL();
    setState(() {
      _imageUrl = downloadURL;
    });
  }

  final List<Map<String, String>> carouselItems = [
    {'image': 'assets/carousel1.jpg', 'label': 'Promo 1'},
    {'image': 'assets/carousel2.jpg', 'label': 'Promo 2'},
    {'image': 'assets/carousel3.jpg', 'label': 'Promo 3'},
  ];

  final List<Map<String, String>> categories = [
    {'image': 'assets/sport.jpg', 'label': 'Sport'},
    {'image': 'assets/casual.jpg', 'label': 'Casual'},
    {'image': 'assets/running.jpg', 'label': 'Running'},
  ];

  final List<String> size = ['35', '36', '37', '38', '39', '40'];

  // Secure Storage instance
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  void _navigateToSearch(dynamic value) {
    Navigator.pushNamed(
      context,
      '/searchPage',
      arguments: value,
    );
  }

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialQuery;
    fetchProducts(); // Fetch products
    _getJwtToken(); // Get JWT token from secure storage
  }

  Future<String> getFirebaseImageUrl(String imagePath) async {
    try {
      print(imagePath);
      final ref = FirebaseStorage.instance.ref(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error fetching image URL: $e");
      return ''; // URL fallback jika terjadi error
    }
  }

  Future<void> fetchProducts() async {
    try {
      List<Product_Cart> products = await productController.getNewReleaseProducts();
      if (products != null) {
        for (var product in products) {
          if (product.product_image != null) {
            product.product_image = await getFirebaseImageUrl(product.product_image!);
          }
        }
        setState(() {
          newRelease = products;
          isLoading = false;
        });
      } else {
        setState(() {
          newRelease = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  Future<void> _getJwtToken() async {
    try {
      jwtToken = await _secureStorage.read(key: 'jwt_token');
      customerId = await _secureStorage.read(key: 'customer_id');
    } catch (e) {
      print("Error retrieving data from Secure Storage: $e");
    }
  }

  Future<void> _logout() async {
    // Hapus semua data dari Secure Storage
    await _secureStorage.deleteAll();

    // Navigasi ke halaman loginPage
    Navigator.pushReplacementNamed(context, '/loginPage');
  }

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
          _navigateToSearch(searchQuery!);
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildCarousel(),
            _buildNewReleaseSectionTitle(context),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildNewReleaseCarousel(context),
            _buildCategoryCards(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      items: carouselItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50);
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        item['label']!,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: MediaQuery.of(context).size.width * 0.4,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
        initialPage: 0,
      ),
    );
  }

  Widget _buildNewReleaseSectionTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.width > 600
            ? MediaQuery.of(context).size.height * 0.1
            : 30.0,
        bottom: MediaQuery.of(context).size.height > 600
            ? MediaQuery.of(context).size.height * 0.02
            : 0.5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: Text(
            '────────     New Release     ────────',
            style: TextStyle(
              fontSize: min(MediaQuery.of(context).size.width * 0.03, 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewReleaseCarousel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0), // Tambahkan margin horizontal
      child: CarouselSlider(
        items: newRelease.map((item) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detailProductPage',
                arguments: item,
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        item.product_image ?? '',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover, // Gunakan URL kosong jika _imageUrl tidak tersedia
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child; // Gambar selesai dimuat
                          return Center(
                            child: CircularProgressIndicator(), // Placeholder loading (opsional)
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image, // Placeholder broken image
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product_name!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp. ${item.price}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.35 > 300
              ? 300
              : MediaQuery.of(context).size.height * 0.35,
          enlargeCenterPage: false,
          viewportFraction: MediaQuery.of(context).size.width > 600
              ? 0.30
              : MediaQuery.of(context).size.width > 300
              ? 0.33
              : 0.9,
          autoPlay: false,
          enableInfiniteScroll: true,
        ),
      ),
    );
  }

  Widget _buildCategoryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 72.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () => _navigateToSearch(category['label']!),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      category['image']!,
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.width * 0.40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height < 600 ? 5 : 60, // Bottom dinamis
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category['label']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 32, // Ukuran dinamis
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kenyamanan sepatu kategori ${category['label']} membuat aktivitas lebih menyenangkan.',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 18, // Ukuran dinamis
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
