import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      return name.contains(query); // Produk yang sesuai dengan query
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari Barang, Kategori...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value; // Update query pencarian
            });
          },
          onSubmitted: (value) {
            print("Mencari: $value");
          },
        )
            : Text('GALERI SEPATU', style: TextStyle(color: Colors.white)),
        actions: [
          if (!isSearching)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true; // Masuk mode pencarian
                });
              },
            ),
          if (isSearching)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  isSearching = false; // Keluar mode pencarian
                  searchQuery = ''; // Reset query pencarian
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Aksi ikon keranjang
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Kategori & Populer',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Bagian kategori
            ListTile(
              title: Text('Kategori'),
              leading: Icon(Icons.category),
            ),
            ListTile(
              title: Text('Adidas (3)'),
              leading: Icon(Icons.check_circle),
            ),
            ListTile(
              title: Text('Reebok (2)'),
              leading: Icon(Icons.check_circle),
            ),
            ListTile(
              title: Text('Nike (1)'),
              leading: Icon(Icons.check_circle),
            ),
            Divider(),
            // Bagian populer
            ListTile(
              title: Text('Populer'),
              leading: Icon(Icons.star),
            ),
            ListTile(
              title: Text('Sepatu Reebok - Rp. 560.000'),
              onTap: () {
                // Logika aksi
              },
            ),
            ListTile(
              title: Text('Sepatu Adidas - Rp. 700.000'),
              onTap: () {
                // Logika aksi
              },
            ),
          ],
        ),
      ),
      body: filteredProducts.isEmpty
          ? Center(
        child: Text(
          'Tidak ada hasil untuk: "$searchQuery"',
          style: TextStyle(fontSize: 18),
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth; // Menyimpan lebar maksimal kartu
          // Menentukan jumlah kolom berdasarkan lebar layar
          int crossAxisCount = 2; // Default untuk layar kecil
          if (constraints.maxWidth > 800) {
            crossAxisCount = 3; // 3 kolom untuk layar medium
          }
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 4; // 4 kolom untuk layar besar (desktop)
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75, // Menentukan rasio tinggi dan lebar card
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Flexible(
                          fit: FlexFit.tight,
                          child: Image.asset(
                            product['image']!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: constraints.maxWidth > 1200 ? 150 : 140, // Responsif, lebih besar untuk layar besar
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 50);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nama produk
                                Text(
                                  product['name']!.length > 14 ?
                                  "${product['name']!.substring(0, 13)}..." :
                                  product['name']!,
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth > 1200 ? 16 : 8, // Ukuran font lebih besar di layar besar
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4), // Spasi antara nama produk dan harga
                                // Harga produk
                                Text(
                                  "Rp. ${product['price']}",
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth > 1200 ? 14 : 6, // Ukuran font lebih besar di layar besar
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            // Tombol Beli dengan ikon keranjang
                            ElevatedButton.icon(
                              onPressed: () {
                                // Aksi ketika tombol ditekan
                                print('Menambahkan ${product['name']} ke keranjang');
                              },
                              icon: Icon(Icons.shopping_cart, size: constraints.maxWidth > 1200 ? 14 : 8), // Ukuran ikon yang lebih kecil
                              label: Text(
                                'Beli',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth > 1200 ? 14 : 8, // Ukuran teks yang lebih kecil
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Padding lebih kecil untuk tombol
                                minimumSize: Size(40, 15), // Ukuran minimal tombol (lebar dan tinggi)
                                backgroundColor: Colors.green, // Warna latar belakang tombol
                                foregroundColor: Colors.white, // Warna teks dan ikon tombol
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      )
    );
  }
}
