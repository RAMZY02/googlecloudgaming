import 'dart:math';
import '../models/product.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'navbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  String? searchQuery;

  final List<Map<String, String>> carouselItems = [
    {'image': 'assets/carousel1.jpg', 'label': 'Promo 1'},
    {'image': 'assets/carousel2.jpg', 'label': 'Promo 2'},
    {'image': 'assets/carousel3.jpg', 'label': 'Promo 3'},
  ];

  final List<Product> newRelease = [
    /*Product(
      product_id: '1',
      product_name: 'Nike Roshe Run',
      product_image: 'assets/nike.jpg',
      product_description: 'Sepatu lari ringan dan nyaman dengan desain minimalis, cocok untuk penggunaan sehari-hari.',
      product_category: 'sport',
      product_gender: 'male',
      product_size: '37',
      stok_qty: 60,
      price: 900000,
    ),
    Product(
      product_id: '2',
      product_name: 'Reebok Rush',
      product_image: 'assets/reebok.jpg',
      product_description: 'Sepatu lari dengan teknologi responsif untuk performa maksimal, dirancang khusus untuk wanita.',
      product_category: 'sport',
      product_gender: 'female',
      product_size: '39',
      stok_qty: 20,
      price: 500000,
    ),
    Product(
      product_id: '3',
      product_name: 'Adidas Fury',
      product_image: 'assets/adidas.jpeg',
      product_description: 'Sepatu kasual dengan desain futuristik dan nyaman dipakai sehari-hari, ideal untuk pria yang menginginkan gaya modern.',
      product_category: 'kets',
      product_gender: 'male',
      product_size: '40',
      stok_qty: 80,
      price: 770000,
    ),
    Product(
      product_id: '4',
      product_name: 'Adidas Neo Racer',
      product_image: 'assets/neo.jpg',
      product_description: 'Sepatu ringan dan fleksibel untuk aktivitas sehari-hari, dirancang khusus untuk wanita.',
      product_category: 'sport',
      product_gender: 'female',
      product_size: '37',
      stok_qty: 20,
      price: 700000,
    ),
    Product(
      product_id: '5',
      product_name: 'Adidas AX2 Full Black',
      product_image: 'assets/ax2.jpg',
      product_description: 'Sepatu outdoor dengan desain tangguh dan tahan lama, cocok untuk pria yang menyukai aktivitas luar ruangan.',
      product_category: 'casual',
      product_gender: 'male',
      product_size: '38',
      stok_qty: 40,
      price: 800000,
    ),
    Product(
      product_id: '6',
      product_name: 'Adidas Zoom',
      product_image: 'assets/zoom.jpeg',
      product_description: 'Sepatu kasual dengan desain modern dan nyaman untuk penggunaan sehari-hari, ideal untuk wanita yang menginginkan gaya trendi.',
      product_category: 'casual',
      product_gender: 'female',
      product_size: '36',
      stok_qty: 40,
      price: 500000,
    ),*/
  ];

  final List<String> size = ['35', '36', '37', '38', '39', '40'];

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
            _buildNewReleaseCarousel(context),
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
                  Image.asset(
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
                /*Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      item.product_image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                ),*/
                /*Padding(
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
                ),*/
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
