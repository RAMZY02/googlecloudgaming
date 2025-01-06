import 'package:flutter/material.dart';
import '../models/product_card.dart';
import '../controller/product_controller.dart'; // Import controller untuk fetch data
import 'detail_product.dart';
import 'navbar.dart';

class Search extends StatefulWidget {
  final String? initialQuery;
  const Search({Key? key, this.initialQuery}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ProductController productController = ProductController(); // Inisialisasi controller
  List<Product_Cart> allProducts = []; // List untuk menyimpan data produk
  final List<String> size = ['35', '36', '37', '38', '39', '40'];
  String? searchQuery;
  bool isLoading = true; // Untuk menampilkan loading saat data di-fetch

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialQuery;
    fetchProducts(); // Panggil fungsi untuk fetch data dari database
  }

  // Fungsi untuk mengambil data produk dari controller
  Future<void> fetchProducts() async {
    try {
      List<Product_Cart> products = await productController.getAllProducts(); // Memanggil controller untuk mendapatkan data produk
      setState(() {
        allProducts = products; // Menyimpan data produk yang didapat ke variabel allProducts
        isLoading = false; // Mengubah status loading
      });
      // Lakukan pencarian jika ada query awal
      if (searchQuery != null && searchQuery!.isNotEmpty) {
        performSearch(searchQuery!);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching products: $e"); // Menampilkan error jika pengambilan data gagal
    }
  }

  // Fungsi untuk melakukan pencarian berdasarkan query
  void performSearch(String query) {
    setState(() {
      searchQuery = query.trim(); // Menghapus spasi di awal dan akhir query pencarian
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menyaring produk berdasarkan query pencarian
    final filteredProducts = searchQuery == null || searchQuery!.isEmpty
        ? allProducts // Jika tidak ada query pencarian, tampilkan semua produk
        : allProducts.where((product) {
      final name = product.product_name!.toLowerCase();
      final query = searchQuery?.toLowerCase() ?? '';
      return name.contains(query); // Menyaring produk yang sesuai dengan query pencarian
    }).toList();

    return Scaffold(
      appBar: Navbar(
        isSearching: true,
        onSearchChanged: (value) {}, // Tidak digunakan untuk pencarian langsung
        onToggleSearch: () {
          setState(() {
            searchQuery = ''; // Reset pencarian
          });
        },
        onCartPressed: () {
          Navigator.pushNamed(context, '/cartPage'); // Navigasi ke halaman keranjang
        },
        onHistoryPressed: () {
          Navigator.pushNamed(context, '/orderHistoryPage'); // Navigasi ke halaman riwayat pesanan
        },
        onSearchSubmitted: performSearch, // Pencarian yang dilakukan saat submit
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator saat data masih diambil
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  arguments: product, // Mengirim data produk ke halaman detail
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
                        child: Image.network(
                          product.product_image!, // Menampilkan gambar produk
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
                            product.product_name!,
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
                                'Size: 35-40',
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
