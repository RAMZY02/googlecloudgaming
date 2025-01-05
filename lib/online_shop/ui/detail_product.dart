import 'dart:math'; // Perlu untuk fungsi min
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'navbar.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({Key? key}) : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  bool isSearching = false;
  String? searchQuery;

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
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

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
          setState(() {
            isSearching = !isSearching;
          });
        },
        onCartPressed: () {
          Navigator.pushNamed(context, '/cartPage');
        },
        onHistoryPressed: () {
          Navigator.pushNamed(context, '/orderHistoryPage');
        },
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1000, // Lebar maksimum konten dibatasi 1000 piksel
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Expanded(
                  flex: 6, // Mengubah flex menjadi 6 untuk bagian kiri
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Center(
                      child: Image.asset(
                        product.product_image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 104),
                          );
                        },
                      ),
                    ),
                  ),
                ),*/
                const SizedBox(width: 16),
               /* Expanded(
                  flex: 4, // Mengubah flex menjadi 4 untuk bagian kanan
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 30.0, left: 15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.product_name,
                            style: TextStyle(
                              fontSize: min(MediaQuery.of(context).size.width * 0.09, 24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.product_category,
                            style: TextStyle(
                              fontSize: min(MediaQuery.of(context).size.width * 0.08, 18),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${product.price}',
                            style: TextStyle(
                              fontSize: min(MediaQuery.of(context).size.width * 0.08, 22),
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select Size',
                            style: TextStyle(
                              fontSize: min(MediaQuery.of(context).size.width * 0.08, 20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: size
                                .map<Widget>(
                                  (size) => ElevatedButton(
                                onPressed: () {
                                  print('Size selected: $size');
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.black),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: min(MediaQuery.of(context).size.width * 0.07, 14),
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${product.product_description}',
                            style: TextStyle(
                              fontSize: min(MediaQuery.of(context).size.width * 0.08, 18),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              print('Add to Bag: ${product.product_name}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Text(
                              'Add to Bag',
                              style: TextStyle(
                                fontSize: min(MediaQuery.of(context).size.width * 0.08, 16),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
