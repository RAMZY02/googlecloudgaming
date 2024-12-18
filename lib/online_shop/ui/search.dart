import 'package:flutter/material.dart';
import 'navbar.dart';

class Search extends StatelessWidget {
  final String? initialQuery;

  Search({Key? key, this.initialQuery}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        String? searchQuery = initialQuery;

        // Filter products based on search query
        final filteredProducts = searchQuery == null || searchQuery.isEmpty
            ? allProducts
            : allProducts.where((product) {
          final name = product['name']!.toLowerCase();
          final query = searchQuery?.toLowerCase();
          return name.contains(query);
        }).toList();

        return Scaffold(
          appBar: Navbar(
            isSearching: true,
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            onToggleSearch: () {
              print('Search toggled');
            },
            onCartPressed: () {
              print('Keranjang dibuka');
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2, // Responsif
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7, // Sesuaikan tinggi card
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Image.asset(
                            product['image']!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image),
                                ),
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
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Size: ${product['size']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
