import 'package:flutter/material.dart';
import 'navbar.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({Key? key}) : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  bool isSearching = false;
  String? searchQuery;

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
    final Map<String, dynamic> product =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

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
          setState(() {
            isSearching = !isSearching;
          });
        },
        onCartPressed: () {
          print('Keranjang dibuka');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 64),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Basketball Shoes',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${product['price']}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product['size']
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
                  child: Text(size),
                ),
              )
                  .toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                print('Add to Bag: ${product['name']}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Add to Bag',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
