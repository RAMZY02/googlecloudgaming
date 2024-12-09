import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'navbar.dart'; // Import Navbar dari navbar.dart

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  String? searchQuery = null; // Default searchQuery adalah null
  final List<Map<String, String>> carouselItems = [
    {'image': 'assets/carousel1.jpg', 'label': 'Promo 1'},
    {'image': 'assets/carousel2.jpg', 'label': 'Promo 2'},
    {'image': 'assets/carousel3.jpg', 'label': 'Promo 3'},
  ];

  final List<Map<String, String>> allProducts = [
    {'name': 'Nike Roshe Run', 'price': '900.000', 'image': 'assets/nike.jpg'},
    {'name': 'Reebok Rush', 'price': '560.000', 'image': 'assets/reebok.jpg'},
    {'name': 'Adidas Fury', 'price': '770.000', 'image': 'assets/adidas.jpeg'},
    {'name': 'Adidas Neo Racer', 'price': '700.000', 'image': 'assets/neo.jpg'},
    {'name': 'Adidas AX2 Full Black', 'price': '800.000', 'image': 'assets/ax2.jpg'},
    {'name': 'Adidas Zoom', 'price': '500.000', 'image': 'assets/zoom.jpeg'},
  ];

  // Fungsi untuk menangani klik kategori
  void _handleCategoryClick(String category) {
    setState(() {
      searchQuery = null; // Set searchQuery ke null
      isSearching = false; // Keluar dari mode pencarian
    });
    print('$category dipilih');
  }

  @override
  Widget build(BuildContext context) {
    // Filter produk berdasarkan searchQuery
    final filteredProducts = searchQuery == null || searchQuery!.isEmpty
        ? allProducts
        : allProducts.where((product) {
      final name = product['name']!.toLowerCase();
      final query = searchQuery!.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      appBar: Navbar(
        isSearching: isSearching,
        searchQuery: searchQuery,
        onSearchChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        onToggleSearch: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              searchQuery = null; // Hapus query pencarian saat menutup search
            }
          });
        },
        onCartPressed: () {
          print('Keranjang dibuka');
        },
        onCategorySelected: _handleCategoryClick, // Handle kategori
      ),
      body: searchQuery != null
          ? (filteredProducts.isEmpty
          ? Center(
        child: Text(
          'Tidak ada hasil untuk: "$searchQuery"',
          style: const TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800
                ? (constraints.maxWidth > 1200 ? 4 : 3)
                : 2;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
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
                              top: Radius.circular(12)),
                          child: Image.asset(
                            product['image']!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(Icons.broken_image,
                                  size: 50);
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
                              product['name']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp. ${product['price']}',
                              style: const TextStyle(color: Colors.green),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => print(
                                  '${product['name']} dibeli'),
                              icon: const Icon(Icons.shopping_cart,
                                  size: 16),
                              label: const Text('Beli',
                                  style: TextStyle(fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ))
          : CarouselSlider(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          item['label']!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
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
    );
  }
}
