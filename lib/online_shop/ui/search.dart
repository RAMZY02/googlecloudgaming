import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Search> {
  bool isSearching = false; // Mode pencarian
  String searchQuery = ''; // Query pencarian

  // Data produk
  final List<Map<String, String>> allProducts = [
    {'name': 'Nike Roshe Run', 'price': '900.000', 'image': 'assets/nike.jpg'},
    {'name': 'Reebok Rush', 'price': '560.000', 'image': 'assets/reebok.jpg'},
    {'name': 'Adidas Fury', 'price': '770.000', 'image': 'assets/adidas.jpeg'},
    {'name': 'Adidas Neo Racer', 'price': '700.000', 'image': 'assets/neo.jpg'},
    {'name': 'Adidas AX2 Full Black', 'price': '800.000', 'image': 'assets/ax2.jpg'},
    {'name': 'Adidas Zoom', 'price': '500.000', 'image': 'assets/zoom.jpeg'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filter produk berdasarkan query pencarian
    final List<Map<String, String>> filteredProducts = searchQuery.isEmpty
        ? allProducts
        : allProducts.where((product) {
      final name = product['name']!.toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: isSearching
            ? TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value; // Update query saat mengetik
            });
          },
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari sepatu...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: TextStyle(color: Colors.black),
        )
            : Row(
          children: [
            // Logo Responsif
            Image.asset(
              'assets/logoSteppa.png',
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50);
              },
            ),
            SizedBox(width: 10),

            // Navigasi Kategori
            Row(
              children: ['MEN', 'WOMEN', 'CHILD', 'BABY']
                  .map(
                    (category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      print('$category dipilih');
                    },
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) searchQuery = ''; // Reset query jika keluar dari pencarian
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              // Aksi ikon keranjang
            },
          ),
        ],
      ),
      body: filteredProducts.isEmpty
          ? Center(
        child: Text(
          'Tidak ada hasil untuk: "$searchQuery"',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 800
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
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            product['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 50);
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Rp. ${product['price']}',
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                print('Menambahkan ${product['name']} ke keranjang');
                              },
                              icon: Icon(Icons.shopping_cart, size: 16),
                              label: Text('Beli', style: TextStyle(fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 36),
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
      ),
    );
  }
}
