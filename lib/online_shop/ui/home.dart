import 'dart:math';
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

  List<Product_Cart> newRelease = [];
  bool isLoading = true;

  final List<Map<String, String>> carouselItems = [
    {'image': 'assets/carousel1.jpg', 'label': 'Promo 1'},
    {'image': 'assets/carousel2.jpg', 'label': 'Promo 2'},
    {'image': 'assets/carousel3.jpg', 'label': 'Promo 3'},
  ];

  final List<String> size = ['35', '36', '37', '38', '39', '40'];

  // Secure Storage instance
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

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
  void initState() {
    super.initState();
    searchQuery = widget.initialQuery;
    fetchProducts(); // Fetch products
    _getJwtToken(); // Get JWT token from secure storage
  }

  Future<void> fetchProducts() async {
    try {
      List<Product_Cart> products = await productController.getNewReleaseProducts();
      if (products != null) {
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

  // Get JWT Token from secure storage
  Future<void> _getJwtToken() async {
    try {
      String? jwtToken = await _secureStorage.read(key: 'jwt_token');
      if (jwtToken != null) {
        print("JWT Token: $jwtToken"); // Print JWT token
      } else {
        print("No JWT token found.");
      }
    } catch (e) {
      print("Error retrieving JWT token: $e");
    }
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
        height: MediaQuery.of(context).size.width * 0.3,
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
    return CarouselSlider(
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
                      item.product_image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
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
                        item.product_name,
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
    );
  }
}
