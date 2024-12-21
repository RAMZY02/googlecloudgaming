import 'package:flutter/material.dart';
import 'detail_product.dart';
import 'navbar.dart';

class Search extends StatefulWidget {
  final String? initialQuery;

  const Search({Key? key, this.initialQuery}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Nike Roshe Run',
      'price': '900.000',
      'image': 'assets/nike.jpg',
      'colors': ['0xFF000000', '0xFFB71C1C', '0xFFFFFFFF'],
      'size': ['35', '36', '37', '38', '39', '40'],
      'gender': 'FEMALE',
    },
    {
      'name': 'Reebok Rush',
      'price': '560.000',
      'image': 'assets/reebok.jpg',
      'colors': ['0xFF795548', '0xFFFF5722', '0xFF4CAF50'],
      'size': ['35', '36', '37', '38', '39', '40', '41', '42', '43', '44'],
      'gender': 'MALE',
    },
    {
      'name': 'Adidas Fury',
      'price': '770.000',
      'image': 'assets/adidas.jpeg',
      'colors': ['0xFF3F51B5', '0xFFFFEB3B'],
      'size': ['38', '39', '40', '41', '42', '43', '44', '45'],
      'gender': 'MALE',
    },
    {
      'name': 'Adidas Neo Racer',
      'price': '700.000',
      'image': 'assets/neo.jpg',
      'colors': ['0xFF9E9E9E', '0xFF673AB7'],
      'size': ['33', '34', '35', '36', '37', '38'],
      'gender': 'FEMALE',
    },
    {
      'name': 'Adidas AX2 Full Black',
      'price': '800.000',
      'image': 'assets/ax2.jpg',
      'colors': ['0xFF000000'],
      'size': ['36', '37', '38', '39', '40', '41', '42', '43'],
      'gender': 'MALE',
    },
    {
      'name': 'Adidas Zoom',
      'price': '500.000',
      'image': 'assets/zoom.jpeg',
      'colors': ['0xFF2196F3', '0xFF4CAF50'],
      'size': ['32', '33', '34', '35', '36', '37', '38', '39', '40', '41'],
      'gender': 'FEMALE',
    },
  ];

  String? searchQuery;

  @override
  void initState() {
    super.initState();
    // Mengatur nilai awal searchQuery dari initialQuery
    searchQuery = widget.initialQuery;
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter produk berdasarkan searchQuery
    final filteredProducts = searchQuery == null || searchQuery!.isEmpty
        ? allProducts
        : allProducts.where((product) {
      final name = product['name']!.toLowerCase();
      final query = searchQuery?.toLowerCase();
      return name.contains(query!);
    }).toList();

    return Scaffold(
      appBar: Navbar(
        isSearching: true,
        onSearchChanged: (value) {}, // Tidak digunakan untuk pencarian langsung
        onToggleSearch: () {
          setState(() {
            searchQuery = '';
          });
        },
        onCartPressed: () {
          print('Keranjang dibuka');
        },
        onSearchSubmitted: performSearch, // Menjalankan filter saat Enter ditekan
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filteredProducts.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 10),
              Text(
                'Tidak ada produk yang ditemukan.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
            MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detailProductPage',
                  arguments: filteredProducts[index],
                );
              },

              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          product['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image,
                                  size: 40),
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
                            product['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${product['price']}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Size: ${product['size']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const Spacer(),
                              Text(
                                product['gender'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: product['colors']
                                .map<Widget>((color) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 2),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(color)),
                              ),
                            ))
                                .toList(),
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
    );
  }
}
