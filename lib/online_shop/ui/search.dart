import 'package:flutter/material.dart';
import '../models/product.dart';
import 'detail_product.dart';
import 'navbar.dart';

class Search extends StatefulWidget {
  final String? initialQuery;
  const Search({Key? key, this.initialQuery}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<Product> allProducts = [
    Product(
      product_id: '1',
      product_name: 'Nike Roshe Run',
      product_image: 'assets/nike.jpg',
      product_description: 'Sepatu lari ringan dan nyaman dengan desain minimalis, cocok untuk penggunaan sehari-hari.',
      product_category: 'sport',
      product_gender: 'male',
      product_size: ['35', '36', '37', '38', '39', '40'],
      stock_qty: 60,
      price: 900000,
    ),
    Product(
      product_id: '2',
      product_name: 'Reebok Rush',
      product_image: 'assets/reebok.jpg',
      product_description: 'Sepatu lari dengan teknologi responsif untuk performa maksimal, dirancang khusus untuk wanita.',
      product_category: 'sport',
      product_gender: 'female',
      product_size: ['35', '36', '37', '38', '39', '40', '41', '42', '43', '44'],
      stock_qty: 20,
      price: 500000,
    ),
    Product(
      product_id: '3',
      product_name: 'Adidas Fury',
      product_image: 'assets/adidas.jpeg',
      product_description: 'Sepatu kasual dengan desain futuristik dan nyaman dipakai sehari-hari, ideal untuk pria yang menginginkan gaya modern.',
      product_category: 'kets',
      product_gender: 'male',
      product_size: ['38', '39', '40', '41', '42', '43', '44', '45'],
      stock_qty: 80,
      price: 770000,
    ),
    Product(
      product_id: '4',
      product_name: 'Adidas Neo Racer',
      product_image: 'assets/neo.jpg',
      product_description: 'Sepatu ringan dan fleksibel untuk aktivitas sehari-hari, dirancang khusus untuk wanita.',
      product_category: 'sport',
      product_gender: 'female',
      product_size: ['33', '34', '35', '36', '37', '38'],
      stock_qty: 20,
      price: 700000,
    ),
    Product(
      product_id: '5',
      product_name: 'Adidas AX2 Full Black',
      product_image: 'assets/ax2.jpg',
      product_description: 'Sepatu outdoor dengan desain tangguh dan tahan lama, cocok untuk pria yang menyukai aktivitas luar ruangan.',
      product_category: 'casual',
      product_gender: 'male',
      product_size: ['36', '37', '38', '39', '40', '41', '42', '43'],
      stock_qty: 40,
      price: 800000,
    ),
    Product(
      product_id: '6',
      product_name: 'Adidas Zoom',
      product_image: 'assets/zoom.jpeg',
      product_description: 'Sepatu kasual dengan desain modern dan nyaman untuk penggunaan sehari-hari, ideal untuk wanita yang menginginkan gaya trendi.',
      product_category: 'casual',
      product_gender: 'female',
      product_size: ['32', '33', '34', '35', '36', '37', '38', '39', '40', '41'],
      stock_qty: 40,
      price: 500000,
    ),
  ];

  String? searchQuery;

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialQuery;
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      performSearch(searchQuery!);
    }
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = searchQuery == null || searchQuery!.isEmpty
        ? allProducts
        : allProducts.where((product) {
      final name = product.product_name.toLowerCase();
      final query = searchQuery?.toLowerCase() ?? '';
      return name.contains(query);
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
          Navigator.pushNamed(context, '/cartPage');
        },
        onHistoryPressed: () {
          Navigator.pushNamed(context, '/orderHistoryPage');
        },
        onSearchSubmitted: performSearch,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Menambahkan padding kiri dan kanan secara global
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
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
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
                  arguments: product,
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
                          product.product_image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 40),
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
                            product.product_name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${product.price}',
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
                                'Size: ${product.product_size.join(", ")}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
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