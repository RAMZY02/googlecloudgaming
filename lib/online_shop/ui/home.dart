import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'navbar.dart';
import 'search.dart';

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

  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Nike Roshe Run',
      'price': '900.000',
      'image': 'assets/nike.jpg',
      'colors': ['0xFF000000', '0xFFB71C1C', '0xFFFFFFFF'],
      'size': '34-40',
      'gender': 'WANITA',
    },
    {
      'name': 'Reebok Rush',
      'price': '560.000',
      'image': 'assets/reebok.jpg',
      'colors': ['0xFF795548', '0xFFFF5722', '0xFF4CAF50'],
      'size': 'M-XL',
      'gender': '35-44',
    },
    {
      'name': 'Adidas Fury',
      'price': '770.000',
      'image': 'assets/adidas.jpeg',
      'colors': ['0xFF3F51B5', '0xFFFFEB3B'],
      'size': '38-45',
      'gender': 'PRIA',
    },
    {
      'name': 'Adidas Neo Racer',
      'price': '700.000',
      'image': 'assets/neo.jpg',
      'colors': ['0xFF9E9E9E', '0xFF673AB7'],
      'size': '33-38',
      'gender': 'WANITA',
    },
    {
      'name': 'Adidas AX2 Full Black',
      'price': '800.000',
      'image': 'assets/ax2.jpg',
      'colors': ['0xFF000000'],
      'size': '36-43',
      'gender': 'PRIA',
    },
    {
      'name': 'Adidas Zoom',
      'price': '500.000',
      'image': 'assets/zoom.jpeg',
      'colors': ['0xFF2196F3', '0xFF4CAF50'],
      'size': '32-41',
      'gender': 'WANITA',
    },
  ];

  final List<Map<String, String>> newRelease = [
    {'name': 'Nike Roshe Run', 'price': '900.000', 'image': 'assets/nike.jpg'},
    {'name': 'Reebok Rush', 'price': '560.000', 'image': 'assets/reebok.jpg'},
    {'name': 'Adidas Fury', 'price': '770.000', 'image': 'assets/adidas.jpeg'},
    {'name': 'Adidas Neo Racer', 'price': '700.000', 'image': 'assets/neo.jpg'},
    {'name': 'Adidas AX2 Full Black', 'price': '800.000', 'image': 'assets/ax2.jpg'},
    {'name': 'Adidas Zoom', 'price': '500.000', 'image': 'assets/zoom.jpeg'},
  ];

  void _navigateToSearch() {
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Search(initialQuery: searchQuery!),
        ),
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
            searchQuery = value; // Perbarui nilai pencarian saat input berubah
          });
        },
        onSearchSubmitted: (value) {
          setState(() {
            searchQuery = value; // Pastikan nilai pencarian diperbarui
          });
          _navigateToSearch(); // Navigasi ke halaman pencarian saat Enter ditekan
        },
        onToggleSearch: () {
          Navigator.pushNamed(context, '/searchPage'); // Navigasi manual
        },
        onCartPressed: () {
          print('Keranjang dibuka');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            CarouselSlider(
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
            ),
            Container(
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
            ),
            CarouselSlider(
              items: newRelease.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Card(
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
                              child: Image.asset(
                                item['image']!,
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
                                  item['name']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp. ${item['price']}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
